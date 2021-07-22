Sequel.migration do
  up do
    alter_table :list_items do
      add_column :checked, TrueClass
    end
  end

  down do
    alter_table :list_items do
      drop_column :checked
    end
  end
end
