require 'rails_helper'
require 'spec_helper'
require 'digest' 

RSpec.describe Appointment, type: :model do

  # --- Setup ---
  before :each do
    @doctor = Doctor.create!(
      email: "spec_doc@test.com",
      username: "spec_doc",
      password: Digest::MD5.hexdigest("password123")
    )
    
    @patient = Patient.create!(
      email: "spec_pat@test.com",
      username: "spec_pat",
      password: Digest::MD5.hexdigest("password123")
    )

    # A reusable TimeSlot, e.g., "10:00 AM - 10:30 AM"
    @time_slot = TimeSlot.create!(
      doctor: @doctor,
      starts_at: "10:00", 
      ends_at: "10:30"
    )

    @appointment_date = Date.parse("2026-01-10")
  end

  # --- Happy Path ---
  
  it 'can be created when all required attributes are present' do
    expect {
      Appointment.create!(
        doctor: @doctor,
        patient: @patient,
        time_slot: @time_slot,
        date: @appointment_date
      )
    }.not_to raise_error
  end

  # --- Associations ---
  
  it 'can access its associated patient, doctor, and time_slot' do
    appointment = Appointment.create!(
      doctor: @doctor,
      patient: @patient,
      time_slot: @time_slot,
      date: @appointment_date
    )

    expect(appointment.patient).to eq(@patient)
    expect(appointment.doctor).to eq(@doctor)
    expect(appointment.time_slot).to eq(@time_slot)
  end

  it 'can be accessed from its patient' do
    appointment = Appointment.create!(doctor: @doctor, patient: @patient, time_slot: @time_slot, date: @appointment_date)
    expect(@patient.appointments).to include(appointment)
  end

  it 'can be accessed from its doctor' do
    appointment = Appointment.create!(doctor: @doctor, patient: @patient, time_slot: @time_slot, date: @appointment_date)
    expect(@doctor.appointments).to include(appointment)
  end

  # --- Validations (Sad Paths) ---
  
  it 'cannot be created when doctor is missing' do
    # no doctor
    expect {
      Appointment.create!(patient: @patient, time_slot: @time_slot, date: @appointment_date)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'cannot be created when patient is missing' do
    # no patient
    expect {
      Appointment.create!(doctor: @doctor, time_slot: @time_slot, date: @appointment_date)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'cannot be created when time_slot is missing' do
    # no time_slot
    expect {
      Appointment.create!(doctor: @doctor, patient: @patient, date: @appointment_date)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'cannot be created when date is missing' do
    # no date
    expect {
      Appointment.create!(doctor: @doctor, patient: @patient, time_slot: @time_slot)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  # --- Double Booking Logic ---
  
  it 'cannot be created if the time slot is already taken for that doctor on that date' do
    patient_a = Patient.create!(email: "patient_a@test.com", username: "patient_a_spec", password: Digest::MD5.hexdigest("pass"))
    patient_b = Patient.create!(email: "patient_b@test.com", username: "patient_b_spec", password: Digest::MD5.hexdigest("pass"))

    # 1. Create the first appointment (the "taken" one)
    Appointment.create!(
      doctor: @doctor,
      patient: patient_a,
      time_slot: @time_slot,
      date: @appointment_date
    )

    # 2. Attempt to create the second appointment for the *same doctor*, *same time_slot*, and *same date*
    expect {
      Appointment.create!(
        doctor: @doctor,        # Same doctor
        patient: patient_b,     # Different patient
        time_slot: @time_slot,  # Same time slot
        date: @appointment_date # Same date
      )
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'CAN be created if the time slot is taken by a DIFFERENT doctor' do
    doctor_b = Doctor.create!(email: "doctor_b@test.com", username: "doctor_b_spec", password: Digest::MD5.hexdigest("pass"))
    time_slot_b = TimeSlot.create!(doctor: doctor_b, starts_at: "10:00", ends_at: "10:30") # This slot belongs to doctor_b
    patient_a = Patient.create!(email: "patient_a2@test.com", username: "patient_a2_spec", password: Digest::MD5.hexdigest("pass"))
    patient_b = Patient.create!(email: "patient_b2@test.com", username: "patient_b2_spec", password: Digest::MD5.hexdigest("pass"))

    # 1. Create appointment for Doctor A
    Appointment.create!(doctor: @doctor, patient: patient_a, time_slot: @time_slot, date: @appointment_date)

    # 2. Create appointment for Doctor B at the same time/date (should work)
    expect {
      Appointment.create!(
        doctor: doctor_b,        # Different doctor
        patient: patient_b,
        time_slot: time_slot_b,  # Different time slot
        date: @appointment_date  # Same date
      )
    }.not_to raise_error
  end

  it 'CAN be created for the same doctor at a DIFFERENT time slot' do
    time_slot_b = TimeSlot.create!(doctor: @doctor, starts_at: "11:00", ends_at: "11:30")
    patient_a = Patient.create!(email: "patient_a3@test.com", username: "patient_a3_spec", password: Digest::MD5.hexdigest("pass"))
    patient_b = Patient.create!(email: "patient_a3@test.com", username: "patient_b3_spec", password: Digest::MD5.hexdigest("pass"))

    # 1. Create appointment for Time Slot A
    Appointment.create!(doctor: @doctor, patient: patient_a, time_slot: @time_slot, date: @appointment_date)

    # 2. Create appointment for the same doctor on the same date, but Time Slot B
    expect {
      Appointment.create!(
        doctor: @doctor,        # Same doctor
        patient: patient_b,
        time_slot: time_slot_b, # Different time slot
        date: @appointment_date # Same date
      )
    }.not_to raise_error
  end

  it 'CAN be created for the same doctor at the same time slot on a DIFFERENT date' do
    date_b = Date.parse("2026-01-11")
    patient_a = Patient.create!(email: "patient_a4@test.com", username: "patient_a4_spec", password: Digest::MD5.hexdigest("pass"))
    patient_b = Patient.create!(email: "patient_b4@test.com", username: "patient_b4_spec", password: Digest::MD5.hexdigest("pass"))

    # 1. Create appointment for Date A
    Appointment.create!(doctor: @doctor, patient: patient_a, time_slot: @time_slot, date: @appointment_date)

    # 2. Create appointment for the same doctor/slot on Date B
    expect {
      Appointment.create!(
        doctor: @doctor,        # Same doctor
        patient: patient_b,
        time_slot: @time_slot, # Same time slot
        date: date_b         # Different date
      )
    }.not_to raise_error
  end
end