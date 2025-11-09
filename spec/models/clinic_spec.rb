require 'rails_helper'
require 'spec_helper'
require 'digest'

describe Clinic do
    it 'can be created when all required attributes are present and valid' do
        expect { Clinic.create!(name: "Midtown Health") }.not_to raise_error
    end

    it 'can be created with optional attributes (specialty, location, rating)' do
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
        clinic1 = Clinic.create!(name: "Midtown Health")
        # Attempt to create second clinic with same name, this should fail
        expect { Clinic.create!(name: "Midtown Health") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not allow duplicate clinic names with different case (enforces case-insensitive uniqueness)' do
        # Create first clinic with name "Midtown Health"
        clinic1 = Clinic.create!(name: "Midtown Health")
        # Attempt to create second clinic with same name but different case, this should fail
        expect { Clinic.create!(name: "MIDTOWN HEALTH") }.to raise_error(ActiveRecord::RecordInvalid)
        expect { Clinic.create!(name: "midtown health") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows clinics with different names' do
        clinic1 = Clinic.create!(name: "Midtown Health")
        # Different name should work
        expect { Clinic.create!(name: "Downtown Clinic") }.not_to raise_error
    end

    it 'can access associated doctors' do
        clinic = Clinic.create!(name: "Midtown Health")
        doctor = FactoryBot.create(:doctor, clinic: clinic)
        expect(clinic.doctors).to include(doctor)
    end

    it 'allows rating to be within valid range (0.0 to 5.0)' do
        # Valid ratings should work
        expect { Clinic.create!(name: "Clinic A", rating: 0.0) }.not_to raise_error
        expect { Clinic.create!(name: "Clinic B", rating: 5.0) }.not_to raise_error
        expect { Clinic.create!(name: "Clinic C", rating: 3.5) }.not_to raise_error
    end

    it 'does not allow rating outside valid range (less than 0.0 or greater than 5.0)' do
        # Rating less than 0.0 should fail
        expect { Clinic.create!(name: "Clinic A", rating: -0.1) }.to raise_error(ActiveRecord::RecordInvalid)
        # Rating greater than 5.0 should fail
        expect { Clinic.create!(name: "Clinic B", rating: 5.1) }.to raise_error(ActiveRecord::RecordInvalid)
    end
end

