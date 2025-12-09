# features/step_definitions/prescription_steps.rb
require "cgi"
require "date"

# ============================================
# DATA SETUP STEPS
# ============================================

# Create prescriptions for the currently logged-in patient (used in patient feature)
Given("the following prescriptions exist for me:") do |table|
  table.hashes.each do |row|
    # Create or find doctor by a derived username from doctor_name
    doctor_username = (row["doctor_name"] || "doctor").parameterize.underscore
    doctor = Doctor.find_or_create_by!(email: "#{doctor_username}@example.com") do |d|
      d.username = doctor_username
      d.password = Digest::MD5.hexdigest('testPassword')
    end

    Prescription.create!(
      patient_id: @test_user.id,
      doctor_id: doctor.id,
      medication_name: row["medication_name"],
      dosage: row["dosage"],
      instructions: row["instructions"],
      issued_on: Date.parse(row["issued_on"]),
      status: row["status"]
    )
  end
end

Given("I have no prescriptions") do
  Prescription.where(patient_id: @test_user.id).delete_all
end

Given("another patient exists with a prescription {string}") do |med_name|
  @other_patient = Patient.create!(
    email: "other@example.com",
    username: "otherpatient",
    password: Digest::MD5.hexdigest('testPassword')
  )
  doctor = Doctor.find_or_create_by!(email: "doc2@example.com") do |d|
    d.username = "otherdoctor"
    d.password = Digest::MD5.hexdigest('testPassword')
  end
  @other_rx = Prescription.create!(
    patient_id: @other_patient.id,
    doctor_id: doctor.id,
    medication_name: med_name,
    dosage: "10 mg",
    instructions: "Once daily",
    issued_on: Date.today,
    status: "active"
  )
end

# Create patients for doctor prescription tests
Given("the following patients exist:") do |table|
  table.hashes.each do |row|
    Patient.find_or_create_by!(email: row["email"]) do |p|
      p.username = row["username"]
      p.password = Digest::MD5.hexdigest('testPassword')
    end
  end
end

# Create prescriptions for a specific patient (used in doctor feature)
Given("the following prescriptions exist for patient {string}:") do |patient_username, table|
  patient = Patient.find_by!(username: patient_username)
  
  table.hashes.each do |row|
    Prescription.create!(
      patient_id: patient.id,
      doctor_id: @test_user.id,  # The logged-in doctor
      medication_name: row["medication_name"],
      dosage: row["dosage"],
      instructions: row["instructions"],
      issued_on: Date.parse(row["issued_on"]),
      status: row["status"]
    )
  end
end

# ============================================
# NAVIGATION STEPS
# ============================================

When("I visit the prescriptions page with status {string}") do |status|
  visit "/patient/prescriptions?status=#{CGI.escape(status)}"
end

Given("I am on the doctor prescriptions page") do
  visit "/doctor/prescriptions"
end

When("I try to visit the doctor prescriptions page") do
  visit "/doctor/prescriptions"
end

# ============================================
# INTERACTION STEPS
# ============================================

When("I choose {string} in the status filter") do |status|
  select status, from: "Status"
end

When("I apply the filter") do
  click_button "Apply"
end

When("I select {string} from the patient dropdown") do |patient_username|
  # Find patient and select by their display text (username + email)
  patient = Patient.find_by(username: patient_username)
  if patient
    select "#{patient.username} (#{patient.email})", from: "patient_id"
  else
    select patient_username, from: "patient_id"
  end
end

Given("I log out") do
  visit "/logout"
end

# ============================================
# ASSERTION STEPS
# ============================================

Then("I should see a prescriptions list") do
  expect(page).to have_content("Prescriptions")
  expect(page).to have_css(".prescription-item, table tr, li", minimum: 1)
end
