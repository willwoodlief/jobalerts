require "knock"
class JobsController < ApplicationController
  # noinspection RailsParamDefResolve
  before_action :authenticate_user,  only: [:list,:update,:test,:stats,:run]

  def list

    hash = search_params.to_h.clone
    symbolic = hash.symbolize_keys
    symbolic[:star_color] = XJob.color_to_hex_string(color_string: symbolic[:star_color])
    results = []
    meta = {}
    EngineTask.each_engine do |engine_name,engine|
      call = engine.get_posts(symbolic)
      jobs = call[:results]
      meta[engine_name] = call[:meta]
      if jobs
        jobs.each do |j|
          results << XJob.from_native(object_from: j)
        end
      end

    end

    ordered_results = results.sort_by { |a| [ a.created_at, a.engine, a.id ] }.reverse

    Rails.logger.info ordered_results.count.to_s + " jobs found"
    options = {each_serializer: XJobSerializer}
    serializable_resource = ActiveModelSerializers::SerializableResource.new(ordered_results, options)
    model_json = serializable_resource.as_json

    render json: {results: model_json, meta: meta}
  end

  def update
    hash = update_params.to_h.clone
    symbolic = hash.symbolize_keys
    symbolic[:star_color] = XJob.color_to_hex_string(color_string: symbolic[:star_color])
    m  = EngineTask.module_class_by_engine_name(iid: symbolic[:id])
    me = m.new
    internal_id = symbolic[:id]
    symbolic[:id] = XJob.id_by_internal_id(iid: symbolic[:id])
    me.update_post(symbolic)
    reflect_native = XJob.native_by_internal_id(iid: internal_id)
    x_job = XJob.from_native(object_from: reflect_native)
    render json: {  msg: 'job was updated', xjob: x_job.as_json }
  end

  def stats
    hash = stat_params.to_h.clone
    symbolic = hash.symbolize_keys
    the_stats = {}
    EngineTask.each_engine do |engine_name,_|
      params = {engine:engine_name}
      params.merge! symbolic
      s = EngineTask.get_stats(params)
      the_stats[engine_name] = s
    end

    render json: the_stats
  end

  def run
    hash = run_params.to_h.clone
    symbolic = hash.symbolize_keys
    ret = {}
    if (symbolic.key? :engines) && (!symbolic[:engines].blank?)

      symbolic.engines.each do |engine_name|
        res = EngineTask.run_engine(engine:engine_name)
        ret[engine_name] = res
      end

    else
      #run them all
      EngineTask.each_engine do |engine_name,_|
        res = EngineTask.run_engine(engine:engine_name)
        ret[engine_name] = res
      end
    end

    render json: ret
  end

  def test
    engine = 'flancer'
    # @type [EngineTask|nil] etask
    etask = nil
    Thread.new do

      begin
      ActiveRecord::Base.connection_pool.with_connection do
        etask = EngineTask.new
        etask.engine = engine
        etask.task = nil
        etask.save
      end

      eeid = etask.id.to_s
      script_path = Rails.root.to_s + "/lib/bash_scripts/run_engine_task.sh"
      command = "bash #{script_path}"
      rvm_base_path = ENV['RVM_BASE_PATH']
      webjob_path = Rails.root.to_s
      rails_env = Rails.env.to_s
      pid = spawn({
                      "webjob_path" => webjob_path,
                      "rvm_base_directory" =>rvm_base_path ,
                      "eeid" => eeid,
                      "engine" => engine,
                      "rails_environment" => rails_env
                  },
                  command)

      ActiveRecord::Base.connection_pool.with_connection do
        etask.start= Time.now
        # noinspection RubyResolve
        etask.is_started = true
        etask.save
      end


      Process.wait pid

      ActiveRecord::Base.connection_pool.with_connection do
        etask.stop = Time.now
        # noinspection RubyResolve
        etask.is_stopped = true
        etask.save
      end
      rescue => nasty
        m = EngineTaskException.new
        ActiveRecord::Base.connection_pool.with_connection do
          m.engine_task_id = etask.id
          m.exception_class = nasty.class.name.to_s
          m.stack_trace_as_json = nasty.backtrace.to_json
          m.message = nasty.message
          m.save
          Rails.logger.error "Rescued exception from thread creating engine task. Exception id of #{m.id} and " +
                                 m.as_json.to_s
        end
      end
    end

    render json: {engine: engine, message: 'running bash script'}
  end

  private

  # Setting up strict parameters for searching
  def search_params
    # ts_start: nil, ts_end: nil, b_read: false, star_color: [], star_symbol: [],
    #     comment_fragment: nil, page: 1, per_page: 100, order_by: 'created_at', order_dir: 'asc'
    params.require(:list).permit(:ts_start, :ts_end, :b_read, :star_color,:star_symbol,:comment_fragment,
                                 :filter,:page,:per_page)
  end

  def update_params
    # id:, b_read: false, star_color: nil, star_symbol: nil, comment: nil
    params.require(:update).permit(:id, :b_read, :b_read, :star_color,:star_symbol,:comment)
  end

  def stat_params
    # id:, b_read: false, star_color: nil, star_symbol: nil, comment: nil
    params.require(:stats).permit(:start_range_ts, :end_range_ts)
  end

  def run_params
    # id:, b_read: false, star_color: nil, star_symbol: nil, comment: nil
    params.require(:run).permit(:engines)
  end
end
