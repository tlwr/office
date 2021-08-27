require "date"
require "sinatra"

class Office < Sinatra::Base
  get "/activities" do
    @latest = Activity.order(:created_at).last(32)

    today = Date.today
    today_range = today...(today + 1)
    activities_today = Activity.where(created_at: today_range)
    @calories_today = activities_today.map(&:calorie_estimate).sum
    @minutes_today = activities_today.map(&:duration).sum

    @count = Activity.count
    erb :"activities/index"
  end

  get "/activities/new" do
    erb :"activities/new"
  end

  post "/activities" do
    description = params[:description]&.strip || ""
    duration = params[:duration] || ""
    calorie_estimate = params[:"calorie-estimate"] || ""
    ts = params[:timestamp] || ""

    redirect "/activities" if description.empty? || duration.empty? || calorie_estimate.empty?

    Activity.create(
      description: description,
      duration: duration.to_i,
      calorie_estimate: calorie_estimate.to_i,
      doer: current_user,
      created_at: ts.empty? ? nil : DateTime.parse(ts),
    )

    redirect "/activities"
  end
end
