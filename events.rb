require "sinatra"

class Office < Sinatra::Base
  get "/events" do
    @latest = Event.last(100).select(&:relevant?)
    erb :"events/index"
  end

  helpers do
    def icon_for_event(event)
      case event.kind
      when :created_list
        "clipboard"
      when :created_list_item
        "green"
      when :deleted_list_item
        "red"
      when :altered_list_item
        event.metadata[:checked] ? "blue" : "grey"
      else
        "grey"
      end
    end
  end
end

def jquo(phrase)
  "「#{phrase}」"
end

class Event < Sequel::Model
  def nice_ts
    created_at.strftime("%F %H:%M")
  end

  def nice
    case kind.to_sym
    when :created_list
      "#{list.creator} created #{jquo(list.title)}"
    when :created_list_item
      "#{user} created #{jquo(list_item_title)} in #{jquo(list.title)}"
    when :altered_list_item
      li = list_item
      verb = metadata[:checked] ? "checked" : "unchecked"
      "#{user} #{verb} #{jquo(list_item_title)} in #{jquo(list.title)}"
    when :deleted_list_item
      "#{user} deleted #{jquo(list_item_title)} in #{jquo(list.title)}"
    end
  end

  def relevant?
    case kind.to_sym
    when :created_list
      list
    when :created_list_item, :altered_list_item, :deleted_list_item
      list_item_title
    end
  end

  def list
    @list ||= List.find(id: metadata[:list_id])
  end

  def list_item
    @list_item ||= ListItem.find(id: metadata[:list_item_id])
  end

  def list_item_title
    metadata[:list_item_title] || list_item.title
  end

  def user
    metadata[:user_id]
  end
end
