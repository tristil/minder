class Tasks < ROM::Relation[:sql]
  def filtered_by(text)
    where("description LIKE '%#{text}%'")
  end

  def by_id(id)
    where(id: id)
  end
end
