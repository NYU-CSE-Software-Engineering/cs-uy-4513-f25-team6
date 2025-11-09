require_relative 'shared_user_spec'

describe Patient do
    include_examples 'user model'

    it 'can access own appointments' do
        patient = FactoryBot.create(:patient)
        slot = FactoryBot.create(:time_slot)
        FactoryBot.create(:appointment, patient: patient, time_slot: slot)
        expect(patient.appointments.exists?(time_slot: slot)).to be_truthy
    end

    # ---- UNCOMMENT ONCE PRESCRIPTIONS EXIST ----
    # it 'can access own prescriptions' do
    #     patient = Patient.create!(email: "test@test.com", username: "testPatient", password: Digest::MD5.hexdigest("testPassword"))
    #     Prescription.create!(patient_id: patient.id, doctor_id: 3, medication: "testMed")
    #     expect(patient.prescriptionss.exists?(doctor_id: 3)).to be_truthy
    # end
end