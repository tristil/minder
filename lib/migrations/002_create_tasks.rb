require_relative '../minder'

Sequel.migration do
  up do
    tasks = DB.from(:tasks)
    tasks.delete

    File.readlines(Minder::DOING_FILE).each do |line|
      tasks.insert(description: line)
    end
  end

  down do
  end
end
