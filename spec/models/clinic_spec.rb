require 'rails_helper'
require 'spec_helper'
require 'digest'

describe Clinic do
    it 'can be created when all required attributes are present and valid' do
        clinic = Clinic.create!(
            name: "Downtown Clinic",
            specialty: "Dermatology",
            location: "New York",
            rating: 4.5
        )
        expect(clinic.name).to eq("Downtown Clinic")
        expect(clinic.specialty).to eq("Dermatology")
        expect(clinic.location).to eq("New York")
        expect(clinic.rating).to eq(4.5)
    end

    it 'cannot be created when name is missing' do
        # no name
        expect { Clinic.create!(specialty: "Dermatology", location: "New York", rating: 4.5) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not allow duplicate clinic names' do
        # Create first clinic with name "Midtown Health"
        clinic1 = FactoryBot.create(:clinic, name: "Midtown Health")
        # Attempt to create second clinic with same name, this should fail
        expect { FactoryBot.create(:clinic, name: "Midtown Health") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not allow duplicate clinic names with different case (enforces case-insensitive uniqueness)' do
        # Create first clinic with name "Midtown Health"
        clinic1 = FactoryBot.create(:clinic, name: "Midtown Health")
        # Attempt to create second clinic with same name but different case, this should fail
        expect { FactoryBot.create(:clinic, name: "MIDTOWN HEALTH") }.to raise_error(ActiveRecord::RecordInvalid)
        expect { FactoryBot.create(:clinic, name: "midtown health") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows clinics with different names' do
        clinic1 = FactoryBot.create(:clinic, name: "Midtown Health")
        # Different name should work
        expect { FactoryBot.create(:clinic, name: "Downtown Clinic") }.not_to raise_error
    end

    it 'can access associated doctors' do
        clinic = FactoryBot.create(:clinic, name: "Midtown Health")
        doctor = FactoryBot.create(:doctor, clinic: clinic)
        expect(clinic.doctors).to include(doctor)
    end

    it 'allows rating to be within valid range (0.0 to 5.0)' do
        # Valid ratings should work
        expect { FactoryBot.create(:clinic, name: "Clinic A", rating: 0.0) }.not_to raise_error
        expect { FactoryBot.create(:clinic, name: "Clinic B", rating: 5.0) }.not_to raise_error
        expect { FactoryBot.create(:clinic, name: "Clinic C", rating: 3.5) }.not_to raise_error
    end

    it 'does not allow rating outside valid range (less than 0.0 or greater than 5.0)' do
        # Rating less than 0.0 should fail
        expect { FactoryBot.create(:clinic, name: "Clinic A", rating: -0.1) }.to raise_error(ActiveRecord::RecordInvalid)
        # Rating greater than 5.0 should fail
        expect { FactoryBot.create(:clinic, name: "Clinic B", rating: 5.1) }.to raise_error(ActiveRecord::RecordInvalid)
    end


    # This is testing the Search method of the Clinic Model
    describe '.search_clinic' do # start of testing the .search_by_specialty() method in the Clinic Model

        # set up the test environment
          # create three fake clinics with different specialties and locations
        before do
            @clinic1 = Clinic.create!(name: "NYC Dermatology", specialty: "Dermatology", location: "New York", rating: 4.5)
            @clinic2 = Clinic.create!(name: "LA Dermatology", specialty: "Dermatology", location: "Los Angeles", rating: 4.0)
            @clinic3 = Clinic.create!(name: "NYC Cardiology", specialty: "Cardiology", location: "New York", rating: 3.5)
        end
        
        # this is testing a scenario of the .search_by_specialty() method --- it should return clinics matching both specialty and location
        it 'returns clinics matching both specialty and location' do
            results = Clinic.search_clinic("Dermatology", "New York")
            expect(results).to include(@clinic1)
            expect(results).not_to include(@clinic2, @clinic3)
        end
        
        # this is testing a scenario of the .search_by_specialty() method --- it should return clinics matching only specialty 
        it 'returns clinics matching only specialty' do
            results = Clinic.search_clinic("Dermatology", "")
            expect(results).to include(@clinic1, @clinic2)
            expect(results).not_to include(@clinic3)
        end
        
        # this is testing a scenario of the .search_by_specialty() method --- it should return clinics matching only location
        it 'returns clinics matching only location' do
            results = Clinic.search_clinic("", "New York")
            expect(results).to include(@clinic1, @clinic3)
            expect(results).not_to include(@clinic2)
        end
        
        # this is testing a scenario of the .search_by_specialty() method --- it should return an empty array when no clinics match
        it 'returns empty array when no clinics match' do
            results = Clinic.search_clinic("Pediatrics", "Chicago")
            expect(results).to be_empty
        end
    end # end of testing the .search_by_specialty() method in the Clinic Model


    describe '.sort_by_rating' do # start of testing the .sort_by_rating() method in the Clinic Model
        
        # set up the test environment
           # create three fake clinics with different ratings
        before do
            @low_rated_clinic = FactoryBot.create(:clinic, name: "Low Clinic", rating: 2.0)
            @medium_rated_clinic = FactoryBot.create(:clinic, name: "Medium Clinic", rating: 3.0)
            @high_rated_clinic = FactoryBot.create(:clinic, name: "High Clinic", rating: 4.0)
        end 
        
        # this is testing a scenario of the .sort_by_rating() method -- it should return clinics sorted by rating in descending order
        it 'returns clinics sorted by rating in descending order' do
            results = Clinic.sort_by_rating.to_a
            expect(results.first).to eq(@high_rated_clinic)
            expect(results.last).to eq(@low_rated_clinic)
        end

    end # end of testing the .sort_by_ratings() method in the Clinic model 


end


