require "sinatra"

class Office < Sinatra::Base
  get "/" do
    erb :"pages/index"
  end
end
