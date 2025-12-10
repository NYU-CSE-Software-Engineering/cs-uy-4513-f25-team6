require 'rails_helper'

RSpec.describe "Schedule Appointments (request)", type: :request do
  let(:appointment_class) { class_double("Appointment").as_stubbed_const }
  let(:doctor_class) { class_double("Doctor").as_stubbed_const }
  let(:time_slot_class) { class_double("TimeSlot").as_stubbed_const }

  describe "GET /doctors/:id/time_slots" do
    it "renders the schedule page and lists available slots" do
      login_patient
      doctor = instance_double("Doctor", id: 42, username: "dr_user")
      slot1    = instance_double("TimeSlot", id: 101,
                                 starts_at: Time.zone.parse("2000-01-01 09:00"),
                                 ends_at:   Time.zone.parse("2000-01-01 09:30"))
      slot2    = instance_double("TimeSlot", id: 102,
                                 starts_at: Time.zone.parse("2000-01-01 09:30"),
                                 ends_at:   Time.zone.parse("2000-01-01 10:00"))                

      expect(doctor_class).to receive(:find).with(doctor.id.to_s).and_return(doctor)
      expect(time_slot_class).to receive_message_chain(:joins, :where).and_return([])
      expect(time_slot_class).to receive_message_chain(:where, :excluding, :order).and_return([slot1, slot2])

      get doctor_time_slots_path(doctor.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Available time slots")
      expect(response.body).to include(/9:00([ -APM]*)9:30/)
      expect(response.body).to include(/9:30([ -APM]*)10:00/)
    end

    it "redirects when not logged in" do
      get doctor_time_slots_path(1)
      expect(response).to redirect_to(login_path)
    end
  end

  describe "POST /appointments" do
    it "books when slot is available (happy path)" do
      login_patient
      doctor = instance_double("Doctor", id: 7, username: "dr_user")
      slot   = instance_double("TimeSlot", id: 101, doctor: doctor)

      expect(time_slot_class).to receive(:find).with("101").and_return(slot)
      expect(appointment_class).to receive(:exists?).with(time_slot: slot, date: '2025-04-13').and_return(false)
      expect(appointment_class).to receive(:create!).with(patient_id: anything, time_slot: slot, date: "2025-04-13")

      post appointments_path, params: { appointment: { time_slot_id: 101, date: "2025-04-13" } }

      expect(response).to redirect_to(patient_appointments_path)
      follow_redirect!
      expect(response.body).to include("Appointment confirmed")
    end

    it "rejects when slot is taken (sad path)" do
      login_patient
      doctor = instance_double("Doctor", id: 7, username: "dr_user")
      slot   = instance_double("TimeSlot", id: 101, doctor: doctor)

      expect(time_slot_class).to receive(:find).with("101").and_return(slot)
      expect(appointment_class).to receive(:exists?).with(time_slot: slot, date: '2025-04-13').and_return(true)
      expect(appointment_class).not_to receive(:create!)

      post appointments_path, params: { appointment: { time_slot_id: 101, doctor_id: 7, date: '2025-04-13' } }

      expect(response).to redirect_to(doctor_time_slots_path(doctor.id))

      # After redirect, the GET schedule page runs and will call Doctor.find / TimeSlot.where
      expect(doctor_class).to receive(:find).with(doctor.id.to_s).and_return(doctor)
      expect(time_slot_class).to receive_message_chain(:joins, :where).and_return([])
      expect(time_slot_class).to receive_message_chain(:where, :excluding, :order).and_return([])

      follow_redirect!
      expect(response.body).to include("Time slot no longer available")
    end
  end

  describe "GET /patient/appointments" do
    it "renders the patient appointments page (redirect destination)" do
      login_patient
      get patient_appointments_path
      expect(response).to have_http_status(:ok)
    end
  end
end
