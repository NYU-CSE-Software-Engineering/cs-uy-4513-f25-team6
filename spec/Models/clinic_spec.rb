require 'rails_helper'
require 'spec_helper'

describe Clinic do
    it 'does not allow duplicate clinic names' do
        # Create first clinic with name "Midtown Health"
        clinic1 = Clinic.create!(name: "Midtown Health")
        # Attempt to create second clinic with same name, this should fail
        expect { Clinic.create!(name: "Midtown Health") }.to raise_error(ActiveRecord::RecordInvalid)
    end
end

