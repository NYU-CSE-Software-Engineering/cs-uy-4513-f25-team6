Given('one of my patients has a bill') do
  slot = FactoryBot.create(:time_slot, doctor: @test_user)
  app = FactoryBot.create(:appointment, time_slot: slot)
  @bill = FactoryBot.create(:bill, appointment: app)
end

When('I visit the page for the bill') do
  raise "No @bill set. Make sure to call a step that sets it first." unless @bill
  visit bill_path(@bill)
end

Given('a bill exists') do
  slot = FactoryBot.create(:time_slot)
  app = FactoryBot.create(:appointment, time_slot: slot)
  @bill = FactoryBot.create(:bill, appointment: app)
end