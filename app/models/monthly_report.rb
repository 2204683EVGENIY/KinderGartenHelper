class MonthlyReport < ApplicationRecord
  belongs_to :group
  belongs_to :mentor

  has_many_attached :files

  validates :report_date, presence: true
  validates :data, presence: true
end
