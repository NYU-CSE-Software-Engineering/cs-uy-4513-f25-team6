class Bill < ApplicationRecord
  STATUSES = %w[unpaid paid].freeze

  belongs_to :patient
  belongs_to :appointment

  validates :amount_cents, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :appointment_id, uniqueness: true

  scope :paid, -> { where(status: 'paid') }
  scope :unpaid, -> { where(status: 'unpaid') }

  def mark_paid!(time: Time.current)
    update!(status: 'paid', paid_at: time)
  end

  def paid?
    status == 'paid'
  end
end
