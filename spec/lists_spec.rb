require_relative "spec_helper"

RSpec.describe "lists" do
  describe "create" do
    it "creates an event" do
      List.create(title: "lists_spec my list", creator: "tlwr")
      e = Event.last
      expect(e.kind).to eq(:created_list)
      expect(e.list).to eq(List.last)
    end
  end
end
