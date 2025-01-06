class InfoAboutVisit < ApplicationRecord
  belongs_to :child

  enum :reason, sick: 0, vacation: 1, other: 2

  validates :date, presence: true
  validates :kindergarten_visited, inclusion: { in: [ true, false ] }

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
