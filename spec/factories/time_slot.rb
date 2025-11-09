FactoryBot.define do
    sequence :start_time do |n|
        hour = (n/60)%8 + 9
        min = n%60
        "%d:%02d" % [hour,min]
    end
    
    factory :time_slot, class: TimeSlot do
        doctor { FactoryBot.create(:doctor) }
        starts_at { generate :start_time }
        ends_at { Time.parse(starts_at + " UTC") + 1.minutes }
    end
end