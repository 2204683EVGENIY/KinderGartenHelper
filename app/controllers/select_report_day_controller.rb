class SelectReportDayController < ApplicationController
  before_action :check_inputed_day, only: %i[ select_day select_previous_or_next_day ]
  before_action :find_child, except: %i[ select_day select_previous_or_next_day add_info_to_childrens ]
  before_action :correct_day, except: %i[ select_day select_previous_or_next_day add_info_to_childrens ]

  def select_day
    @mentor = Mentor.includes(:groups).find(1)
    @groups = @mentor.groups
    @day = params[:day]

    render "select_day", locals: { mentor: @mentor, groups: @groups, day: @day }
  end

  def select_previous_or_next_day
    @mentor = Mentor.includes(:groups).find(1)
    @groups = @mentor.groups

    if params[:choosing_day] == "next" || params[:choosing_day] == "previous"
      params[:choosing_day] == "next" ? @day = params[:day].to_date + 1.day : @day = params[:day].to_date - 1.day
      render "select_day", locals: { mentor: @mentor, groups: @groups, day: @day }
    else
      redirect_to root_path
    end
  end

  def add_info_to_childrens
    if params[:child_ids].present? && params[:commit].present? && params[:day].present?
      childrens = Child.where(id: params[:child_ids])

      if params[:commit] == "Mark as visited"
        childrens.each do |child|
          if child.info_already_present?(params[:day].to_date)
            child.refresh_visit_info(params[:day].to_date)
            turbo_update(child, params[:day].to_date)
          else
            child.create_visit_info(params[:day].to_date)
            turbo_update(child, params[:day].to_date)
          end
        end
      elsif params[:commit] == "Mark as skiped"
        childrens.each do |child|
          if child.info_already_present?(params[:day].to_date)
            child.refresh_visit_info(params[:day].to_date)
            turbo_update(child, params[:day].to_date)
          else
            child.create_skip_info(params[:day].to_date)
            turbo_update(child, params[:day].to_date)
          end
        end
      else
        redirect_to root_path
      end
    end
  end

  def add_info_about_visit
    if @date.present? && @child.present?
      @child.create_visit_info(@date)
      turbo_update(@child, @date)
    else
      redirect_to root_path
    end
  end

  def add_info_about_skip
    if @date.present? && @child.present?
      @child.create_skip_info(@date)
      turbo_update(@child, @date)
    else
      redirect_to root_path
    end
  end

  def refresh_info_about_visit
    if @date.present? && @child.present?
      @child.refresh_visit_info(@date)
      turbo_update(@child, @date)
    else
      redirect_to root_path
    end
  end

  private

  def find_child
    @child = Child.find(params[:child])
  end

  def correct_day
    @date = clean_date_param(params[:day]).to_date if params[:day].present?
  end

  def turbo_update(child, date)
    respond_to do |format|
      format.turbo_stream do
        Turbo::StreamsChannel.broadcast_update_to(
          "#{ child.group.title }_childrens_list_#{ date }",
          target: "child_#{ child.id }",
          partial: "select_report_day/overwrite_info_about_visit",
          locals: { child: child, day: params[:day] }
        )
      end
    end
  end

  def clean_date_param(param)
    param.gsub(/.*?(\b\d{4}-\d{2}-\d{2}\b).*?/, '\1') if param.present?
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
