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

When("I visit the appointments page") do
  visit doctor_appointments_path(@test_user)
end

Then("I should see a list of my upcoming appointments") do
  expect(page).to have_content("Upcoming Appointments")
  expect(page).to have_selector(".appointment-row")
end

Then("I should see the message {string}") do |message|
  expect(page).to have_content(message)
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

Given("I am on the appointments page") do
  step "I am signed in as a doctor"
  step "I visit the appointments page"
end

When("I attempt to access another doctor's appointments page") do
  other_doctor = Doctor.create!(email: "otherdoc@example.com", password: "password")
  visit doctor_appointments_path(other_doctor)
end