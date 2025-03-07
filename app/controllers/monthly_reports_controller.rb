class MonthlyReportsController < ApplicationController
  before_action :define_reasons, only: %i[overwrite_child_info overwrite_children_info]

  def create
    binding.irb
  end

  def correct_data_for_month_report
    group = Group.includes(:children).find(params[:group_id])
    children = group.children.includes(:info_about_visits)
    @info_about_visits = children.map { |child| child.find_info_about_visits_for_correction(params[:month].to_i, params[:year].to_i) }.select { |info| info.any? }

    render partial: "children_list_for_correction", locals: { info_about_visits: @info_about_visits }
  end

  def overwrite_children_info
    if @reasons.include?(params[:commit])
      visits = InfoAboutVisit.where(id: params[:visit_ids])

      visits.each do |visit|
        visit.update_visit_info(params[:commit])
        turbo_update(visit.child, visit.date, visit)
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

  def define_reasons
    @reasons = ["sick", "vacation", "other"]
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
