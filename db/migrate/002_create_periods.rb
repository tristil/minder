Sequel.migration do
  up do
    create_table(:periods) do
      primary_key :id
      String :type, null: false
      Datetime :started_at
      Datetime :ended_at
      Datetime :created_at
      Datetime :updated_at
    end
  end

  down do
    drop_table(:periods)
  end
end
