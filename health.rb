require "sinatra"

class Office < Sinatra::Base
  get "/health" do
    "ok"
  end
end
