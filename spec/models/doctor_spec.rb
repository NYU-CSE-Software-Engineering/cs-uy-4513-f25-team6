require 'rails_helper'
require_relative 'shared_user_spec'

describe Doctor do
    include_examples 'user model'

    # ========== Basic Association Tests ==========
    
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

    it 'belongs to a clinic' do
        clinic = FactoryBot.create(:clinic)
        doctor = FactoryBot.create(:doctor, clinic: clinic)
        expect(doctor.clinic).to eq(clinic)
    end

    it 'can exist without a clinic (optional association)' do
        doctor = FactoryBot.create(:doctor, clinic: nil)
        expect(doctor.clinic).to be_nil
        expect(doctor).to be_valid
    end


    # ========== Search Doctor Feature Tests ==========

    describe '.search_doctor' do # start of testing the .search_doctor() method in the Doctor Model

        before do
            # Create a clinic
            @clinic = FactoryBot.create(:clinic, name: "NYC Health Center")
            
            # Create doctors belonging to this clinic
            @doctor1 = FactoryBot.create(:doctor, 
                username: "john_smith", 
                specialty: "Physical therapy", 
                clinic: @clinic,
                rating: 4.5
            )
            @doctor2 = FactoryBot.create(:doctor, 
                username: "jane_doe", 
                specialty: "Physical therapy", 
                clinic: @clinic,
                rating: 4.0
            )
            @doctor3 = FactoryBot.create(:doctor, 
                username: "bob_wilson", 
                specialty: "Cardiology", 
                clinic: @clinic,
                rating: 3.5
            )
            
            # Create a doctor from another clinic (should not appear in search results)
            @other_clinic = FactoryBot.create(:clinic, name: "LA Health Center")
            @doctor_other_clinic = FactoryBot.create(:doctor, 
                username: "other_doctor", 
                specialty: "Physical therapy", 
                clinic: @other_clinic,
                rating: 5.0
            )
        end

        # Test scenario: search by name and specialty, returns matching doctors
        it 'returns doctors matching both name and specialty within the clinic' do
            results = Doctor.search_doctor("john", "Physical therapy", @clinic.id)
            expect(results).to include(@doctor1)
            expect(results).not_to include(@doctor2, @doctor3, @doctor_other_clinic)
        end

        # Test scenario: search by name only
        it 'returns doctors matching only name within the clinic' do
            results = Doctor.search_doctor("john", "", @clinic.id)
            expect(results).to include(@doctor1)
            expect(results).not_to include(@doctor2, @doctor3)
        end

        # Test scenario: search by specialty only
        it 'returns doctors matching only specialty within the clinic' do
            results = Doctor.search_doctor("", "Physical therapy", @clinic.id)
            expect(results).to include(@doctor1, @doctor2)
            expect(results).not_to include(@doctor3, @doctor_other_clinic)
        end

        # Test scenario: search for non-existent doctor, returns empty array
        it 'returns empty array when no doctors match' do
            results = Doctor.search_doctor("nonexistent", "Pediatrics", @clinic.id)
            expect(results).to be_empty
        end

        # Test scenario: search should only return doctors from the specified clinic
        it 'only returns doctors from the specified clinic' do
            results = Doctor.search_doctor("", "Physical therapy", @clinic.id)
            expect(results).not_to include(@doctor_other_clinic)
        end

        # Test scenario: search should be case-insensitive
        it 'is case-insensitive for name search' do
            results = Doctor.search_doctor("JOHN", "Physical therapy", @clinic.id)
            expect(results).to include(@doctor1)
        end

        it 'is case-insensitive for specialty search' do
            results = Doctor.search_doctor("john", "PHYSICAL THERAPY", @clinic.id)
            expect(results).to include(@doctor1)
        end

    end # end of testing the .search_doctor() method in the Doctor Model


    # ========== Sort By Rating Feature Tests ==========

    describe '.sort_by_rating' do # start of testing the .sort_by_rating() method in the Doctor Model

        before do
            @clinic = FactoryBot.create(:clinic, name: "Test Clinic")
            
            @low_rated_doctor = FactoryBot.create(:doctor, 
                username: "low_doc", 
                clinic: @clinic, 
                rating: 2.0
            )
            @medium_rated_doctor = FactoryBot.create(:doctor, 
                username: "medium_doc", 
                clinic: @clinic, 
                rating: 3.5
            )
            @high_rated_doctor = FactoryBot.create(:doctor, 
                username: "high_doc", 
                clinic: @clinic, 
                rating: 5.0
            )
        end

        # Test scenario: returns doctors sorted by rating in descending order (highest first)
        it 'returns doctors sorted by rating in descending order' do
            results = Doctor.sort_by_rating(@clinic.id).to_a
            expect(results.first).to eq(@high_rated_doctor)
            expect(results.last).to eq(@low_rated_doctor)
        end

        # Test scenario: only returns doctors from the specified clinic
        it 'only returns doctors from the specified clinic' do
            other_clinic = FactoryBot.create(:clinic, name: "Other Clinic")
            other_doctor = FactoryBot.create(:doctor, clinic: other_clinic, rating: 5.0)
            
            results = Doctor.sort_by_rating(@clinic.id)
            expect(results).not_to include(other_doctor)
        end

        # Test scenario: handles doctors with nil ratings (places them last)
        it 'handles doctors with nil ratings (places them last)' do
            no_rating_doctor = FactoryBot.create(:doctor, 
                username: "no_rating_doc", 
                clinic: @clinic, 
                rating: nil
            )
            
            results = Doctor.sort_by_rating(@clinic.id).to_a
            expect(results.last).to eq(no_rating_doctor)
        end

    end # end of testing the .sort_by_rating() method in the Doctor Model


    # ========== Find All Doctors in Clinic ==========

    describe '.doctors_in_clinic' do # start of testing getting all doctors within a clinic

        before do
            @clinic = FactoryBot.create(:clinic, name: "Main Clinic")
            @doctor1 = FactoryBot.create(:doctor, clinic: @clinic)
            @doctor2 = FactoryBot.create(:doctor, clinic: @clinic)
            
            @other_clinic = FactoryBot.create(:clinic, name: "Other Clinic")
            @other_doctor = FactoryBot.create(:doctor, clinic: @other_clinic)
        end

        it 'returns all doctors belonging to a specific clinic' do
            results = Doctor.doctors_in_clinic(@clinic.id)
            expect(results).to include(@doctor1, @doctor2)
            expect(results).not_to include(@other_doctor)
        end

        it 'returns empty array when clinic has no doctors' do
            empty_clinic = FactoryBot.create(:clinic, name: "Empty Clinic")
            results = Doctor.doctors_in_clinic(empty_clinic.id)
            expect(results).to be_empty
        end

    end # end of testing the .doctors_in_clinic() method in the Doctor Model

end