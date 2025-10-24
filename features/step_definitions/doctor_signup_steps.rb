# frozen_string_literal: true

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

Then('I should see {string}') do |message|
  expect(page).to have_content(message)
end


