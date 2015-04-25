#!/usr/bin/ruby
require "bundler/setup"
require 'sinatra'
require 'net/http'
require 'json'
require 'time'
require 'cgi'
require 'uri'

require_relative 'models/init'

class MainApp < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/api/proxy/*/*' do
    account = params[:splat][1]
    channel = params[:splat][0]

    datafetch = Datafetch.new()
    res = datafetch.getData(channel,account)
    # error
    if res.nil? then
      status 404
      "Not Found"
      return false
    end

    #output
    status 200
    content_type "text/javascript"
    res
  end

  get '/api/latest/*' do
    accounts   = params[:splat][0]
    max       = params['max'] ? params['max'].to_i : 3

    datafetch = Datafetch.new()
    res = datafetch.getLatestProducts(max,accounts)
    content_type "text/javascript"
    res
  end

  get '/api/members' do
    members = Members.new()
    res = members.getData()

    content_type "text/javascript"
    res
  end
end
