class MonthlyReportsController < ApplicationController
  before_action :define_reasons, only: %i[overwrite_child_info overwrite_children_info]
  before_action :find_group, only: %i[create]

  def create
    month_range = (monthly_report_params[:report_date].to_date..monthly_report_params[:report_date].to_date.end_of_month)
    mentor = Mentor.find(monthly_report_params[:mentor_id])

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
            date: date,
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

    mr = MonthlyReport.create(
      group_id: monthly_report_params[:group_id],
      mentor: mentor,
      report_date: monthly_report_params[:report_date],
      data: report_data
    )

    redirect_to root_path
  end

  def correct_data_for_month_report
    if [ *2025..(Date.current.year + 1) ].include?(params[:year].to_i) && Group.pluck(:id).include?(params[:group_id].to_i) && [ *1..12 ].include?(params[:month].to_i)
      group = Group.includes(:children).find(params[:group_id])
      children = group.children.includes(:info_about_visits)
      report_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
      info_about_visits = children.map { |child| child.find_info_about_visits_for_correction(params[:month].to_i, params[:year].to_i) }.select { |info| info.any? }

      render partial: "children_list_for_correction", locals: { info_about_visits: info_about_visits, report_date: report_date, group_id: params[:group_id] }
    else
      redirect_to root_path
    end
  end

  def overwrite_children_info
    if @reasons.include?(params[:commit])
      visits = InfoAboutVisit.where(id: params[:visit_ids])

      if visits.any?
        updated_visits = []

        visits.each do |visit|
          visit.update_visit_info(params[:commit])
          updated_visits << visit
        end

        updated_visits.each { |visit| turbo_update(visit.child, visit.date, visit) }
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def overwrite_child_info
    if @reasons.include?(params[:reason])
      visit = InfoAboutVisit.find(params[:visit_id])

      visit.update_visit_info(params[:reason])
      turbo_update(visit.child, visit.date, visit)
    else
      redirect_to root_path
    end
  end

  def correct_month_report_data_form
    @mentor = Mentor.includes(:groups).find(1)
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
end
