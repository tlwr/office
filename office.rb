require "sinatra"

require "rack/protection"

class Office < Sinatra::Base
  enable :sessions
  set :session_secret, "reuse-dev-sessions" if ENV["RACK_ENV"] == "development"
  set :session_secret, ENV["SESSION_SECRET"] if ENV["RACK_ENV"] == "production"

  set(:static, true)
  set(:public_folder, proc { File.join(root, "public") })

  use Rack::Protection
  use Rack::Protection::AuthenticityToken
end

require_relative "db"

require_relative "authentication"
require_relative "events"
require_relative "health"
require_relative "pages"
