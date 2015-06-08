class Periods < ROM::Relation[:sql]
  def by_id(id)
    where(id: id)
  end

  def completed_pomodoros
    where(type: 'work')
      .where('started_at IS NOT NULL')
      .where('ended_at IS NOT NULL')
  end

  def pomodoros_today
    completed_pomodoros.
      where('ended_at BETWEEN ? AND ?',
            Time.now.strftime('%Y-%m-%d 00:00:00'),
            Time.now.strftime('%Y-%m-%d 23:59:59'))
  end
end
