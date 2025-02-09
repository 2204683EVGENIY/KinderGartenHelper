class Mentor < ApplicationRecord
  has_many :group_mentors
  has_many :groups, through: :group_mentors
  has_many :monthly_reports

  validates :first_name, :middle_name, :last_name, presence: true
end
