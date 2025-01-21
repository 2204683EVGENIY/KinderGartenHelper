module SelectReportDayHelper
  def max_available_day(day)
    day.to_date + 5.days
  end

  def child_info_about_visit(child, day)
    if child.info_about_visit.find_by(date: day.to_date).present?
      refresh_info_about_visit(child, day)
    else
      add_info_about_visit(child, day)
    end
  end

  def bg_color_by_visit(child, day)
    if child.info_already_present?(day) && child.today_visited?(day)
      "bg-success"
    elsif child.info_already_present?(day) && !child.today_visited?(day)
      "bg-danger"
    else
      ""
    end
  end

  def correct_date(day)
    day.strftime("%d.%m.%Y")
  end

  private

  def refresh_info_about_visit(child, day)
    render partial: "select_report_day/refresh_info_about_visit", locals: { child: child, day: day }
  end

  def add_info_about_visit(child, day)
    render partial: "select_report_day/add_info_about_visit", locals: { child: child, day: day }
  end
end
