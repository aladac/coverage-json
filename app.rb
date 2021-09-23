# frozen_string_literal: true

require 'bundler'
require 'json'

Bundler.require

COVERAGE_COLORS = {
  (0..20) => :red,
  (21..40) => :orange,
  (41..60) => :yellow,
  (61..80) => :yellowgreen,
  (81..100) => :brightgreen
}.freeze

post '/coverage/:username/:repo' do
  return 401 unless params[:key] && (params[:key] == ENV['SECRET_KEY'])

  json = JSON.parse(request.body.read)
  coverage = json['metrics']['covered_percent']
  redis.hset params[:username], params[:repo], coverage.to_i
  200
rescue JSON::ParserError
  422
end

get '/coverage/:username/:repo.json' do
  coverage = redis.hget(params[:username], params[:repo]).to_i
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
  COVERAGE_COLORS.each_pair do |range, color|
    return color if range.include?(coverage)
  end
end
