require "sinatra"

class Office < Sinatra::Base
  get "/activity" do
    @latest = Event.last(25)
    erb :"events/index"
  end
end

def jquo(phrase)
  "「#{phrase}」"
end

class Event < Sequel::Model
  def nice
    case kind.to_sym
    when :created_list
      "#{list.creator} created #{jquo(list.title)}"
    when :altered_list_item
      li = list_item
      verb = metadata[:checked] ? "checked" : "unchecked"
      "#{li.creator} #{verb} #{jquo(li.title)} in #{jquo(li.list.title)}"
    end
  end

  def relevant?
    case kind.to_sym
    when :created_list
      list
    end
  end

  def list
    @list ||= List.find(id: metadata[:list_id])
  end

  def list_item
    @list_item ||= ListItem.find(id: metadata[:list_item_id])
  end
end
