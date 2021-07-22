require "bcrypt"
require "json"
require "sequel"
require "time"

def db_filepath
  {
    "development" => "sqlite:///tmp/office-development.db",
    "production" => "sqlite:///opt/office/fs/office-production.db",
  }.fetch(ENV.fetch("RACK_ENV", "development"))
end

DB = ENV["RACK_ENV"] == "test" ? Sequel.sqlite : Sequel.connect(db_filepath)

Sequel::Model.plugin :timestamps

Sequel.extension :migration
Sequel::Migrator.run(DB, File.join(__dir__, "migrations"))

class List < Sequel::Model
  one_to_many :list_items, class: :ListItem, key: :list_id

  def after_create
    Event.record(:created_list, list_id: id)
  end

  def add_item(creator:, title:)
    ListItem.create(creator: creator, title: title, list_id: id)
  end
end

class ListItem < Sequel::Model
  many_to_one :list, class: :List, key: :list_id

  def after_create
    Event.record(:created_list_item, list_item_id: id)
  end

  def mark(user:, checked:)
    self.checked = checked
    @altered_by = user
  end

  def after_save
    return unless @altered_by

    Event.record(
      :altered_list_item,
      list_item_id: id,
      user_id: @altered_by,
      checked: checked,
    )
  end
end

class Event < Sequel::Model
  def self.record(kind, **metadata)
    e = Event.new
    e.kind = kind
    e.metadata = metadata
    e.save
    e
  end

  def metadata
    JSON.parse(raw_metadata).transform_keys { _1.to_sym }
  end

  def metadata=(hash)
    self.raw_metadata = hash.to_json
  end

  def before_save
    self.kind = kind.to_s
  end

  def kind
    values[:kind].to_sym
  end
end
