require "rails_helper"

RSpec.describe AppointmentsController, type: :controller do
  let(:patient) do
    Patient.create!(
      email: "patient@example.com",
      username: "patient1",
      password: "a" * 32
    )
  end

  let(:other_patient) do
    Patient.create!(
      email: "other@example.com",
      username: "patient2",
      password: "b" * 32
    )
  end

  let(:doctor) do
    Doctor.create!(
      email: "doctor@example.com",
      username: "doctor1",
      password: "c" * 32
    )
  end

  let(:slot1) do
    TimeSlot.create!(
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 9, 0),
      ends_at:   Time.utc(2000, 1, 1, 9, 30)
    )
  end

  let(:slot2) do
    TimeSlot.create!(
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 10, 0),
      ends_at:   Time.utc(2000, 1, 1, 10, 30)
    )
  end

  let(:slot_other) do
    TimeSlot.create!(
      doctor: doctor,
      starts_at: Time.utc(2000, 1, 1, 11, 0),
      ends_at:   Time.utc(2000, 1, 1, 11, 30)
    )
  end

  let!(:appt1) do
    Appointment.create!(
      patient: patient,
      time_slot: slot1,
      date: Date.new(2025, 1, 1)
    )
  end

  let!(:appt2) do
    Appointment.create!(
      patient: patient,
      time_slot: slot2,
      date: Date.new(2025, 1, 2)
    )
  end

  let!(:other_appt) do
    Appointment.create!(
      patient: other_patient,
      time_slot: slot_other,
      date: Date.new(2025, 1, 3)
    )
  end

  describe "GET #index" do
    before do
      # simulate logged-in patient
      session[:user_id] = patient.id
      get :index
    end

    it "assigns only the current patient's appointments" do
      expect(assigns(:appointments)).to match_array([appt1, appt2])
      expect(assigns(:appointments)).not_to include(other_appt)
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end
  end
end
