# frozen_string_literal: true

# ----- Background data for clinics, employments, and time slots -----

Given('a clinic called {string} exists') do |name|
  Clinic.create!(name: name)
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
  #expect(page).to have_current_path("/patient", ignore_query: true), "Expected to land on /patient after login"
end

# ----- Navigation within clinic/doctor browse flow -----

Given('I am on the find doctor page for clinic {string}') do |clinic_name|
  cln = Clinic.find_by!(name: clinic_name)
  visit "/clinic/#{cln.id}/doctors"
end

Given('I am on the schedule page for doctor {string}') do |doc_name|
  doc = Doctor.find_by!(username: doc_name)
  visit "/doctor/#{doc.id}/schedule_appt"
end

Then('I should be on the schedule page for doctor {string}') do |doctor_username|
  expect(page).to have_current_path(%r{\A/doctor/.+/schedule_appt\z}, ignore_query: true),
    "Expected schedule URI for doctor '#{doctor_username}'"
end

Then('I should stay on the schedule page for doctor {string}') do |doctor_username|
  step %(I should be on the schedule page for doctor "#{doctor_username}")
end

# ----- Slot visibility & actions -----

Then('I should see {string} – {string}') do |start_s, end_s|
  expect(page).to have_content("#{start_s} – #{end_s}")
end

Given('time slot {string} for doctor {string} is already booked') do |_slot_time, doc_name|
  otherPat = Patient.create!(username:"otherPatient",email:"other@test.com",password:Digest::MD5.hexdigest("hello"))
  doc = Doctor.find_by!(username: doc_name)
  slot = TimeSlot.find_by!(starts_at: _slot_time, doctor: doc)
  Appointment.create(patient: otherPat, time_slot: slot, date: Date.today)
end

# Click the specific "Book ..." button for a slot 
When('I press "Book {string}"') do |slot_label|
  click_button "Book #{slot_label}"
end

Then('I should be on my appointments page') do
  # Adjust if you mount it at /patient/appointments
  expect(page).to have_current_path(%r{\A/patient(/appointments)?\z}, ignore_query: true)
end

Then('an appointment should exist for patient {string} with doctor {string} at {string}') do |patient_u, doctor_u, starts_at_s|
  patient = Patient.find_by!(username: patient_u)
  doctor  = Doctor.find_by!(username: doctor_u)
  slot    = TimeSlot.find_by!(doctor: doctor, starts_at: starts_at_s)
  #t = Time.zone.parse()
  expect(Appointment.exists?(patient: patient, time_slot: slot)).to be(true)
end

