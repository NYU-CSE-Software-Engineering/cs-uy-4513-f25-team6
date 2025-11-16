require_relative 'shared_user_spec'

describe Doctor do
    include_examples 'user model'

    it 'can access own time slots' do
        doctor = FactoryBot.create(:doctor)
        slot = FactoryBot.create(:time_slot, doctor: doctor)
        expect(doctor.time_slots).to include(slot)
    end

    it 'can access own appointments' do
        doctor = FactoryBot.create(:doctor)
        patient = FactoryBot.create(:patient)
        slot = FactoryBot.create(:time_slot, doctor: doctor)
        FactoryBot.create(:appointment, patient: patient, time_slot: slot)
        expect(doctor.appointments.exists?(time_slot: slot)).to be_truthy
    end
end