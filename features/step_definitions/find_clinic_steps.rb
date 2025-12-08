Given('the following clinics exist') do |table|
  table.hashes.each do |row|
    Clinic.create!(row)
  end
end

Given(/I have searched for a clinic in "(.*)"/) do |location|
  visit '/clinics'
  select location, from: 'Location'
  click_on 'Search'
end

# generic location and specialty "should see" step definition
Then(/I should see a list of clinics located in "(.*)" specializing in "(.*)"/) do |location, specialty|
  Clinic.where(location: location, specialty: specialty).each do |clinic|
    expect(page).to have_content(clinic.name)
    expect(page).to have_content(clinic.rating.to_s)
  end
end

Then(/^I should see a list of clinics sorted by their ratings$/) do
  all_ratings = all('.rating') # Extract all rating values from the page
  ratings = all_ratings.map{ |each_rating| each_rating.text.to_f} # Convert the rating text to float values (e.g. "4.5" becomes 4.5)
  expect(ratings).to eq(ratings.sort.reverse) # check that the ratings are sorted in descending order (highest rating at the top)
end

Then(/^I should see an error message indicating missing search fields$/) do
  expect(page).to have_selector('.alert', text: "Please provide at least a specialty or location to search")
end




