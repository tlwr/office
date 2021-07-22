Sequel.migration do
  up do
    create_table(:meals) do
      primary_key :id

      String :description, null: false
      Numeric :calorie_estimate, null: false
      Consumer :consumer, null: false

      Time :created_at, null: false
      Time :updated_at
    end
  end

  down do
    drop_table(:meals)
  end
end
