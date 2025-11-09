FactoryBot.define do
    factory :appointment, class: Appointment do
        patient { FactoryBot.create(:patient) }
        time_slot { FactoryBot.create(:time_slot) }
        date { "2025-4-13" }
    end
end