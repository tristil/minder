Sequel.migration do
  up do
    create_table(:tasks) do
      primary_key :id
      String :description, null: false
      Boolean :selected, default: false
      Boolean :started, default: false
    end
  end

  down do
    drop_table(:tasks)
  end
end
