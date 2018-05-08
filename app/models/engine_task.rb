class EngineTask < ApplicationRecord
  has_many :x_jobs, dependent: :restrict_with_exception
  has_many :engine_task_exceptions, dependent: :restrict_with_exception

  JOB_ENGINES = ['Flancer']

  def self.check_engine(engine:)
    b_ok =  JOB_ENGINES.any? engine
    raise ArgumentError.new( "#{engine.to_s} is not a valid engine name" ) unless b_ok
  end

  def self.each_engine

    JOB_ENGINES.each do |e|
      m = self.module_class_by_engine_name(iid: e)
      yield(e,m)
    end
  end

  #iid can be name:33 or name
  def self.module_class_by_engine_name(iid:)
    raise "need internal id" if iid.blank?
    engine = iid.split(':').first
    case engine
    when 'Flancer'
      return Flancer::FreelanceManager
    else
      raise ArgumentError.new("cannot convert from internal id, engine not recognized [#{engine}]")
    end
  end

  def self.get_stats(engine:,start_range_ts: nil, end_range_ts:nil)
    # is_running
    is_running = is_engine_running(engine: engine)
    number_jobs_in_timerange = get_jobs_found_in_range(engine: engine, start_range_ts: start_range_ts, end_range_ts: end_range_ts)
    exceptions_in_timerange = get_exceptions_found_in_range(engine: engine, start_range_ts: start_range_ts, end_range_ts: end_range_ts)
    return {is_running: is_running,
            number_jobs_in_timerange:number_jobs_in_timerange,
            exceptions: exceptions_in_timerange}
  end

  def self.get_jobs_found_in_range(engine: ,start_range_ts: nil, end_range_ts: nil)
    the = module_class_by_engine_name(iid:engine)
    stats = the.get_post_counts(start_range_ts: start_range_ts, end_range_ts: end_range_ts)
    return stats
  end

  def self.get_exceptions_found_in_range(engine: ,start_range_ts: nil, end_range_ts: nil)
    check_engine(engine: engine)
    where_array = []
    param_hash = {}

    if start_range_ts && end_range_ts
      where_array << "( UNIX_TIMESTAMP(engine_task_exceptions.created_at) between :start_ts and :end_ts)"
      param_hash[:start_ts] = start_range_ts
      param_hash[:end_ts] = end_range_ts
    elsif end_range_ts
      where_array << "( UNIX_TIMESTAMP(engine_task_exceptions.created_at) <= :end_ts)"
      param_hash[:end_ts] = end_range_ts
    elsif start_range_ts
      where_array << "( UNIX_TIMESTAMP(engine_task_exceptions.created_at) >= :start_ts )"
      param_hash[:start_ts] = start_range_ts
    end

    where_array << "( engine = :engine )"
    param_hash[:engine] = engine
    where_sql = where_array.join(' AND ')

    xinfo = EngineTaskException.
        select('count(*) as total,file,exception_class').
        joins("INNER JOIN engine_tasks ON engine_task_exceptions.engine_task_id = engine_tasks.id").
        where(where_sql, param_hash).
        group(:file,:exception_class).
        order('count(*) desc')

    res = []
    xinfo.each do |ex|
      res << {count: ex.total, file: ex.file, exception_class: ex.exception_class}
    end
    return res
  end

  def self.is_engine_running(engine: )
    check_engine(engine: engine)
    # engine is running if is_started but not is_stopped
    en = EngineTask.where("is_started = 1 AND is_stopped = 0").page(1).per(1)
    return false if en.size == 0
    return en.first.start

  end

  # @param engine [String]
  def self.run_engine(engine:)
    check_engine(engine: engine)
    status = is_engine_running(engine: engine)
    return {status: 'already_running', started_at: status} if status
    engine = engine.downcase
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
        etask.is_error = true unless etask.blank?
        etask.save unless etask.blank?
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
    return {status: 'starting'}
  end
end
