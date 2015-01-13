# A sample Gemfile
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'rack'
gem 'rack-test'

group :production do
    gem 'unicorn'
end

group :development do
    gem 'sinatra-contrib', require: 'sinatra/reloader'
end

group :test, :development do
    gem 'rspec'
    gem 'coveralls', :require => false
    gem 'simplecov'
end
