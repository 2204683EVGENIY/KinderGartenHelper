class Child < ApplicationRecord
  belongs_to  :group
  has_many :info_about_visits

  validates :first_name, :middle_name, :last_name, :account_number, presence: true
  validates :account_number, numeralically: { only_integer: true }, uniquness: true
end
