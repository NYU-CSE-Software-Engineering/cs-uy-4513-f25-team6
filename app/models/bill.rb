class Bill < ApplicationRecord
  belongs_to :appointment

  delegate :patient, to: :appointment

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[unpaid paid] }
end
