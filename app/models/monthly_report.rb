class MonthlyReport < ApplicationRecord
  belongs_to :group
  belongs_to :mentor

  has_many_attached :files

  after_create :generate_report_files

  validates :report_date, presence: true
  validates :data, presence: true

  private

  def generate_report_files
    xls_file = generate_xls
  end

  def generate_xls
  end
end
