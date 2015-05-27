module Minder
  module Commands
    class CreateUser < ROM::Commands::Delete[:sql]
      register_as :delete
      relation :tasks
    end
  end
end

