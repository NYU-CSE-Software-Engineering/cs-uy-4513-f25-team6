class Bill < ApplicationRecord
  belongs_to :appointment

  delegate :patient, to: :appointment

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[unpaid paid] }
  validates :due_date, presence: true

  before_validation :set_default_status, on: :create

  scope :unpaid, -> { where(status: "unpaid") }
  scope :paid, -> { where(status: "paid") }

  def mark_as_paid!
    update!(status: "paid")
  end

  def paid?
    status == "paid"
  end

  def unpaid?
    status == "unpaid"
  end

  private

  def set_default_status
    self.status ||= "unpaid"
  end
end
