server 'app.server.mtt.rs', user: 'ubuntu', roles: %w{app db web worker scheduler}

set :stage, :production
set :rails_env, 'production'
set :keep_releases, 10