Sequel.migration do
  up do
    alter_table(:periods) do
      add_column :duration_in_seconds, Integer, :default=>0
    end
  end

  down do
    alter_table(:periods) do
      drop_column(:duration_in_seconds)
    end
  end
end
