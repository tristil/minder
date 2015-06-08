class PeriodMapper < ROM::Mapper
  relation :periods
  register_as :entity

  # TODO: figure out STI
  model Minder::Period

  attribute :id
  attribute :type
  attribute :started_at
  attribute :ended_at
end
