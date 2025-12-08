# features/step_definitions/clinic_employment_steps.rb

Given("the following clinics exist:") do |table|
  table.hashes.each do |row|
    Clinic.create!(
      name:      row["name"],
      specialty: row["specialty"],
      location:  row["location"],
      rating:    row["rating"]
    )
  end
end

When("I visit the clinic employment page") do
  visit '/clinic_employment'
end

Then('I should see {string} in my list of employments') do |clinic_name|
  within '#employment-list' do
    expect(page).to have_content(clinic_name)
  end
end

Given('I am already employed at {string}') do |clinic_name|
  step 'I visit the clinic employment page'
  step %Q(I select "#{clinic_name}" from "Clinic")
  step %Q(I press "Sign up")
end

Given('I am logged out') do
  step 'I am on the login page'
end

When('I press {string}') do |button_text|
  click_button button_text
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end