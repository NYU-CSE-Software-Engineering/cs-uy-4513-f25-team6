# frozen_string_literal: true

# ----- Background data for clinics, employments, and time slots -----

Given('the following clinic exists:') do |table|
  table.hashes.each do |row|
    Clinic.create!(id: row["id"], name: row["name"])
  end
  pending "Create clinic(s) in DB"
end

Given('doctor {string} works at clinic {string}') do |_doctor_username, _clinic_name|
  # Link doctor to clinic employment.
  pending "Create Employment linking doctor to clinic"
end

Given('the following time slots exist for doctor {string}:') do |doctor_username, table|
  table.hashes.each do |row|
    TimeSlot.create!(
      doctor: Doctor.find_by!(username: doctor_username),
      starts_at: Time.zone.parse(row["starts_at"]),
      ends_at:   Time.zone.parse(row["ends_at"])
    )
  end
  pending "Seed doctor's available TimeSlot records"
end

# ----- Auth helper for booking scenarios -----

Given('I am logged in as patient {string}') do |username|
  visit "/login"
  fill_in "Email or Username", with: username
  fill_in "Password", with: "Secret12"
  click_button "Log in"
  expect(page).to have_current_path("/patient", ignore_query: true), "Expected to land on /patient after login"
end

# ----- Navigation within clinic/doctor browse flow -----

Given('I am on the find doctor page for clinic {string}') do |clinic_name|
  pending "Navigate to /clinic/{clinic_id}/find_doctor for '#{clinic_name}'"
end

Then('I should be on the schedule page for doctor {string}') do |doctor_username|
  expect(page).to have_current_path(%r{\A/doctor/.+/schedule_appt\z}, ignore_query: true),
    "Expected schedule URI for doctor '#{doctor_username}'"
end

Then('I should stay on the schedule page for doctor {string}') do |doctor_username|
  step %(I should be on the schedule page for doctor "#{doctor_username}")
end

# ----- Slot visibility & actions -----

Then('I should see "Available time slots"') do
  expect(page).to have_content("Available time slots")
end

Then('I should see {string} – {string}') do |start_s, end_s|
  expect(page).to have_content("#{start_s} – #{end_s}")
end

Given('time slot {string} for doctor {string} is already booked') do |_slot_id, _doctor_username|
  pending "Mark the TimeSlot as taken (or create an Appointment occupying it)"
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
  t = Time.zone.parse(starts_at_s)
  expect(Appointment.exists?(patient: patient.patient, doctor: doctor.doctor, starts_at: t)).to be(true)
  pending "Assert Appointment persisted for #{patient_u} with #{doctor_u} at #{starts_at_s}"
end

