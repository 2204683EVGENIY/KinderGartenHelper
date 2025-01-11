module SelectReportDayHelper
  def max_available_day(day)
    day.to_date + 5.days
  end
end
