FactoryBot.define do
  factory :bill, class: Bill do
    patient { FactoryBot.create(:patient) }
    appointment { FactoryBot.create(:appointment, patient: patient) }
    amount_cents { 12000 }
    status { "unpaid" }
    paid_at { nil }
  end
end
