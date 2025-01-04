class Mentor < ApplicationRecord
  belongs_to :group
  has_many :tables

  validates :first_name, :middle_name, :last_name, presence: true
end
