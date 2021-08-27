Sequel.migration do
  up do
    create_table(:activities) do
      primary_key :id

      String :description, null: false
      Numeric :calorie_estimate, null: false
      Numeric :duration, null: false
      Doer :doer, null: false

      Time :created_at, null: false
      Time :updated_at
    end
  end

  down do
    drop_table(:activities)
  end
end
