# frozen_string_literal: true

# ----- Background data -----

Given('the following users exist:') do |table|
  table.hashes.each do |row|
    case row.fetch('role')
    when 'patient'
      Patient.create!(email: row.fetch("email"), username: row.fetch("username"), password: row.fetch("password"))
    when 'doctor'
      Doctor.create!(email: row.fetch("email"), username: row.fetch("username"), password: row.fetch("password"))
    when 'admin'
      Admin.create!(email: row.fetch("email"), username: row.fetch("username"), password: row.fetch("password"))
    else
      raise "#{type} is not a valid role."
    end
  end
  pending "Create users in DB (use FactoryBot or ActiveRecord)"
end
