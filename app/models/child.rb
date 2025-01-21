class Child < ApplicationRecord
  belongs_to  :group
  has_many :info_about_visit

  validates :first_name, :middle_name, :last_name, :account_number, :active, presence: true
  validates :account_number, numericality: { only_integer: true }, uniqueness: true
  validates :active, inclusion: { in: [ true, false ] }

  def create_visit_info(date)
    info_about_visit.create(date: date, kindergarten_visited: true, reason: nil)
  end

  def create_skip_info(date)
    info_about_visit.create(date: date, kindergarten_visited: false, reason: "other")
  end

  def refresh_visit_info(date)
    check_info_about_visit = info_about_visit.find_by(date: date)

    if check_info_about_visit.kindergarten_visited == true
      check_info_about_visit.update(
        kindergarten_visited: false,
        reason: "other"
      )
    else
      check_info_about_visit.update(
        kindergarten_visited: true,
        reason: nil
      )
    end
  end

  def today_visited?(day)
    info_about_visit.find_by(date: day.to_date).kindergarten_visited
  end

  def info_already_present?(day)
    info_about_visit.find_by(date: day.to_date).present?
  end
end
