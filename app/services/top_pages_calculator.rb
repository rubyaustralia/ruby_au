class TopPagesCalculator
  def call
    Ahoy::Event.where(name: "$view")
               .where("time >= ?", 30.days.ago)
               .group("properties->>'url'")
               .count
               .sort_by { |_page, views| -views }
               .first(10)
  end
end
