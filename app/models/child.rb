class Child < ApplicationRecord
  default_scope { order(first_name: :asc) }

  belongs_to :group
  has_many :info_about_visits

  validates :first_name, :middle_name, :last_name, :account_number, :active, presence: true
  validates :account_number, numericality: { only_integer: true }, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }

  before_validation :add_rand_account_number
  before_validation :add_last_name

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

  def delete_visit_info(date)
    info_about_visits.find_by(date: date).destroy
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

  private

  def add_rand_account_number
    self.account_number = rand(100_000..999_999)
  end

  def add_last_name
    self.last_name = "NONE" if self.last_name.blank?
  end
end
