require 'rails_helper'
require 'spec_helper'

describe TimeSlot do
    before :each do
        @doc_id = Doctor.create!(email: "test@test.com", username: "testDoctor", password: Digest::MD5.hexdigest("testPassword")).id
    end
    
    it 'can be created when all attributes are present and valid' do
        expect { TimeSlot.create!(doctor_id: @doc_id, starts_at: "10:00", ends_at: "10:30") }.not_to raise_error
    end

    it 'cannot be created when attributes are missing' do
        # no doctor id
        expect { TimeSlot.create!(starts_at: "10:30", ends_at: "10:00") }.to raise_error(ActiveRecord::RecordInvalid)
        # no start time
        expect { TimeSlot.create!(doctor_id: @doc_id, ends_at: "10:00") }.to raise_error(ActiveRecord::RecordInvalid)
        # no end time
        expect { TimeSlot.create!(doctor_id: @doc_id, starts_at: "10:30") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not allow start time later than end time' do
        # start time 10:30am > end time 10:00am
        expect { TimeSlot.create!(doctor_id: @doc_id, starts_at: "10:30", ends_at: "10:00") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not allow duplicate slots on the same doctor' do
        # 10:00am to 10:30am, this one should work
        slot1 = TimeSlot.create!(doctor_id: @doc_id, starts_at: "10:00", ends_at: "10:30")
        # exact same as slot1, this one should fail since dupes aren't allowed
        expect { TimeSlot.create!(doctor_id: @doc_id, starts_at: "10:00", ends_at: "10:30") }.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it 'does not allow overlapping slots on same doctor' do
        # 10:00am to 10:30am, this one should work
        slot1 = TimeSlot.create!(doctor_id: @doc_id, starts_at: "10:00", ends_at: "10:30")
        # 10:15am to 10:45am, this one should fail since it overlaps the first one
        expect { TimeSlot.create!(doctor_id: @doc_id, starts_at: "10:15", ends_at: "10:45") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not allow times before 9am or after 5pm' do
        # attempting to create timeslot at 4am
        expect { TimeSlot.create!(doctor_id: @doc_id, starts_at: "4:00", ends_at: "4:30") }.to raise_error(ActiveRecord::RecordInvalid)
        # attempting to create timeslot at 8pm
        expect { TimeSlot.create!(doctor_id: @doc_id, starts_at: "20:00", ends_at: "20:30") }.to raise_error(ActiveRecord::RecordInvalid)
    end
end