class InfoAboutVisit < ApplicationRecord
  belongs_to :child

  scope :get_visits_by_date, ->(date) { where(date: date).index_by(&:child_id) }

  enum :reason, sick: 0, vacation: 1, other: 2

  validates :date, presence: true
  validates :kindergarten_visited, inclusion: { in: [ true, false ] }

  def update_visit_info(value)
    update!(reason: value)
  end

  def reason=(value)
    begin
      super(value)
    rescue ArgumentError => err
      self.errors.add(:reason, "#{ err.message }")
      @invalid_reason = true
    end
  end

  def valid?(context = nil)
    return false if @invalid_reason
    super
  end
end
