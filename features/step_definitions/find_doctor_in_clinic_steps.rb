Given("a clinic exists with the following doctors") do |table|
  @clinic = FactoryBot.create(:clinic)
  table.hashes.each do |row|
    FactoryBot.create(:doctor, clinic: @clinic, username: row[:name], 
                      specialty: row[:specialty], rating: row[:rating])
  end
end

# If you don’t already have a generic “I am on ... page” step
Given(/^I am on the "Find a Doctor" page for that clinic$/) do
    visit clinic_doctors_path(@clinic)  # change to your route
end

Then("I should see all the doctors at that clinic") do
  Doctor.where(clinic: @clinic).each do |doctor|
    expect(page).to have_content(doctor.username)
    expect(page).to have_content(doctor.specialty)
    expect(page).to have_content(doctor.rating.to_s)
  end
end
  
Then(/^I should see a doctor named "(.*)" specializing in "(.*)"$/) do |name, specialty|
    container = '#results'   # change selectors to your DOM
    item_sel  = '.doctor'
    expect(page).to have_css(container)
    found = within(container) do
      all(item_sel).any? { |row| row.has_text?(name) && row.has_text?(specialty) }
    end
    expect(found).to be true
end

Then(/^I should see a list of doctors within this clinic sorted by their ratings$/) do
    ratings =
    if page.has_css?('table#doctors tbody tr')
      all('table#doctors tbody tr').map do |tr|
        txt = (tr.first('td.rating') || tr.all('td').last).text
        txt[/\d+(\.\d+)?/].to_f
      end
    else
      all('#results .doctor .rating').map { |el| el.text[/\d+(\.\d+)?/].to_f }
    end
  expect(ratings.each_cons(2).all? { |a,b| a >= b }).to be true
end

When(/^I fill in "(.*)" with a nonexistent name$/) do |field_label|
    @nonexistent_name = "NO_SUCH_DOCTOR_#{SecureRandom.hex(4)}"
    fill_in field_label, with: @nonexistent_name
end

Then(/^I should see an error message indicating doctor not found$/) do
    expect(page).to have_selector('.alert, .error, #flash_alert',
    text: /doctor\s*not\s*found|no doctors/i)
end
