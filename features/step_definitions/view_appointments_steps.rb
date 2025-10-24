Given("I have the following appointments") do |table|
  table.hashes.each do |row|
    Appointment.create!(
      doctor_id: @test_user.id,
      patient_id: row["patient_id"],
      appointment_time: row["appointment_time"],
      status: row["status"],
      clinic_name: row["clinic_name"]
    )
  end
end

Then("I should see a list of my upcoming appointments") do
  expect(page).to have_content("Upcoming Appointments")
  expect(page).to have_selector(".appointment-row")
end

When("I select {string} from the status dropdown") do |status|
  select status, from: "Status"
  click_button "Filter"
end

Then("I should see only completed appointments") do
  expect(page).to have_content("Completed")
  expect(page).not_to have_content("Upcoming")
end

Then("each appointment should display the patient's name, date, and clinic") do
  within(".appointment-row") do
    expect(page).to have_content("Patient")
    expect(page).to have_content("Date")
    expect(page).to have_content("Clinic")
  end
end