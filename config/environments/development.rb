Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
        'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load


  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker


  ##########################################################################################
  ########## LOGGER
  ##########################################################################################

  config.log_level = :debug
=begin
  my_locality = Syslog::LOG_LOCAL0
  if File.split($0).last == 'rake'
    my_locality = Syslog::LOG_LOCAL1
  end

  logger = Syslogger.new('webjob', Syslog::LOG_PID | Syslog::LOG_PERROR, my_locality)
  logger.level = Logger::DEBUG # do not write out debug stuff to syslog
  config.logger = ActiveSupport::TaggedLogging.new(logger)
=end

  #comment this out and uncomment above to log to syslog,
  # right now production does syslog and development does regular log
  ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  config.lograge.enabled = true  #turn to false to log partial rendering
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format)
    {
        params: event.payload[:params].except(*exceptions)
    }
  end
  config.lograge.formatter = Lograge::Formatters::Json.new

  #we are not setting the config.log_formatter in development
  ################### END LOGGER SECTION################################

end
