require 'rails_helper'
require 'spec_helper'
require 'digest' 

RSpec.describe Appointment, type: :model do

  # --- Setup ---
  before :each do
    @doctor = FactoryBot.create(:doctor)
    @patient = FactoryBot.create(:patient)
    @time_slot = FactoryBot.create(:time_slot, doctor: @doctor)
    @appointment_date = Date.parse("2026-01-10")
  end

  # --- Happy Path ---
  
  it 'can be created when all required attributes are present' do
    expect {
      Appointment.create!(
        patient: @patient,
        time_slot: @time_slot,
        date: @appointment_date
      )
    }.not_to raise_error
  end

  # --- Associations ---
  
  it 'can access its associated patient, doctor, and time_slot' do
    appointment = Appointment.create!(
      patient: @patient,
      time_slot: @time_slot,
      date: @appointment_date
    )

    expect(appointment.patient).to eq(@patient)
    expect(appointment.doctor).to eq(@doctor)
    expect(appointment.time_slot).to eq(@time_slot)
  end

  it 'can be accessed from its patient' do
    appointment = Appointment.create!(patient: @patient, time_slot: @time_slot, date: @appointment_date)
    expect(@patient.appointments).to include(appointment)
  end

  it 'can be accessed from its doctor' do
    appointment = Appointment.create!(patient: @patient, time_slot: @time_slot, date: @appointment_date)
    expect(@doctor.appointments).to include(appointment)
  end

  # --- Validations (Sad Paths) ---

  it 'cannot be created when patient is missing' do
    # no patient
    expect {
      Appointment.create!(time_slot: @time_slot, date: @appointment_date)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'cannot be created when time_slot is missing' do
    # no time_slot
    expect {
      Appointment.create!(patient: @patient, date: @appointment_date)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'cannot be created when date is missing' do
    # no date
    expect {
      Appointment.create!(patient: @patient, time_slot: @time_slot)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  # --- Double Booking Logic ---
  
  it 'cannot be created if the time slot is already taken for that doctor on that date' do
    patient_b = FactoryBot.create(:patient)

    # 1. Create the first appointment (the "taken" one)
    Appointment.create!(
      doctor: @doctor,
      patient: @patient,
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
    doctor_b = FactoryBot.create(:doctor)
    time_slot_b = FactoryBot.create(:time_slot, doctor: doctor_b)
    patient_b = FactoryBot.create(:patient)

    # 1. Create appointment for Doctor A
    Appointment.create!(doctor: @doctor, patient: @patient, time_slot: @time_slot, date: @appointment_date)

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
    time_slot_b = FactoryBot.create(:time_slot, doctor: @doctor)
    patient_b = FactoryBot.create(:patient)

    # 1. Create appointment for Time Slot A
    Appointment.create!(doctor: @doctor, patient: @patient, time_slot: @time_slot, date: @appointment_date)

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
    patient_b = FactoryBot.create(:patient)

    # 1. Create appointment for Date A
    Appointment.create!(doctor: @doctor, patient: @patient, time_slot: @time_slot, date: @appointment_date)

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

  # --- Bill Creation Callback ---

  it 'automatically creates a bill when an appointment is created' do
    appointment = Appointment.create!(
      patient: @patient,
      time_slot: @time_slot,
      date: @appointment_date
    )

    expect(appointment.bill).to be_present
    expect(appointment.bill.status).to eq("unpaid")
    expect(appointment.bill.amount).to eq(100.0)
    expect(appointment.bill.due_date).to eq(@appointment_date + 7.days)
  end
end