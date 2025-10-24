# frozen_string_literal: true

Given("I am on the doctor sign up page") do
  # If Devise:
  if Rails.application.routes.url_helpers.respond_to?(:new_doctor_registration_path)
    visit Rails.application.routes.url_helpers.new_doctor_registration_path
  else
    # If custom:
    # visit new_doctor_path
    visit "/doctors/sign_up"
  end
  expect(page).to have_content("Sign up as Doctor").or have_selector("form")
end

Given("a doctor exists with email {string}") do |email|
  # If Devise or custom model exists:
  if defined?(Doctor)
    Doctor.create!(
      email: email,
      password: "VeryStrongPass9",
      name: "Existing Doctor",
      specialty: "Cardiology",
      license_number: "NY-000001"
    )
  end
end

When("I fill in {string} with {string}") do |label, value|
  fill_in label, with: value
end

When("I select {string} from {string}") do |option, select_box_label|
  select option, from: select_box_label
end

When("I press {string}") do |button_text|
  click_button button_text
end

Then('I should see "Welcome, Dr. Ada Lovelace" or "A message with a confirmation link has been sent to your email address"') do
  expect(page).to have_text("Welcome, Dr. Ada Lovelace").or(
    have_text("A message with a confirmation link has been sent to your email address")
  )
end

Then("I should be on the doctor dashboard") do
  # Prefer to assert on path if available
  if Rails.application.routes.url_helpers.respond_to?(:doctor_dashboard_path)
    expect(page).to have_current_path(
      Rails.application.routes.url_helpers.doctor_dashboard_path,
      ignore_query: true
    )
  else
    # Fallback: look for a dashboard marker string
    expect(page).to have_content("Doctor Dashboard").or have_content("Patients")
  end
end

Then('I should see {string}') do |message|
  expect(page).to have_content(message)
end


