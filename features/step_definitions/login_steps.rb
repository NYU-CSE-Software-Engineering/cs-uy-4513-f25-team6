When(/I try to log in as an? (.*) with the credentials "(.*)" "(.*)"/) do |type, email, password|
    fill_in "email", with: email
    fill_in "password", with: password
    choose type.titleize
    click_button "Log In"
end