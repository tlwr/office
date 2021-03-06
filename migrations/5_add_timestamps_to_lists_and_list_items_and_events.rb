Sequel.migration do
  up do
    %i[events lists list_items].each do |tbl|
      alter_table tbl do
        add_column :created_at, Time
        add_column :updated_at, Time
      end
    end
  end

  down do
    %i[events lists list_items].each do |tbl|
      alter_table tbl do
        drop_column :created_at
        drop_column :updated_at
      end
    end
  end
end
