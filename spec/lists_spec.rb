RSpec.describe "lists" do
  describe "creating a list" do
    it "creates an event" do
      List.create(title: "lists_spec my list", creator: "tlwr")
      e = Event.last
      expect(e.kind).to eq(:created_list)
      expect(e.list).to eq(List.last)
    end

    it "works via a browser" do
      get "/lists"
      expect(last_response).to be_ok

      post "/lists", {
        "authenticity_token" => token_from_current_page,
        "title" => "lists_spec my browser list",
      }

      l = List.last
      expect(l.title).to eq("lists_spec my browser list")
      expect(l.creator).to eq("tlwr")
    end
  end

  describe "items" do
    before(:all) do
      @list = List.create(title: "list_items_spec my list", creator: "tlwr")
    end

    describe "creating" do
      it "creates an event" do
        @list.add_item(creator: @list.creator, title: "list_items_spec my list item")

        li = ListItem.last
        expect(li.list).to eq(@list)

        e = Event.last
        expect(e.kind).to eq(:created_list_item)
        expect(e.list_item).to eq(li)
        expect(e.list_item.list).to eq(@list)
      end

      it "works via a browser" do
        get "/lists/#{@list.id}"
        expect(last_response).to be_ok

        post "/lists/#{@list.id}/items", {
          "authenticity_token" => token_from_current_page,
          "title" => "list_items_spec my list item",
        }

        l = @list.list_items.last
        expect(l.title).to eq("list_items_spec my list item")
        expect(l.creator).to eq("tlwr")
      end
    end

    describe "completing" do
      before(:all) do
        @list_item = @list.add_item(title: "list_items_spec my list item", creator: "tlwr")
      end

      it "works via a browser" do
        get "/lists/#{@list.id}"
        expect(last_response).to be_ok

        post "/lists/#{@list.id}/items/#{@list_item.id}", {
          "authenticity_token" => token_from_current_page,
          "state" => "complete",
        }

        expect(last_response).to be_redirect
        follow_redirect!

        @list_item.reload
        expect(@list_item.checked).to eq(true)
        expect(Event.last.metadata[:checked]).to eq(true)

        post "/lists/#{@list.id}/items/#{@list_item.id}", {
          "authenticity_token" => token_from_current_page,
        }

        expect(last_response).to be_redirect
        follow_redirect!

        @list_item.reload
        expect(@list_item.checked).to eq(false)
        expect(Event.last.metadata[:checked]).to eq(false)

        post "/lists/#{@list.id}/items/#{@list_item.id}", {
          "authenticity_token" => token_from_current_page,
          "delete" => true,
        }

        expect(last_response).to be_redirect
        follow_redirect!

        expect(ListItem.find(id: @list_item.id)).to be_nil
        expect(Event.last.kind).to eq(:deleted_list_item)
      end
    end
  end
end
