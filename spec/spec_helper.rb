ENV["RACK_ENV"] = "test"

require_relative "../office"
require "rspec"
require "rack/test"

RSpec.configure do |c|
  c.include Rack::Test::Methods
end

def app
  Office.new
end

def token_from_current_page
  last_response.body.match(/authenticity_token.+value="([^"]+)"/)[1]
end
