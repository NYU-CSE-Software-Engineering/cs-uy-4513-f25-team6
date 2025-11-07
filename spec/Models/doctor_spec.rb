require_relative 'shared_user_spec'

describe Doctor do
    include_examples 'user model'

    it 'can access own time slots' do
        doctor = Doctor.create!(email: "test@test.com", username: "testDoctor", password: Digest::MD5.hexdigest("testPassword"))
        slot = TimeSlot.create!(doctor_id: doctor.id, starts_at: "11:00", ends_at: "11:30")
        expect(doctor.time_slots).to include(slot)
    end

    it 'can access own appointments' do
        doctor = Doctor.create!(email: "test@test.com", username: "testDoctor", password: Digest::MD5.hexdigest("testPassword"))
        patient = Patient.create!(email: "test2@test.com", username: "testPatient", password: Digest::MD5.hexdigest("testPassword"))
        slot = TimeSlot.create!(doctor_id: doctor.id, starts_at: "10:00", ends_at: "10:30")
        Appointment.create!(patient_id: patient.id, time_slot_id: slot.id, date: "2025-04-13")
        expect(doctor.appointments.exists?(time_slot_id: slot.id)).to be_truthy
    end
end