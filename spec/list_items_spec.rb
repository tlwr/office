require_relative "spec_helper"

RSpec.describe "lists" do
  describe "create" do
    it "creates an event" do
      l = List.create(title: "list_items_spec my list", creator: "tlwr")
      l.add_item(creator: l.creator, title: "list_items_spec my list item")

      li = ListItem.last
      expect(li.list).to eq(l)

      e = Event.last
      expect(e.kind).to eq(:created_list_item)
      expect(e.list_item).to eq(li)
      expect(e.list_item.list).to eq(l)
    end
  end
end
