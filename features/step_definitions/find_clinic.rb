


# Givens #
   Given(/^I am a signed in patient$/) do
     
    visit '/login'
    @test_user = Patient.create!(email: 'patient@example.com', password: 'password')
    fill_in 'Email', with:  @test_user.email
    fill_in 'Password', with: @test_user.password
    click_button 'Log in'
  end
  
  Given(/^I am on the (.*) page$/) do |page_name|
    visit path_to(page_name)
  end


  # Whens # 

  # generic fill-in step definition
    # this handles filling in 'Specialty' with 'Dermatology' or 'Location' with 'New York'
  When(/^I fill in `(.*)` with `(.*)`$/) do |field_name, value|
    fill_in field_name, with: value
  end
  
  # generic click step definition
    # this handles clicking 'Search' or 'Sort By Rating' buttons
  When(/^I click `(.*)`$/) do |button_name|
    click_button button_name
  end


  # Thens # 
  
  # generic location and specialty "should see" step definition
  Then('I should see a list of clinics located in `(.*)` specializing in `(.*)`') do |location, specialty|
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




