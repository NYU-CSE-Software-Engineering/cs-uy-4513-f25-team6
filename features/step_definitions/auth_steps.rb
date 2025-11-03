# frozen_string_literal: true

# ----- Background data -----

Given('the following users exist:') do |table|
  table.hashes.each do |row|
    User.create!(
      role: row.fetch("role"),
      email: row.fetch("email"),
      username: row.fetch("username"),
      password: row.fetch("password")
    )
  end
  pending "Create users in DB (use FactoryBot or ActiveRecord)"
end
