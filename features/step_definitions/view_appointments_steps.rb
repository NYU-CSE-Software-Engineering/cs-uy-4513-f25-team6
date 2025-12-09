Given("I have the following appointments") do |table|
  doctor = @test_user 

  table.hashes.each do |row|
    # 1. Setup Patient
    patient = Patient.find_by(id: row["patient_id"]) 
    patient ||= Patient.create!(
      id: row["patient_id"], 
      email: "patient#{row['patient_id']}@example.com", 
      username: "patient_#{row['patient_id']}", 
      password: "a" * 32 
    )

    # 2. Setup Clinic 
    if row["clinic_name"].present?
      clinic = Clinic.find_or_create_by!(name: row["clinic_name"])
      doctor.update!(clinic: clinic)
    end

    # 3. Setup TimeSlot (Normalized to 2000-01-01)
    full_start_time = Time.zone.parse(row["appointment_time"])
    slot_start = Time.utc(2000, 1, 1, full_start_time.hour, full_start_time.min)
    slot_end = slot_start + 30.minutes

    slot = TimeSlot.find_or_create_by!(
      doctor: doctor,
      starts_at: slot_start
    ) do |s|
      s.ends_at = slot_end
    end

    # 4. Create Appointment
    Appointment.create!(
      patient: patient,
      time_slot: slot,
      date: full_start_time.to_date,
      status: row["status"]
    )
  end
end

Then("I should see a list of my upcoming appointments") do
  expect(page).to have_content("Upcoming Appointments")
  expect(page).to have_selector(".appointment-row")
end

When("I select {string} from the status dropdown") do |status|
  select status, from: "Status"
  click_button "Filter"
end

Then("I should see only completed appointments") do
  expect(page).to have_content("Completed")
  expect(page).not_to have_content("2025-11-11")
end

Then("each appointment should display the patient's name, date, and clinic") do
  all(".appointment-row").each do |row|
    within(row) do
      expect(page).to have_content("Patient")
      expect(page).to have_content("Date")
      expect(page).to have_content("Clinic")
    end
  end
end