require "bundler"
require "json"

Bundler.require

post '/coverage' do
  json = JSON.parse(request.body.read)
  coverage = json['metrics']['covered_percent']
  redis.set :coverage, coverage.to_i
end

get '/coverage.json' do
  coverage = redis.get :coverage
  json = {
    "schemaVersion": 1,
    "label": "Coverage",
    "message": "#{coverage}%",
    "color": set_color(coverage)
  }
  json.to_json
end

def redis
  Redis.new(ENV['REDIS_URL'])
end

def set_color(coverage)
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
