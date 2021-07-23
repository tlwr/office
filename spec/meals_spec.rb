require "date"

RSpec.describe "meals" do
  describe "creating a meal" do
    describe "via a browser" do
      it "defaults the timestamp to now" do
        get "/meals/new"
        expect(last_response).to be_ok

        post "/meals", {
          "authenticity_token" => token_from_current_page,
          "description" => "a meal",
          "calorie-estimate" => 123,
        }

        expect(last_response).to be_redirect
        follow_redirect!

        m = Meal.last
        expect(m.calorie_estimate).to eq(123)
        expect(m.description).to eq("a meal")
        expect(m.created_at.strftime("%s").to_i).to be_within(1).of(DateTime.now.strftime("%s").to_i)
      end

      it "can override the timestamp to now" do
        get "/meals/new"
        expect(last_response).to be_ok

        post "/meals", {
          "authenticity_token" => token_from_current_page,
          "description" => "a meal",
          "calorie-estimate" => 123,
          "timestamp" => "2021-07-22 23:30",
        }

        expect(last_response).to be_redirect
        follow_redirect!

        ts = DateTime.new(2021, 7, 22, 23, 30)
        fudge_factor = 7200 + 1
        m = Meal.last
        expect(m.calorie_estimate).to eq(123)
        expect(m.description).to eq("a meal")
        expect(m.created_at.strftime("%s").to_i).to be_within(fudge_factor).of(ts.strftime("%s").to_i)
      end
    end
  end
end
