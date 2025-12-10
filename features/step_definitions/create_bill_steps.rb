Given('an appointment exists on {string}') do |date|
  slot = FactoryBot.create(:time_slot, doctor: @test_user)
  @app = FactoryBot.create(:appointment, time_slot: slot, date: date)
end

Then('a bill of {string} due on {string} should exist') do |amount, date|
  bill = Bill.find_by(amount: amount, due_date: date)
  expect(bill).to be_truthy
end
