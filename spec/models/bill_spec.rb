require 'rails_helper'

RSpec.describe Bill, type: :model do
  let(:patient) { FactoryBot.create(:patient) }
  let(:doctor) { FactoryBot.create(:doctor) }
  let(:time_slot) { FactoryBot.create(:time_slot, doctor: doctor) }
  let(:appointment) { FactoryBot.create(:appointment, patient: patient, time_slot: time_slot) }

  describe 'associations' do
    it 'belongs to an appointment' do
      bill = FactoryBot.create(:bill, appointment: appointment)
      expect(bill.appointment).to eq(appointment)
    end

    it 'delegates patient to appointment' do
      bill = FactoryBot.create(:bill, appointment: appointment)
      expect(bill.patient).to eq(patient)
    end
  end

  describe 'validations' do
    it 'requires an amount' do
      bill = Bill.new(appointment: appointment, status: "unpaid", due_date: Date.today + 7)
      expect(bill).not_to be_valid
      expect(bill.errors[:amount]).to be_present
    end

    it 'requires amount to be greater than or equal to 0' do
      bill = Bill.new(appointment: appointment, amount: -10, status: "unpaid", due_date: Date.today + 7)
      expect(bill).not_to be_valid
      expect(bill.errors[:amount]).to be_present
    end

    it 'allows amount to be 0' do
      bill = FactoryBot.create(:bill, appointment: appointment, amount: 0)
      expect(bill).to be_valid
    end

    it 'requires status to be either unpaid or paid' do
      bill = Bill.new(appointment: appointment, amount: 100, status: "pending", due_date: Date.today + 7)
      expect(bill).not_to be_valid
      expect(bill.errors[:status]).to be_present
    end

    it 'allows status to be unpaid' do
      bill = FactoryBot.create(:bill, appointment: appointment, status: "unpaid")
      expect(bill).to be_valid
    end

    it 'allows status to be paid' do
      bill = FactoryBot.create(:bill, appointment: appointment, status: "paid")
      expect(bill).to be_valid
    end

    it 'requires a due_date' do
      bill = Bill.new(appointment: appointment, amount: 100, status: "unpaid")
      expect(bill).not_to be_valid
      expect(bill.errors[:due_date]).to be_present
    end
  end

  describe 'defaults' do
    it 'sets default status to unpaid if not provided' do
      bill = Bill.create!(appointment: appointment, amount: 100, due_date: Date.today + 7)
      expect(bill.status).to eq("unpaid")
    end

    it 'does not override explicitly set status' do
      bill = Bill.create!(appointment: appointment, amount: 100, status: "paid", due_date: Date.today + 7)
      expect(bill.status).to eq("paid")
    end
  end

  describe 'scopes' do
    before do
      @unpaid_bill = FactoryBot.create(:bill, appointment: appointment, status: "unpaid")
      @paid_bill = FactoryBot.create(:bill, appointment: appointment, status: "paid")
    end

    it 'returns unpaid bills' do
      expect(Bill.unpaid).to include(@unpaid_bill)
      expect(Bill.unpaid).not_to include(@paid_bill)
    end

    it 'returns paid bills' do
      expect(Bill.paid).to include(@paid_bill)
      expect(Bill.paid).not_to include(@unpaid_bill)
    end
  end

  describe 'instance methods' do
    let(:bill) { FactoryBot.create(:bill, appointment: appointment, status: "unpaid") }

    describe '#mark_as_paid!' do
      it 'updates status to paid' do
        bill.mark_as_paid!
        expect(bill.status).to eq("paid")
      end
    end

    describe '#paid?' do
      it 'returns true when status is paid' do
        bill.update!(status: "paid")
        expect(bill.paid?).to be true
      end

      it 'returns false when status is unpaid' do
        expect(bill.paid?).to be false
      end
    end

    describe '#unpaid?' do
      it 'returns true when status is unpaid' do
        expect(bill.unpaid?).to be true
      end

      it 'returns false when status is paid' do
        bill.update!(status: "paid")
        expect(bill.unpaid?).to be false
      end
    end
  end
end

