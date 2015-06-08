class TaskMapper < ROM::Mapper
  relation :tasks
  register_as :entity

  model Minder::Task

  attribute :id
  attribute :description
  attribute :selected
  attribute :started
end
