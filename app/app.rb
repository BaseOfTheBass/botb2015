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

  get '/api/fbevents' do
    fbevents = FBEvents.new()
    res = fbevents.getEvents()
    status res.code
    content_type res["Content-type"]
    res.body
  end
end
