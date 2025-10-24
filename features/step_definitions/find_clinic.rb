# generic location and specialty "should see" step definition
  Then(/I should see a list of clinics located in "(.*)" specializing in "(.*)"/) do |location, specialty|
    expect(page).to have_content("Clinics located in #{location} specializing in #{specialty}")
  end
  
  Then(/^I should see a list of clinics sorted by their ratings$/) do

    all_ratings = all('.rating') # Extract all rating values from the page

    ratings = all_ratings.map{ |each_rating| each_rating.text.to_f} # Convert the rating text to float values (e.g. "4.5" becomes 4.5)
    
    expect(ratings).to eq(ratings.sort.reverse) # check that the ratings are sorted in descending order (highest rating at the top)
  end
  
  Then(/^I should see an error message indicating missing search fields$/) do
    expect(page).to have_selector('.error', text: "Error: Missing Search Fields")
  end




