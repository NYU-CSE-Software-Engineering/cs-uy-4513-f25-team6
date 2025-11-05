require 'digest'

# frozen_string_literal: true

# ----- Background data -----

Given('the following users exist:') do |table|
  table.hashes.each do |row|
    pass_hash = Digest::MD5.hexdigest(row.fetch("password"))
    case row.fetch('role')
    when 'patient'
      Patient.create!(email: row.fetch("email"), username: row.fetch("username"), password: pass_hash)
    when 'doctor'
      Doctor.create!(email: row.fetch("email"), username: row.fetch("username"), password: pass_hash)
    when 'admin'
      Admin.create!(email: row.fetch("email"), username: row.fetch("username"), password: pass_hash)
    else
      raise "#{type} is not a valid role."
    end
  end
  pending "Create users in DB (use FactoryBot or ActiveRecord)"
end
