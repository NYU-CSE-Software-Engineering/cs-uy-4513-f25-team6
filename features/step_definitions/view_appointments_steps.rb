Given("I have the following appointments as a patient") do |table|
  table.hashes.each do |row|
    doc_obj = Doctor.find_by(username: row.fetch('doctor'))
    if doc_obj == nil
      doc_obj = FactoryBot.create(:doctor, username: row.fetch('doctor'))
    end
    slot_obj = TimeSlot.find_by(starts_at: row.fetch('time'), doctor: doc_obj)
    if slot_obj == nil
      slot_obj = FactoryBot.create(:time_slot, starts_at: row.fetch('time'), doctor: doc_obj)
    end
    Appointment.create!(
      patient: @test_user,
      time_slot: slot_obj,
      date: row.fetch('date')
    )
  end
end

Then(/I should see all my( upcoming)? appointments/) do |upcoming|
  apps = @test_user.appointments
  if upcoming
    apps = apps.joins(:time_slot).where('time_slots.starts_at < ?', DateTime.now)
  end
  apps = apps.includes(:doctor, :time_slot)
  apps.each do |app|
    expect(page).to have_content(app.date.to_s)
    expect(page).to have_content(app.time_slot.starts_at.strftime('%I:%M %p'))
    expect(page).to have_content(app.time_slot.ends_at.strftime('%I:%M %p'))
    expect(page).to have_content(app.doctor.username)
  end
end

Then ('I should not see any appointments') do
  expect(page).not_to have_selector(".appointment-row")
end

# Then("I should see a list of my upcoming appointments") do
#   expect(page).to have_content("Upcoming Appointments")
#   expect(page).to have_selector(".appointment-row")
# end

# When("I select {string} from the status dropdown") do |status|
#   select status, from: "Status"
#   click_button "Filter"
# end

# Then("I should see only completed appointments") do
#   expect(page).to have_content("Completed")
#   expect(page).not_to have_content("Upcoming")
# end

# Then("each appointment should display the patient's name, date, and clinic") do
#   within(".appointment-row") do
#     expect(page).to have_content("Patient")
#     expect(page).to have_content("Date")
#     expect(page).to have_content("Clinic")
#   end
# end