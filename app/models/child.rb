class Child < ApplicationRecord
  belongs_to :group
  has_many :info_about_visits

  validates :first_name, :middle_name, :last_name, :account_number, :active, presence: true
  validates :account_number, numericality: { only_integer: true }, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }

  def find_info_about_visits_for_correction(month, year)
    start_of_month = Date.new(year, month, 1)
    month_range = start_of_month..start_of_month.end_of_month

    info_about_visits.where(kindergarten_visited: false).order(date: :desc).select { |info| month_range.include?(info.date) }
  end

  def create_visit_info(date)
    info_about_visits.create(date: date, kindergarten_visited: true, reason: nil)
  end

  def create_skip_info(date)
    info_about_visits.create(date: date, kindergarten_visited: false, reason: "other")
  end

  def refresh_visit_info(date)
    check_info_about_visits = info_about_visits.find_by(date: date)

    if check_info_about_visits.kindergarten_visited == true
      check_info_about_visits.update(
        kindergarten_visited: false,
        reason: "other"
      )
    else
      check_info_about_visits.update(
        kindergarten_visited: true,
        reason: nil
      )
    end
  end

  def today_visited?(day)
    info_about_visits.find_by(date: day.to_date).kindergarten_visited
  end

  def info_already_present?(day)
    info_about_visits.find_by(date: day.to_date).present?
  end
end
