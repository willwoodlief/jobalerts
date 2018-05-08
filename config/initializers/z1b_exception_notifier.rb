ActiveSupport::Notifications.subscribe('notify_exception') do |name, start, finish, id, payload|
  # do some stuff here
  data = payload[:options][:extra]
  eeid = data[:eeid]
  exception = data[:exception]
  files = data[:files]
  extra = data[:extra_message]

  engine_names = EngineTask::JOB_ENGINES.map(&:downcase).map {|x| '/' + x +  '/' }

  if exception.backtrace&.empty?
    file_line = nil
  else
    file_line_index = 0
    file_line = exception.backtrace[file_line_index].to_s
    while (file_line.match(Regexp.union(engine_names)).nil?) &&
          (file_line_index < exception.backtrace.count)
      file_line_index += 1
      file_line = exception.backtrace[file_line_index].to_s
    end
  end

  m = EngineTaskException.new
  ActiveRecord::Base.connection_pool.with_connection do
    m.engine_task_id = eeid
    m.exception_class = exception.class.name.to_s
    m.html_file = files[:html]
    m.snapshot_file = files[:snapshot]
    m.stack_trace_as_json = exception.backtrace.to_json
    m.message = exception.message
    m.extra_message = extra
    m.file = file_line
    m.save

    e = EngineTask.find(eeid)
    e.is_error = true
    e.save
  end


  puts "Entered exception log #{m.id} #{payload[:options][:extra]} and " + m.as_json.to_s
end