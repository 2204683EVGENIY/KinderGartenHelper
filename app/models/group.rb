class Group < ApplicationRecord
  has_many :mentors
  has_many :childrens
  has_many :monthly_reports

  validates :title, presence: true
end
