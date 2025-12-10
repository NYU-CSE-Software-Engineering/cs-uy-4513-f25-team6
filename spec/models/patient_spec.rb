require_relative 'shared_user_spec'

describe Patient do
    include_examples 'user model'

    it 'can access own appointments' do
        patient = FactoryBot.create(:patient)
        slot = FactoryBot.create(:time_slot)
        FactoryBot.create(:appointment, patient: patient, time_slot: slot)
        expect(patient.appointments.exists?(time_slot: slot)).to be_truthy
    end

    it 'can access own prescriptions' do
        patient = FactoryBot.create(:patient)
        doctor = FactoryBot.create(:doctor)
        Prescription.create!(
            patient: patient,
            doctor: doctor,
            medication_name: 'med',
            dosage: '',
            instructions: '',
            issued_on: Date.today,
            status: 'active'
        )
        expect(patient.prescriptions.exists?(doctor: doctor, medication_name: 'med')).to be_truthy
    end
end