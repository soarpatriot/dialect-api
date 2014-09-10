
set :stage, :cn
set :server_name, "chitchit.soundink.net"

set :branch, "master"
set :deploy_to, "/data/www/inkash-api"

set :thin_pid, "#{shared_path}/tmp/pids/thin.0.pid"
set :god_pid, "#{shared_path}/tmp/pids/god.pid"

server fetch(:server_name), user: "ubuntu", roles: %w{web app db}
