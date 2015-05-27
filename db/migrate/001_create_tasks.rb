Sequel.migration do
  up do
    create_table(:tasks) do
      primary_key :id
      String :description, null: false
      Boolean :selected, default: false
      Datetime :started_at
      Datetime :completed_at
    end
  end

  down do
    drop_table(:tasks)
  end
end
