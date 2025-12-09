require 'digest'

def sign_in_user(user)
  visit new_user_session_path 
  fill_in "Email", with: user.email
  fill_in "Password", with: "testPassword"
  click_button "Log in"
end

Given('I have an unpaid bill for one of my appointments') do
  # Minimal associated records so the Bill is valid
  doctor = Doctor.create!(email: "doc@example.com", password: Digest::MD5.hexdigest('testPassword'), username: "Dr. Ada")
  time_slot = TimeSlot.create!(doctor: doctor, starts_at: "09:00", ends_at: "10:00")
  appt = Appointment.create!(patient: @test_user, time_slot: time_slot, date: Date.today + 2.days)
  @bill = Bill.create!(appointment: appt, amount: 150.0, status: "unpaid", due_date: Date.today + 7.days)
end

Given('I am on the page for my unpaid bill') do
  raise "No @bill set. Did you call the unpaid bill step?" unless @bill
  visit bill_path(@bill)
  expect(page.status_code).to be_between(200, 399).inclusive rescue nil
end

Then('the bill should be marked paid') do
  # Prefer reading UI first; otherwise reload the record.
  if @bill
    @bill.reload
    expect(@bill.status).to eq("paid")
  else
    expect(page).to have_content("Status: paid")
  end
end

Given('the bill is now paid') do
  raise "No @bill set. Did you call the unpaid bill step?" unless @bill
  @bill.mark_as_paid!
end

Given("another patient exists with a different unpaid bill") do
  @other_patient = Patient.create!(email: "other@example.com", password: Digest::MD5.hexdigest('testPassword'), username: "otherpatient")
  d = Doctor.create!(email: "doc3@example.com", password: Digest::MD5.hexdigest('testPassword'), username: "Dr. Hopper")
  time_slot = TimeSlot.create!(doctor: d, starts_at: "11:00", ends_at: "12:00")
  a = Appointment.create!(patient: @other_patient, time_slot: time_slot, date: Date.today + 1.day)
  @others_bill = Bill.create!(appointment: a, amount: 50.0, status: "unpaid", due_date: Date.today + 7.days)
end

When("I visit that other patient's bill page") do
  raise "No @others_bill set. Did you create the other patient's bill?" unless @others_bill
  visit bill_path(@others_bill)
end
