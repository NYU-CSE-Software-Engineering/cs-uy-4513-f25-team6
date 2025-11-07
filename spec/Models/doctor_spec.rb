require_relative 'shared_user_spec'

describe Doctor do
    include_examples 'user model'

    # ---- UNCOMMENT ONCE TIME SLOTS EXIST ----
    # it 'can access own time slots' do
    #     doctor = Doctor.create!(email: "test@test.com", username: "testDoctor", password: Digest::MD5.hexdigest("testPassword"))
    #     slot = TimeSlot.create!(doctor_id: doctor.id, starts_at: "11:00", ends_at: "11:30")
    #     expect(doctor.time_slots).to include(slot)
    # end

    # ---- UNCOMMENT ONCE APPOINTMENTS EXIST ----
    # it 'can access own appointments' do
    #     doctor = Doctor.create!(email: "test@test.com", username: "testDoctor", password: Digest::MD5.hexdigest("testPassword"))
    #     Appointment.create!(patient_id: 1, time_slot_id: 2, date: "2025-04-13")
    #     expect(patient.appointments.exists?(time_slot_id: 2)).to be_truthy
    # end
end