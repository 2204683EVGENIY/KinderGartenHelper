class SelectReportDayController < ApplicationController
  before_action :check_inputed_day, only: %i[ select_day ]

  def select_day
    @mentor = Mentor.includes(:group).find(1)
    @group = @mentor.group
    @childrens = @group.childrens.includes(:info_about_visit)
    @day = params[:day]

    render "select_day", locals: { mentor: @mentor, group: @group, childrens: @childrens, day: @day }
  end

  private

  def clean_date_param(param)
    param.gsub(/.*?(\b\d{4}-\d{2}-\d{2}\b).*?/, '\1')
  end

  def check_inputed_day
    cleaned_params_day = params[:day].present? ? clean_date_param(params[:day]) : ""

    valid_date = begin
                          Date.parse(cleaned_params_day)
                        rescue ArgumentError
                          nil
                        end

    if valid_date && valid_date >= Date.new(2025, 1, 1) && valid_date <= Time.current.to_date + 5.days
      params[:day] = valid_date.strftime("%Y-%m-%d")
    else
      params[:day] = Time.current.to_date.strftime("%Y-%m-%d")
    end
  end
end
