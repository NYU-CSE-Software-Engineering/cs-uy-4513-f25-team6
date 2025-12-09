Given("the following clinics exist:") do |table|
  table.hashes.each do |row|
    Clinic.create!(
      name:      row["name"],
      specialty: row["specialty"],
      location:  row["location"],
      rating:    row["rating"]
    )
  end
end

Given('I am already employed at {string}') do |clinic_name|
  clinic = Clinic.find_by!(name: clinic_name)

  doctor =
    if defined?(@test_user) && @test_user.is_a?(Doctor)
      @test_user
    else
      Doctor.find_by!(email: "drsmith@example.com")
    end

  doctor.update!(clinic: clinic)
end

Given('I am logged out') do
  visit logout_path
end

When('I click {string} for {string}') do |button_text, clinic_name|
  row = find('tr', text: clinic_name)
  within(row) do
    click_button button_text
  end
end

When('I visit the find clinics page') do
  visit clinics_path
end
