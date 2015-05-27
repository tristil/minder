Sequel.migration do
  up do
    next unless File.exists?(Minder::DOING_FILE)

    tasks = ROM.env.repositories[:default].connection.from(:tasks)
    tasks.delete

    File.readlines(Minder::DOING_FILE).each do |line|
      tasks.insert(description: line.strip)
    end
  end

  down do
  end
end
