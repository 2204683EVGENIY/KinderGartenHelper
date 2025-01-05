class MonthlyReport < ApplicationRecord
  belongs_to :group
  belongs_to :mentor

  validates :report_date, presence: true
  validates :data, presence: true
end
