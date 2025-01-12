class Group < ApplicationRecord
  has_many :mentors
  has_many :childrens, class_name: "Child"
  has_many :monthly_reports

  validates :title, presence: true, uniqueness: true
end
