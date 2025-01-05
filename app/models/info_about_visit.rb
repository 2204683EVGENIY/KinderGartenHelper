class InfoAboutVisit < ApplicationRecord
  belongs_to :child

  enum reason: {
    sick: 0,
    vacation: 1,
    other: 2
  }

  validates :date, presence: true
  validates :kindergarten_visited, inclusion: { in: [true, false] }
end
