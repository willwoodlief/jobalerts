source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
# gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bcrypt', '~> 3.1.7'
gem 'active_model_serializers'
gem 'rack-cors'
gem 'knock'
gem 'jwt'


###############################################################
# store sensitive information into environmental variables that are not checked into git
# https://github.com/laserlemon/figaro
################################################################
gem 'figaro'

##################################
# ###### add in scanner and database for freelancer.com
# ##############
gem 'flancer', path: '/home/will/htdocs/flancer'

#################################
# color library
# ############ https://github.com/jfairbank/chroma
# ########################
gem 'chroma'

# this allows easier reading of objects in the ruby console https://github.com/michaeldv/awesome_print
gem "awesome_print", require:"ap"



#log production environment to syslog (set up in config)
# https://github.com/crohr/syslogger
# until this gem officially updates its version, we have to use the master, but ask it for a passing commit
# because their master has failing builds too
#gem 'syslogger',:git => 'https://github.com/crohr/syslogger', :ref => '33b86102b9f1426a7d8c7dcdfff20d31e571352d'
gem 'syslogger'  #finally updated to 1.6.5 as of this comment

# note rake log:clear # Truncates all *.log files in log/ to zero bytes

# for formatting and minimizing log output https://github.com/roidrage/lograge
gem 'lograge'
