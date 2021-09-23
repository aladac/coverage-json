# frozen_string_literal: true

require 'bundler'
require 'json'

Bundler.require

post '/coverage/:username/:repo' do
  json = JSON.parse(request.body.read)
  coverage = json['metrics']['covered_percent']
  redis.hset params[:username], params[:repo], coverage.to_i
  200
end

get '/coverage/:username/:repo.json' do
  coverage = redis.hget params[:username], params[:repo]
  json = {
    "schemaVersion": 1,
    "label": 'Coverage',
    "message": "#{coverage}%",
    "color": color(coverage)
  }
  json.to_json
end

def redis
  Redis.new(url: ENV['REDIS_URL'])
end

def color(coverage)
  case coverage.to_i
  when (0..20)
    :red
  when (21..40)
    :orange
  when (41..60)
    :yellow
  when (61..80)
    :yellowgreen
  when (81..100)
    :brightgreen
  end
end
