require 'rails_helper'
require 'spec_helper'

describe TimeSlot do
    it 'can be created when properly formed' do
        expect { TimeSlot.create!(doctor: "fakeDoc", starts_at: Time.new(2025,1,1,10), ends_at: Time.new(2025,1,1,10,30)) }.not_to raise_error
    end

    it 'does not allow start time later than end time' do
        # start time 10:30am, end time 10:00am
        expect { TimeSlot.create!(doctor: "fakeDoc", starts_at: Time.new(2025,1,1,10,30), ends_at: Time.new(2025,1,1,10)) }.to raise_error
    end
    
    it 'does not allow overlapping slots on same doctor' do
        # 10:00am to 10:30am, this one should work
        slot1 = TimeSlot.create!(doctor: "fakeDoc", starts_at: Time.new(2025,1,1,10), ends_at: Time.new(2025,1,1,10,30))
        # 10:15am to 10:45am, this one should fail since it overlaps the first one
        expect { TimeSlot.new(doctor: "fakeDoc", starts_at: Time.new(2025,1,1,10,15), ends_at: Time.new(2025,1,1,10,45)) }.to raise_error
    end

    it 'does not allow times before 9am or after 5pm' do
        # attempting to create timeslot at 4am
        expect { TimeSlot.create!(doctor: "fakeDoc", starts_at: Time.new(2025,1,1,4), ends_at: Time.new(2025,1,1,4,30)) }.to raise_error
        # attempting to create timeslot at 8pm
        expect { TimeSlot.create!(doctor: "fakeDoc", starts_at: Time.new(2025,1,1,20), ends_at: Time.new(2025,1,1,20,30)) }.to raise_error
    end
end