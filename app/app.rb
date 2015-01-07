#!/usr/bin/ruby
require "bundler/setup"
require 'sinatra'
require 'net/http'
require 'json'

require_relative 'models/init'

class MainApp < Sinatra::Base
  get '/' do
    erb :index
  end
end
