Sequel.migration do
  up do
    create_table(:lists) do
      primary_key :id

      String :title, null: false, unique: true
      String :creator, null: false
    end
  end

  down do
    drop_table(:lists)
  end
end
