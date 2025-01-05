class Child < ApplicationRecord
  belongs_to  :group
  has_many :info_about_visits

  validates :first_name, :middle_name, :last_name, :account_number, :active, presence: true
  validates :account_number, numericality: { only_integer: true }, uniqueness: true
  validates :active, inclusion: { in: [true, false] }
end
