require 'rails_helper'

RSpec.describe "Schedule Appointments (request)", type: :request do
  describe "GET /doctors/:id/time_slots" do
    it "renders the schedule page and lists available slots" do
      doctor_class   = class_double("Doctor").as_stubbed_const
      timeslot_class = class_double("TimeSlot").as_stubbed_const

      doctor_d = instance_double("Doctor", id: 42, username: "dr_user")
      slot1    = instance_double("TimeSlot", id: 101,
                                 starts_at: Time.zone.parse("2000-01-01 09:00"),
                                 ends_at:   Time.zone.parse("2000-01-01 09:30"))
      slot2    = instance_double("TimeSlot", id: 102,
                                 starts_at: Time.zone.parse("2000-01-01 09:30"),
                                 ends_at:   Time.zone.parse("2000-01-01 10:00"))

      expect(doctor_class).to receive(:find).with(doctor_d.id.to_s).and_return(doctor_d)
      expect(timeslot_class).to receive_message_chain(:joins, :where).and_return([])
      expect(timeslot_class).to receive_message_chain(:where, :excluding, :order).and_return([slot1, slot2])

      get doctor_time_slots_path(doctor_d.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Available time slots")
      expect(response.body).to include("9:00")
      expect(response.body).to include("9:30")
    end
  end

  describe "POST /appointments" do
    it "books when slot is available (happy path)" do
      appointment_c = class_double("Appointment").as_stubbed_const
      doctor_c      = class_double("Doctor").as_stubbed_const
      timeslot_c    = class_double("TimeSlot").as_stubbed_const

      doctor = instance_double("Doctor", id: 7, username: "dr_user")
      slot   = instance_double("TimeSlot", id: 101, doctor: doctor)

      expect(timeslot_c).to receive(:find).with("101").and_return(slot)
      expect(appointment_c).to receive(:exists?).with(time_slot_id: 101).and_return(false)
      expect(appointment_c).to receive(:create!).with(patient_id: anything, time_slot: slot, date: anything)

      post appointments_path, params: { appointment: { time_slot_id: 101 } }

      expect(response).to redirect_to(patient_appointments_path)
      follow_redirect!
      expect(response.body).to include("Appointment confirmed")
    end

    it "rejects when slot is taken (sad path)" do
      appointment_c = class_double("Appointment").as_stubbed_const
      doctor_c      = class_double("Doctor").as_stubbed_const
      timeslot_c    = class_double("TimeSlot").as_stubbed_const

      doctor = instance_double("Doctor", id: 7, username: "dr_user")
      slot   = instance_double("TimeSlot", id: 101, doctor: doctor)

      expect(timeslot_c).to receive(:find).with("101").and_return(slot)
      expect(appointment_c).to receive(:exists?).with(time_slot_id: 101).and_return(true)
      expect(appointment_c).not_to receive(:create!)

      post appointments_path, params: { appointment: { time_slot_id: 101, doctor_id: 7 } }

      expect(response).to redirect_to(doctor_time_slots_path(doctor.id))

      # After redirect, the GET schedule page runs and will call Doctor.find / TimeSlot.where
      expect(doctor_c).to receive(:find).with(doctor.id.to_s).and_return(doctor)
      expect(timeslot_c).to receive_message_chain(:joins, :where).and_return([])
      expect(timeslot_c).to receive_message_chain(:where, :excluding, :order).and_return([])

      follow_redirect!
      expect(response.body).to include("Time slot no longer available")
    end
  end

  describe "GET /patient/appointments" do
    it "renders the patient appointments page (redirect destination)" do
      get patient_appointments_path
      expect(response).to have_http_status(:ok)
    end
  end
end
