Given("I have the following appointments as a patient") do |table|
  table.hashes.each do |row|
    doc_obj = Doctor.find_by(username: row.fetch('doctor'))
    if doc_obj == nil
      doc_obj = FactoryBot.create(:doctor, username: row.fetch('doctor'))
    end
    
    if row["clinic_name"].present?
      clinic = Clinic.find_or_create_by(name: row["clinic_name"])
      doc_obj.update(clinic: clinic)
    end

    slot_obj = TimeSlot.find_by(starts_at: row.fetch('time'), doctor: doc_obj)
    if slot_obj == nil
      slot_obj = FactoryBot.create(:time_slot, starts_at: row.fetch('time'), doctor: doc_obj)
    end
    
    Appointment.create!(
      time_slot: slot_obj,
      patient_id: @test_user.id, 
      date: row["date"] || row["appointment_time"], 
      status: row["status"]
    )
  end
end

Given("I have the following appointments as a doctor") do |table|
  raise "No doctor signed in" unless @test_user.is_a?(Doctor)

  table.hashes.each do |row|
    # Handle Patient (Find or Create)
    patient = Patient.find_by(id: row['patient_id'])
    if patient.nil?
      # Create a placeholder patient if one doesn't exist
      patient = Patient.create!(
        id: row['patient_id'],
        username: "Patient_#{row['patient_id']}",
        email: "patient#{row['patient_id']}@example.com",
        password: "a" * 32
      )
    end

    # We must split the "appointment_time" string into a Date and a TimeSlot
    full_time = DateTime.parse(row['appointment_time'])
    date_part = full_time.to_date
    start_time = full_time.strftime("%H:%M:%S")
    end_time   = (full_time + 1.hour).strftime("%H:%M:%S")

    # Find or Create the TimeSlot for this doctor
    time_slot = TimeSlot.find_or_create_by(doctor: @test_user, starts_at: start_time) do |ts|
      ts.ends_at = end_time
    end

    # Create Appointment
    Appointment.create!(
      patient: patient,
      time_slot: time_slot,
      date: date_part,
      status: row['status']
    )
  end
end

Then(/I should see all my( upcoming)? appointments/) do |upcoming|
  apps = @test_user.appointments
  if upcoming
    apps = apps.where('date > ?', Date.yesterday)
  end
  apps = apps.includes(:doctor, :time_slot, :patient) 

  apps.each do |app|
    expect(page).to have_content(app.date.to_s)
    expect(page).to have_content(app.time_slot.starts_at.strftime('%I:%M %p'))
    expect(page).to have_content(app.time_slot.ends_at.strftime('%I:%M %p'))
    
    if @test_user.is_a?(Doctor)
       expect(page).to have_content(app.patient.username)
    else
       expect(page).to have_content(app.doctor.username)
    end
  end
end

Then ('I should not see any appointments') do
  expect(page).not_to have_selector(".appointment-row")
end

Then("I should see only completed appointments") do
  expect(page).to have_content("Completed Appointments")
  expect(page).not_to have_content("Upcoming Appointments")
end

Then("each appointment should display the patient's name and the date") do
  all(".appointment-row").each do |row|
    within row do
      expect(page).to have_content("Patient")
      expect(page).to have_content("Date")
    end
  end
end