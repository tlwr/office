require "date"
require "sinatra"

class Office < Sinatra::Base
  get "/meals" do
    @latest = Meal.order(:created_at).last(32)

    today = Date.today
    today_range = today...(today + 1)
    @calories_today = Meal.where(created_at: today_range).map(&:calorie_estimate).sum

    @count = Meal.count
    erb :"meals/index"
  end

  get "/meals/new" do
    erb :"meals/new"
  end

  post "/meals" do
    description = params[:description]&.strip || ""
    calorie_estimate = params[:"calorie-estimate"] || ""
    ts = params[:timestamp] || ""

    redirect "/meals" if description.empty? || calorie_estimate.empty?

    Meal.create(
      description: description,
      calorie_estimate: calorie_estimate.to_i,
      consumer: current_user,
      created_at: ts.empty? ? nil : DateTime.parse(ts),
    )

    redirect "/meals"
  end
end
