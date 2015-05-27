class Tasks < ROM::Relation[:sql]
  def filtered_by(text)
    where("description LIKE '%#{text}%'")
  end
end
