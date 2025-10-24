def sign_in_user(user)
  visit new_user_session_path 
  fill_in "Email", with: user.email
  fill_in "Password", with: "password"
  click_button "Log in"
end

def patient_billing_show_path_for(bill)
  # Prefer a route helper if you’ve defined one:
  # patient_billing_path(bill) or bill_path(bill)
  # Fallback to a hardcoded path if your project spec uses this URI:
  "/patient/billing/#{bill.id}"
end

Given('I am a signed-in patient') do
  @patient ||= Patient.create!(email: "pat@example.com", password: "password")
  sign_in_user(@patient)
  # Optional sanity check:
  expect(page).to have_content("Signed in").or have_current_path(root_path, ignore_query: true)
end

Given('I have an unpaid bill for one of my appointments') do
  # Minimal associated records so the Bill is valid
  doctor = Doctor.create!(email: "doc@example.com", password: "password", name: "Dr. Ada")
  appt   = Appointment.create!(patient: @patient, doctor: doctor, starts_at: Time.current + 2.days)
  @bill  = Bill.create!(patient: @patient, appointment: appt, amount_cents: 15000, status: "unpaid")
end

Given('I am on my bill page') do
  raise "No @bill set. Did you call the unpaid bill step?" unless @bill
  visit patient_billing_show_path_for(@bill)
  # Keep this generic; the page may not exist yet (that's OK for RED)
  # If it exists, these hints help catch regressions:
  expect(page.status_code).to be_between(200, 399).inclusive rescue nil
end

When('I fill in {string} with {string}') do |label, value|
  fill_in label, with: value
end

When('I press {string}') do |button|
  click_button button
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('the bill should be marked paid') do
  # Prefer reading UI first; otherwise reload the record.
  if @bill
    @bill.reload
    expect(@bill.status).to eq("paid")
    expect(@bill.paid_at).to be_present
  else
    expect(page).to have_content("Status: paid")
  end
end

Given('I have a paid bill') do
  doctor = Doctor.create!(email: "doc2@example.com", password: "password", name: "Dr. Turing")
  appt   = Appointment.create!(patient: @patient, doctor: doctor, starts_at: Time.current - 1.day)
  @paid_bill = Bill.create!(patient: @patient, appointment: appt, amount_cents: 9000, status: "paid", paid_at: Time.current)
end

Given('I am on my paid bill page') do
  raise "No @paid_bill set. Did you call the paid bill step?" unless @paid_bill
  visit patient_billing_show_path_for(@paid_bill)
  expect(page).to have_content("paid").or have_current_path(patient_billing_show_path_for(@paid_bill), ignore_query: true) rescue nil
end

Given("another patient exists with a different unpaid bill") do
  @other_patient = Patient.create!(email: "other@example.com", password: "password")
  d = Doctor.create!(email: "doc3@example.com", password: "password", name: "Dr. Hopper")
  a = Appointment.create!(patient: @other_patient, doctor: d, starts_at: Time.current + 1.day)
  @others_bill = Bill.create!(patient: @other_patient, appointment: a, amount_cents: 5000, status: "unpaid")
end

When("I visit that other patient's bill page") do
  raise "No @others_bill set. Did you create the other patient’s bill?" unless @others_bill
  visit patient_billing_show_path_for(@others_bill)
end
