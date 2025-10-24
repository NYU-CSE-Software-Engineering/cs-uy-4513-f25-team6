Given("I am signed in as a doctor") do
  @doctor = Doctor.create!(email: "doc@example.com", password: "password")
  visit new_doctor_session_path
  fill_in "Email", with: @doctor.email
  fill_in "Password", with: @doctor.password
  click_button "Log in"
end

When("I visit the appointments page") do
  visit doctor_appointments_path(@doctor)
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

Given("I am signed in as a doctor with no scheduled appointments") do
  @doctor = Doctor.create!(email: "emptydoc@example.com", password: "password")
  visit new_doctor_session_path
  fill_in "Email", with: @doctor.email
  fill_in "Password", with: @doctor.password
  click_button "Log in"
end

When("I attempt to access another doctor's appointments page") do
  other_doctor = Doctor.create!(email: "otherdoc@example.com", password: "password")
  visit doctor_appointments_path(other_doctor)
end