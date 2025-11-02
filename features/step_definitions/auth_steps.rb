# frozen_string_literal: true

# ----- Background data -----

Given('the following users exist:') do |table|
  # Implement with Activerecord
  # Example (when ready):
  # table.hashes.each do |row|
  #   User.create!(
  #     role: row.fetch("role"),
  #     email: row.fetch("email"),
  #     username: row.fetch("username"),
  #     password: row.fetch("password")
  #   )
  # end
  pending "Create users in DB (use FactoryBot or ActiveRecord)"
end

# ----- Assertions used by login.feature -----

Then('I should be on the patient dashboard page') do
  step 'I should be on the patient dashboard page' # uses ui_steps.rb
end

Then('I should be on the doctor dashboard page') do
  step 'I should be on the doctor dashboard page'
end

