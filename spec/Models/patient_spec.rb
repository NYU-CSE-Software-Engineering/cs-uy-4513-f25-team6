require_relative 'shared_user_spec'

describe Patient do
    include_examples 'user model'

    # ---- UNCOMMENT ONCE APPOINTMENTS EXIST ----
    # it 'can access own appointments' do
    #     patient = Patient.create!(email: "test@test.com", username: "testPatient", password: Digest::MD5.hexdigest("testPassword"))
    #     Appointment.create!(patient_id: patient.id, time_slot_id: 2, date: "2025-04-13")
    #     expect(patient.appointments.exists?(time_slot_id: 2)).to be_truthy
    # end

    # ---- UNCOMMENT ONCE PRESCRIPTIONS EXIST ----
    # it 'can access own prescriptions' do
    #     patient = Patient.create!(email: "test@test.com", username: "testPatient", password: Digest::MD5.hexdigest("testPassword"))
    #     Prescription.create!(patient_id: patient.id, doctor_id: 3, medication: "testMed")
    #     expect(patient.prescriptionss.exists?(doctor_id: 3)).to be_truthy
    # end
end