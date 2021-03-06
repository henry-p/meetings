source 'https://rubygems.org'


ruby '2.0.0' 
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'google-api-client', :require => 'google/api_client'
gem 'omniauth', '~> 1.2.2'
gem 'omniauth-google-oauth2', :git => 'https://github.com/zquestz/omniauth-google-oauth2.git'
gem 'oauth2'
gem 'google_contacts_api'

gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 3.1.3'

gem 'json'
gem 'redis'

gem 'twitter-bootstrap-rails'

gem 'canonical-emails'

# socket gems
gem 'faye'
gem 'thin'
gem 'private_pub'

gem 'httparty'
gem 'normalize-rails'
gem "font-awesome-rails"
gem 'rails_12factor', group: :production

gem 'sidekiq', '~> 2.17.0'
# sinatra for sidekiq dashboard https://github.com/mperham/sidekiq/wiki/Monitoring
gem 'sinatra', '>= 1.3.0', :require => nil

# sass mixins
gem 'bourbon'
# grid framework for bourbon
gem 'neat'

gem 'tzinfo-data'
gem 'tzinfo'
gem 'detect_timezone_rails'


group :development, :test do
	gem 'coveralls', require: false
	gem 'simplecov', :require => false, :group => :test
  gem 'timecop'
  gem 'rspec-rails', '~> 2.14.1'
  gem 'capybara', '~> 2.2.1'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'launchy'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'shoulda-matchers'
end
