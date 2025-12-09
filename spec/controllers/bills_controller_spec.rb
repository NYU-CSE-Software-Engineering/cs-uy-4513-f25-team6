require 'rails_helper'

RSpec.describe BillsController, type: :controller do
  let(:patient) do
    Patient.create!(
      email: "patient@example.com",
      username: "patient1",
      password: "a" * 32
    )
  end

  let(:clinic) do
    FactoryBot.create(:clinic, name: "Test Clinic")
  end

  let(:doctor) do
    Doctor.create!(
      email: "doctor@example.com",
      username: "doctor1",
      password: "b" * 32,
      clinic: clinic
    )
  end

  let(:time_slot) do
    TimeSlot.create!(
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 9, 0, 0),
      ends_at:   Time.utc(2000, 1, 1, 10, 0, 0)
    )
  end

  let(:appointment) do
    Appointment.create!(
      patient: patient,
      time_slot: time_slot,
      date: Date.today
    )
  end

  let(:bill) do
    Bill.create!(
      appointment: appointment,
      amount: 150.0,
      status: "unpaid",
      due_date: Date.today + 7
    )
  end

  before do
    session[:user_id] = patient.id
  end

  describe "GET #show" do
    it "assigns the requested bill and renders the show template" do
      get :show, params: { id: bill.id }

      expect(response).to have_http_status(:ok)
      expect(assigns(:bill)).to eq(bill)
      expect(response).to render_template(:show)
    end
  end

  describe "PATCH #update" do
    it "marks the bill as paid and redirects back to the billing page with a notice" do
      patch :update, params: { id: bill.id }

      bill.reload
      expect(bill.status).to eq("paid")

      expect(response).to redirect_to(billing_path(bill))
      expect(flash[:notice]).to eq("Bill paid successfully")
    end
  end
end
