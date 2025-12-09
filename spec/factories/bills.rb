FactoryBot.define do
  factory :bill do
    association :appointment
    amount { 150.0 }
    status { "unpaid" }
    due_date { Date.today + 7.days }
  end
end

