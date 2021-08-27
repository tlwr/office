require "date"

RSpec.describe "activities" do
  describe "creating a activity" do
    describe "via a browser" do
      it "defaults the timestamp to now" do
        get "/activities/new"
        expect(last_response).to be_ok

        post "/activities", {
          "authenticity_token" => token_from_current_page,
          "description" => "a activity",
          "duration" => 60,
          "calorie-estimate" => 123,
        }

        expect(last_response).to be_redirect
        follow_redirect!

        a = Activity.last
        expect(a.calorie_estimate).to eq(123)
        expect(a.duration).to eq(60)
        expect(a.description).to eq("a activity")
        expect(a.created_at.strftime("%s").to_i).to be_within(1).of(DateTime.now.strftime("%s").to_i)
      end

      it "can override the timestamp to now" do
        get "/activities/new"
        expect(last_response).to be_ok

        post "/activities", {
          "authenticity_token" => token_from_current_page,
          "description" => "a activity",
          "duration" => 60,
          "calorie-estimate" => 123,
          "timestamp" => "2021-07-22 23:30",
        }

        expect(last_response).to be_redirect
        follow_redirect!

        ts = DateTime.new(2021, 7, 22, 23, 30)
        fudge_factor = 7200 + 1
        a = Activity.last
        expect(a.calorie_estimate).to eq(123)
        expect(a.duration).to eq(60)
        expect(a.description).to eq("a activity")
        expect(a.created_at.strftime("%s").to_i).to be_within(fudge_factor).of(ts.strftime("%s").to_i)
      end
    end
  end
end
