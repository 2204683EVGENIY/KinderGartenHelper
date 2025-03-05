class MonthlyReportsController < ApplicationController
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
    binding.irb
  end

  def correct_month_report_data_form
    @mentor = Mentor.includes(:groups).find(1)
    @groups = @mentor.groups

    render partial: "correct_month_report_data_form", locals: { groups: @groups }
  end
end
