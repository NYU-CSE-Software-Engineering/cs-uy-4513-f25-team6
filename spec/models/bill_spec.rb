require 'rails_helper'
require 'spec_helper'

RSpec.describe Bill, type: :model do
  let(:patient) { FactoryBot.create(:patient) }
  let(:appointment) { FactoryBot.create(:appointment, patient: patient) }

  it 'is valid with required attributes' do
    bill = described_class.new(patient: patient, appointment: appointment, amount_cents: 1000, status: 'unpaid')
    expect(bill).to be_valid
  end

  it 'requires a positive integer amount' do
    bill = described_class.new(patient: patient, appointment: appointment, amount_cents: -1, status: 'unpaid')
    expect(bill).not_to be_valid
  end

  it 'requires a supported status' do
    bill = described_class.new(patient: patient, appointment: appointment, amount_cents: 1000, status: 'other')
    expect(bill).not_to be_valid
  end

  it 'enforces one bill per appointment' do
    described_class.create!(patient: patient, appointment: appointment, amount_cents: 1000, status: 'unpaid')
    dup = described_class.new(patient: patient, appointment: appointment, amount_cents: 500, status: 'unpaid')
    expect(dup).not_to be_valid
  end

  it 'marks a bill as paid and timestamps it' do
    bill = described_class.create!(patient: patient, appointment: appointment, amount_cents: 1000, status: 'unpaid')
    bill.mark_paid!
    expect(bill).to be_paid
    expect(bill.paid_at).to be_present
  end
end
