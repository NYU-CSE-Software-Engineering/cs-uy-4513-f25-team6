class Prescription < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  STATUSES = %w[active expired cancelled].freeze

  validates :medication_name, presence: true
  validates :issued_on, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :by_status, ->(status) { where(status: status) if status.present? && STATUSES.include?(status) }
  scope :recent_first, -> { order(issued_on: :desc) }
end
