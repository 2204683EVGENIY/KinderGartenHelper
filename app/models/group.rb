class Group < ApplicationRecord
  has_many :group_mentors
  has_many :mentors, through: :group_mentors
  has_many :childrens, class_name: "Child"
  has_many :monthly_reports

  validates :title, presence: true, uniqueness: true
end
