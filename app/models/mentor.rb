class Mentor < ApplicationRecord
  has_many :group_mentors
  has_many :groups, through: :group_mentors
  has_many :monthly_reports
  belongs_to :user

  validates :first_name, :middle_name, :last_name, presence: true

  def has_monthly_reports?
    monthly_reports.any?
  end
end
