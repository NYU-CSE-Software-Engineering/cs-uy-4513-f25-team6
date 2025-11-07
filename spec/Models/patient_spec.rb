require_relative 'shared_user_spec'

describe Patient do
    include_examples 'user model'

    it 'can access own appointments' do
        patient = Patient.create!(email: "test@test.com", username: "testPatient", password: Digest::MD5.hexdigest("testPassword"))
        doctor = Doctor.create!(email: "test@test.com", username: "testDoctor", password: Digest::MD5.hexdigest("testPassword"))
        slot = TimeSlot.create!(doctor_id: doctor.id, starts_at: "10:00", ends_at: "10:30")
        Appointment.create!(patient_id: patient.id, time_slot_id: slot.id, date: "2025-04-13")
        expect(patient.appointments.exists?(time_slot_id: slot.id)).to be_truthy
    end

    # ---- UNCOMMENT ONCE PRESCRIPTIONS EXIST ----
    # it 'can access own prescriptions' do
    #     patient = Patient.create!(email: "test@test.com", username: "testPatient", password: Digest::MD5.hexdigest("testPassword"))
    #     Prescription.create!(patient_id: patient.id, doctor_id: 3, medication: "testMed")
    #     expect(patient.prescriptionss.exists?(doctor_id: 3)).to be_truthy
    # end
end