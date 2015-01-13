#!/usr/bin/ruby
require "bundler/setup"
require 'sinatra'
require "sinatra/reloader"
require 'net/http'
require 'json'
require 'cgi'

#require_relative '../configures/config.rb'
require_relative 'models/init'
#require_relative 'classes/init'

class MainApp < Sinatra::Base

  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  get '/api/fbevents' do
    fbevents = FBEvents.new()
#    cacheControl = CacheControl.new('localhost')
    res = fbevents.getEvents()
    status res.code
    content_type "application/json"
    #cacheControl.set('fbevent',res.body)
    res.body
  end
end
