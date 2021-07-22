require "sinatra"

class Office < Sinatra::Base
  get "/lists" do
    @lists = List.all
    erb :"lists/index"
  end

  post "/lists" do
    l = List.create(title: params[:title], creator: current_user)
    redirect "/lists/#{l.id}"
  end

  get "/lists/:id" do
    @list = List.find(id: params[:id])
    erb :"lists/show"
  end

  post "/lists/:id/items" do
    l = List.find(id: params[:id])
    title = params[:title].strip
    l.add_item(title: title, creator: current_user) unless title.empty?
    redirect "/lists/#{l.id}"
  end

  post "/lists/:list_id/items/:list_item_id/check" do
    li = ListItem.find(id: params[:list_item_id], list_id: params[:list_id])

    if params[:delete]
      li.delete
    else
      li.mark(user: current_user, checked: params[:state] == "complete")
      li.save
    end

    redirect "/lists/#{li.list_id}"
  end
end
