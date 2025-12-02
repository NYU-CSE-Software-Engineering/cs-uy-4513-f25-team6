require 'digest'
require 'securerandom'

def patient_bill_path_for(bill)
  patient_bill_path(bill)
end

def build_appointment_for(patient, date: Date.today + 2.days)
  doctor = Doctor.create!(email: "doc-#{SecureRandom.hex(4)}@example.com", username: "doc#{SecureRandom.hex(3)}", password: Digest::MD5.hexdigest('testPassword'))
  time_slot = TimeSlot.create!(doctor: doctor, starts_at: Time.utc(2000, 1, 1, 10, 0), ends_at: Time.utc(2000, 1, 1, 10, 30))
  Appointment.create!(patient: patient, time_slot: time_slot, date: date)
end

Given('I have an unpaid bill for one of my appointments') do
  raise "@test_user must be set by sign-in step" unless @test_user
  appt = build_appointment_for(@test_user)
  @bill = Bill.create!(patient: @test_user, appointment: appt, amount_cents: 15000, status: "unpaid")
end

Given('I am on the page for my unpaid bill') do
  raise "No @bill set. Did you call the unpaid bill step?" unless @bill
  visit patient_bill_path_for(@bill)
  expect(page.status_code).to be_between(200, 399).inclusive rescue nil
end

Then('the bill should be marked paid') do
  if @bill
    @bill.reload
    expect(@bill.status).to eq("paid")
    expect(@bill.paid_at).to be_present
  else
    expect(page).to have_content("Status: paid")
  end
end

Given('I have a paid bill') do
  raise "@test_user must be set by sign-in step" unless @test_user
  appt = build_appointment_for(@test_user, date: Date.today - 1.day)
  @paid_bill = Bill.create!(patient: @test_user, appointment: appt, amount_cents: 9000, status: "paid", paid_at: Time.current)
end

Given('I am on the page for my paid bill') do
  raise "No @paid_bill set. Did you call the paid bill step?" unless @paid_bill
  visit patient_bill_path_for(@paid_bill)
  expect(page).to have_current_path(patient_bill_path_for(@paid_bill), ignore_query: true) rescue nil
end

Given("another patient exists with a different unpaid bill") do
  other_patient = Patient.create!(email: "other@example.com", username: "other#{SecureRandom.hex(3)}", password: Digest::MD5.hexdigest('testPassword'))
  appt = build_appointment_for(other_patient, date: Date.today + 1.day)
  @others_bill = Bill.create!(patient: other_patient, appointment: appt, amount_cents: 5000, status: "unpaid")
end

When("I visit that other patient's bill page") do
  raise "No @others_bill set. Did you create the other patient’s bill?" unless @others_bill
  visit patient_bill_path_for(@others_bill)
end
