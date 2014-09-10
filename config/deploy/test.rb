
set :stage, :test
set :server_name, "inkash.test.soundink.net"

set :branch, "dev"
set :deploy_to, "/data/www/inkash-api"

set :thin_pid, "#{shared_path}/tmp/pids/thin.0.pid"
set :god_pid, "#{shared_path}/tmp/pids/god.pid"

server fetch(:server_name), user: "operation", roles: %w{web app db}
