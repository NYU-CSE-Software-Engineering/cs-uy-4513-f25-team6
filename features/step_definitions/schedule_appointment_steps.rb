# frozen_string_literal: true

# ----- Background data for clinics, employments, and time slots -----

Given('a clinic called {string} exists') do |name|
  FactoryBot.create(:clinic, name: name)
end

Given('doctor {string} works at clinic {string}') do |_doctor_username, _clinic_name|
  doc = Doctor.find_by!(username: _doctor_username)
  cln = Clinic.find_by!(name: _clinic_name)
  cln.doctors<<(doc)
end

Given('the following time slots exist for doctor {string}:') do |doctor_username, table|
  table.hashes.each do |row|
    TimeSlot.create!(
      doctor: Doctor.find_by!(username: doctor_username),
      starts_at: row["starts_at"],
      ends_at: row["ends_at"]
    )
  end
end

# ----- Auth helper for booking scenarios -----

Given('I am logged in as patient {string}') do |username|
  visit "/login"
  patient = Patient.find_by!(username: username)
  fill_in "Email:", with: patient.email
  fill_in "Password", with: "Secret12"
  choose "Patient"
  click_button "Log In"
end

# ----- Navigation within clinic/doctor browse flow -----

Given('I am on the find doctor page for clinic {string}') do |clinic_name|
  cln = Clinic.find_by!(name: clinic_name)
  visit "/clinics/#{cln.id}/doctors"
end

Given('I am on the time slots page for doctor {string}') do |doc_name|
  doc = Doctor.find_by!(username: doc_name)
  visit doctor_time_slots_path(doc.id)
end

Then('I should be on the time slots page for doctor {string}') do |doctor_username|
  expect(page).to have_current_path(%r{\A/doctors/.+/time_slots\z}, ignore_query: true),
    "Expected schedule URI for doctor '#{doctor_username}'"
end

Then('I should stay on the time slots page for doctor {string}') do |doctor_username|
  step %(I should be on the time slots page for doctor "#{doctor_username}")
end

# ----- Slot visibility & actions -----

Then('I should see {string} – {string}') do |start_s, end_s|
  expect(page).to have_content("#{start_s} – #{end_s}")
end

Given('the slot starting at {string} on {string} for doctor {string} is already booked') do |slot_time, date, doc_name|
  otherPat = FactoryBot.create(:patient)
  doc = Doctor.find_by!(username: doc_name)
  slot = TimeSlot.find_by!(starts_at: slot_time, doctor: doc)
  Appointment.create(patient: otherPat, time_slot: slot, date: date)
end

# Click the "Book this slot" button for a specific slot
When('I book the slot starting at {string}') do |start_time|
  page.find('td', text: start_time).find('+td button').click
end

When('I choose the date {string}') do |date|
  fill_in 'schedule_date', with: date
  click_button 'Refresh'
end

Then('I should be on my appointments page') do
  # Adjust if you mount it at /patient/appointments
  expect(page).to have_current_path(%r{\A/patient(/appointments)?\z}, ignore_query: true)
end

Then(/an appointment should( not)? exist for patient "(.*)" with doctor "(.*)" at "(.*)" on "(.*)"/) do |inverse, patient_u, doctor_u, starts_at, date|
  patient = Patient.find_by!(username: patient_u)
  doctor  = Doctor.find_by!(username: doctor_u)
  slot    = TimeSlot.find_by!(doctor: doctor, starts_at: starts_at)
  expect(Appointment.exists?(patient: patient, time_slot: slot, date: date)).to be(!inverse)
end

