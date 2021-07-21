require_relative "spec_helper"

RSpec.describe "pages" do
  describe "index" do
    it "renders" do
      get "/"
      expect(last_response).to be_ok
      expect(last_response.body).to match(/i shall do as you recommend/i)
    end
  end
end
