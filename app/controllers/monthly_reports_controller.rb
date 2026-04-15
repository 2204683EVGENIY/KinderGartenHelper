class MonthlyReportsController < ApplicationController
  before_action :define_reasons, only: %i[overwrite_child_info overwrite_children_info]
  before_action :find_group, only: %i[create]

  def create
    if @group.mentors.include?(Current.user.mentor)
      month_range = (monthly_report_params[:report_date].to_date..monthly_report_params[:report_date].to_date.end_of_month)
      mentor = Current.user.mentor

      report_data = @group.children.map do |child|
        current_info_about_visits_of_month = child.info_about_visits.select { |i| i.date.month == month_range.first.month }
        count_of_visit = current_info_about_visits_of_month.select { |i| i.kindergarten_visited == true }.count
        count_of_unvisit = current_info_about_visits_of_month.select { |i| i.kindergarten_visited == false }.count
        count_of_sick = current_info_about_visits_of_month.select { |i| i.kindergarten_visited == false && i.reason == "sick" }.count
        count_of_vacation = current_info_about_visits_of_month.select { |i| i.kindergarten_visited == false && i.reason == "vacation" }.count
        count_of_other = current_info_about_visits_of_month.select { |i| i.kindergarten_visited == false && i.reason == "other" }.count

        {
          child_name: "#{ child.first_name } #{ child.middle_name } #{ child.last_name }",
          account_number: child.account_number,
          monthly_report_days: month_range.map do |date|
          {
              date: date.strftime("%d.%m.%Y"),
              kindergarten_visited: child.info_about_visits.find_by(date: date)&.kindergarten_visited,
              reason: child.info_about_visits.find_by(date: date)&.reason
            }
          end,
          monthly_report_info: {
            count_of_visit: count_of_visit,
            count_of_unvisit: count_of_unvisit,
            count_of_sick: count_of_sick,
            count_of_vacation: count_of_vacation,
            count_of_other: count_of_other
          }
        }
      end

      MonthlyReport.create(
        group_id: @group.id,
        mentor: mentor,
        report_date: monthly_report_params[:report_date],
        data: report_data
      )

      redirect_to monthly_reports_path, notice: "Report was successfully created."
    else
      redirect_to root_path, alert: "You are not welcome here."
    end
  end

  def index
    @monthly_reports = Current.user.mentor.monthly_reports.order(created_at: :desc)
  end

  def show
    @monthly_report = MonthlyReport.find(params[:id])

    if Current.user.mentor.owner?(@monthly_report)
      @days = @monthly_report.data.first["monthly_report_days"]
      @daily_stats = get_daily_stats(@monthly_report)
      @monthly_stats = get_monthly_stats(@monthly_report)
    else
      redirect_to root_path, alert: "You are not welcome here."
    end
  end

  def destroy
    @monthly_report = MonthlyReport.find(params[:id])

    if Current.user.mentor.owner?(@monthly_report)
      @monthly_report.destroy

      redirect_to monthly_reports_path, notice: "Report was successfully deleted."
    else
      redirect_to root_path, alert: "You are not welcome here."
    end
  end

  def export_to_xlsx
    @monthly_report = MonthlyReport.find(params[:id])

    if Current.user.mentor.owner?(@monthly_report)
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.add_worksheet(name: "Report") do |sheet|
        build_header(sheet, @monthly_report)
        build_rows(sheet, @monthly_report)
        build_summary(sheet, @monthly_report)
      end

      send_data package.to_stream.read,
        filename: "monthly_report_#{ Time.now.to_i }.xlsx",
        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    else
      rediret_to root_path, alert: "You are not welcome here."
    end
  end

  def correct_data_for_month_report
    if [ *2025..(Date.current.year + 1) ].include?(params[:year].to_i) && Group.pluck(:id).include?(params[:group_id].to_i) && [ *1..12 ].include?(params[:month].to_i)
      @group = Group.includes(:children).find(params[:group_id])

      if @group.mentors.include?(Current.user.mentor)
        @mentor = Mentor.includes(:groups).find(Current.user.mentor.id)
        @children = @group.children.includes(:info_about_visits)
        @report_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
        @info_about_visits = @children.map { |child| child.find_info_about_visits_for_correction(params[:month].to_i, params[:year].to_i) }.select { |info| info.any? }
      else
        redirect_ro root_path, alert: "You are not welcome here."
      end
    else
      redirect_to root_path, alert: "You are not welcome here."
    end
  end

  def overwrite_children_info
    if @reasons.include?(params[:commit])
      visits = InfoAboutVisit.where(id: params[:visit_ids])

      if visits.any? && visits.first.child.group.mentors.include?(Current.user.mentor)
        updated_visits = []

        visits.each do |visit|
          visit.update_visit_info(params[:commit])
          updated_visits << visit
        end

        updated_visits.each { |visit| turbo_update(visit.child, visit.date, visit) }
      else
        redirect_to root_path, alert: "You are not welcome here."
      end
    else
      redirect_to root_path, alert: "You are not welcome here."
    end
  end

  def overwrite_child_info
    if @reasons.include?(params[:reason])
      visit = InfoAboutVisit.find(params[:visit_id])

      if visit.child.group.mentors.include?(Current.user.mentor)
        visit.update_visit_info(params[:reason])
        turbo_update(visit.child, visit.date, visit)
      else
        redirect_to root_path, alert: "You are not welcome here."
      end
    else
      redirect_to root_path, alert: "You are not welcome here."
    end
  end

  def correct_month_report_data_form
    @mentor = Mentor.includes(:groups).find(Current.user.mentor.id)
    @groups = @mentor.groups

    render partial: "correct_month_report_data_form", locals: { groups: @groups }
  end

  private

  def find_group
    @group = Group.includes(:children).find(monthly_report_params[:group_id])
  end

  def monthly_report_params
    params.permit(:report_date, :group_id, :mentor_id)
  end

  def define_reasons
    @reasons = [ "sick", "vacation", "other" ]
  end

  def turbo_update(child, date, visit)
    respond_to do |format|
      format.turbo_stream do
        Turbo::StreamsChannel.broadcast_update_to(
          child.group.mentors,
          target: "info_about_visit_#{ visit.id }",
          partial: "monthly_reports/overwrite_info_about_visit_reason",
          locals: { visit: visit }
        )
      end
    end
  end

  def get_monthly_stats(monthly_report)
    {
      count_of_visit:    monthly_report.data.sum { |m| m["monthly_report_info"]["count_of_visit"] },
      count_of_unvisit:  monthly_report.data.sum { |m| m["monthly_report_info"]["count_of_unvisit"] },
      count_of_sick:     monthly_report.data.sum { |m| m["monthly_report_info"]["count_of_sick"] },
      count_of_vacation: monthly_report.data.sum { |m| m["monthly_report_info"]["count_of_vacation"] },
      count_of_other:    monthly_report.data.sum { |m| m["monthly_report_info"]["count_of_other"] }
    }
  end

  def get_daily_stats(monthly_report)
    days = monthly_report.data.first["monthly_report_days"]
    days.map do |day|
      date = day["date"]

      day_data = monthly_report.data.map do |child|
        child["monthly_report_days"].find { |d| d["date"] == date }
      end.compact

      {
        date: date,
        visit: day_data.count { |d| d["kindergarten_visited"] == true },
        unvisit: day_data.count { |d| d["kindergarten_visited"] == false },
        sick: day_data.count { |d| d["reason"] == "sick" },
        vacation: day_data.count { |d| d["reason"] == "vacation" },
        other: day_data.count { |d| d["reason"] == "other" }
      }
    end
  end

  def build_header(sheet, monthly_report)
    days = monthly_report.data.first["monthly_report_days"]
    header = [ "№", "Name", "Account number" ]

    days.each do |day|
      header << Date.parse(day["date"].to_s).day
    end

    header += [ "Visit", "Unvisit", "Sick", "Vacation", "Other" ]
    sheet.add_row header
  end

  def build_rows(sheet, monthly_report)
    monthly_report.data.each_with_index do |mrd, index|
      row = []

      row << index + 1
      row << mrd["child_name"]
      row << mrd["account_number"]

      mrd["monthly_report_days"].each do |day|
        row << day_symbol(day)
      end

      info = mrd["monthly_report_info"]

      row << info["count_of_visit"]
      row << info["count_of_unvisit"]
      row << info["count_of_sick"]
      row << info["count_of_vacation"]
      row << info["count_of_other"]

      sheet.add_row row
    end
  end

  def build_summary(sheet, monthly_report)
    monthly_stats = get_monthly_stats(monthly_report)
    daily_stats = get_daily_stats(monthly_report)
    days_count = monthly_report.data.first["monthly_report_days"].count
    count_of_rows = monthly_report.group.children.count + 6

    sheet.add_row [ "", "Visit", "", *daily_stats.map { |s| s[:visit] }, monthly_stats[:count_of_visit] ]
    sheet.add_row [ "", "Unvisit", "", *daily_stats.map { |s| s[:unvisit] }, "", monthly_stats[:count_of_unvisit] ]
    sheet.add_row [ "", "Sick", "", *daily_stats.map { |s| s[:sick] }, "", "", monthly_stats[:count_of_sick] ]
    sheet.add_row [ "", "Vacation", "", *daily_stats.map { |s| s[:vacation] }, "", "", "", monthly_stats[:count_of_vacation] ]
    sheet.add_row [ "", "Other", "", *daily_stats.map { |s| s[:other] }, "", "", "", "", monthly_stats[:count_of_other] ]
    sheet.add_style [ "A1:#{ days_count == 28 ? "AJ1" : days_count == 30 ? "AL1" : "AM1" }" ], b: true
    sheet.add_style [ "B1:B#{ count_of_rows }" ], b: true
    sheet.add_style [ "A1:#{ days_count == 28 ? "AJ#{ count_of_rows }" : days_count == 30 ? "AL#{ count_of_rows }" : "AM#{ count_of_rows }" }" ], alignment: { horizontal: :center }, sz: 12
    widths = [ 3, 40, 20 ]
    widths += Array.new(days_count, 4)
    sheet.column_widths(*widths)
  end

  def day_symbol(day)
    return "✓" if day["kindergarten_visited"]

    case day["reason"]
    when "sick" then "Б"
    when "vacation" then "О"
    when "other" then "Н"
    else "!"
    end
  end
end
