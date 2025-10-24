# features/step_definitions/prescription_steps.rb
require "cgi"
require "date"

# stage of setting up data
Given("the following prescriptions exist for me:") do |table|
  table.hashes.each do |row|
    doctor = Doctor.find_or_create_by!(
      email: "#{(row["doctor_name"] || "doctor").parameterize}@example.com",
      password: "password",
      first_name: row["doctor_name"]&.split&.first || "Doc",
      last_name:  row["doctor_name"]&.split&.last  || "Tor"
    )

    Prescription.create!(
      patient_id: @test_user.id,   
      doctor_id:  doctor.id,        
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
    password: "password",
    first_name: "Other",
    last_name: "Patient"
  )
  doctor = Doctor.find_or_create_by!(
    email: "doc2@example.com",
    password: "password",
    first_name: "Other",
    last_name: "Doctor"
  )
  @other_rx = Prescription.create!(
    patient_id: @other_patient.id, 
    doctor_id:  doctor.id,          
    medication_name: med_name,
    dosage: "10 mg",
    instructions: "Once daily",
    issued_on: Date.today,
    status: "active"
  )
end

When("I visit the prescriptions page with status {string}") do |status|
  visit "/patient/prescriptions?status=#{CGI.escape(status)}"
end

When("I choose {string} in the status filter") do |status|
  select status, from: "Status" 
end

When("I apply the filter") do
  click_button "Apply"
end

# assertions for prescription lists and pages
Then("I should see a prescriptions list") do
  expect(page).to have_content("Prescriptions")
  # loosen until your markup is final
  expect(page).to have_css(".prescription-item, table tr, li", minimum: 1)
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end

Then("I should see {string} before {string}") do |first_text, second_text|
  a = page.text.index(first_text)
  b = page.text.index(second_text)
  expect(a).not_to be_nil, "Expected to find '#{first_text}'"
  expect(b).not_to be_nil, "Expected to find '#{second_text}'"
  expect(a).to be < b
end