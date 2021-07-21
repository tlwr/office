Sequel.migration do
  up do
    create_table(:list_items) do
      primary_key :id
      foreign_key :list_id

      String :title, null: false
      String :creator, null: false
    end
  end

  down do
    drop_table(:list_items)
  end
end
