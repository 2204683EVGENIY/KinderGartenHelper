module SelectReportDayHelper
  def max_available_day(day)
    day.to_date + 5.days
  end

  def child_info_about_visit(child, day, visits)
    visit = visits[child.id]

    if visit.present?
      refresh_info_about_visit(child, day, visits)
    else
      add_info_about_visit(child, day)
    end
  end

  def bg_color_by_visit(child, day, visits)
    if child.info_already_present?(visits) && child.today_visited?(visits)
      "bg-success"
    elsif child.info_already_present?(visits) && !child.today_visited?(visits)
      "bg-danger"
    else
      ""
    end
  end

  def correct_date(day)
    day.strftime("%d.%m.%Y")
  end

  private

  def refresh_info_about_visit(child, day, visits)
    render partial: "select_report_day/refresh_info_about_visit", locals: { child: child, day: day, visits: visits }
  end

  def add_info_about_visit(child, day)
    render partial: "select_report_day/add_info_about_visit", locals: { child: child, day: day }
  end
end
