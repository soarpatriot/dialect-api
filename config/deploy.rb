lock '3.2.1'

set :application, "inkash-api"

set :rvm_type, :user
set :rvm_ruby_version, '2.1.1'

set :repo_url, "git@git.soundink.cn:server/inkash-api.git"
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :branch, "master"

set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets public}

set :default_env, { g2_env: "production" }
set :keep_releases, 5

namespace :deploy do

  desc "Start application"
  task :start do

    on roles(:app) do
      within current_path do
        execute :bundle, "exec god start inkash-api"
      end
    end
  end

  desc "Stop application"
  task :stop do

    on roles(:app) do
      within current_path do
        execute :bundle, "exec god stop inkash-api"
      end
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app) do
      within current_path do
          info ">>>>>> starting application"
          execute :touch, "tmp/restart.txt"
      end
    end
  end

=begin
  after :updated, :migration do
    invoke "rvm:hook"
    on roles(:app) do
      within release_path do
        execute :bundle, "exec rake db:migrate"
      end
    end
  end
=end

  task :bundle do
    on roles(:app) do
      within current_path do
          execute :bundle, "install"
      end
    end
  end

  after :finishing, "deploy:cleanup"
end

before "bundler:install", "rvm:hook"
after  "deploy:publishing", "deploy:bundle"
after  "deploy:publishing", "deploy:restart"
