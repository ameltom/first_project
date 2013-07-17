Split.redis = $redis

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == '1' && password == '1'
end
