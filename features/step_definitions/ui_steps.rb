# frozen_string_literal: true

# ---------- Generic navigation & interaction ----------

Given("I am on the login page") do
  visit "/login"
end

When('I fill in {string} with {string}') do |label, value|
  fill_in label, with: value
end

When('I press {string}') do |button_text|
  click_button button_text
end

When('I follow {string}') do |link_text|
  click_link link_text
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should be on the login page') do
  expect(page).to have_current_path("/login", ignore_query: true)
end

# ---------- Dashboard path assertions ----------

def dashboard_path_for(role)
  case role
  when "patient" then "/patient"
  when "doctor"  then "/doctor"
  when "admin"   then "/admin"
  else raise "Unknown role: #{role}"
  end
end

Then('I should be on the {word} dashboard page') do |role|
  expect(page).to have_current_path(dashboard_path_for(role), ignore_query: true)
end

