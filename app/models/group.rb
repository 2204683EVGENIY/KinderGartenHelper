class Group < ApplicationRecord
  has_many :mentors
  has_many :childrens
  has_many :tables

  validates :title, presence: true
end
