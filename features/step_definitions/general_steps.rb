require 'uri'

def path_to(page_name)
    case page_name

    # add whatever pages you need to this mapping
    when 'login' then '/login'
    when 'doctor sign up' then '/login/signup_doctor'

    when 'prescriptions' then '/patient/prescriptions'

    when 'doctor dashboard' then '/doctor/dashboard'
    when 'doctor appointments' then '/doctor/appointments'
    when 'time slot' then '/doctor/time_slots'
    

    else raise "Can't find mapping from \"#{page_name}\" to a path."
    end
end

Given(/I am signed in as a (.*)/) do |type|
    case type
    when 'patient'
        @test_user = Patient.create!(email: "patient@example.com", password: "password")
    when 'doctor'
        @test_user = Doctor.create!(email: "doctor@example.com", password: "password")
    when 'admin'
        @test_user = Admin.create!(email: "admin@example.com", password: "password")
    else
        raise "#{type} is not a valid role."
    end
    visit '/login'
    fill_in 'Email', with: @test_user.email
    fill_in 'Password', with: @test_user.password
    click_button 'Log In'
end

Given(/I am on the (.*) page/) do |page_name|
    visit path_to(page_name)
end

When(/I click "(.*)"/) do |target|
    click_on target
end

When(/I fill in "(.*)" with "(.*)"/) do |target, value|
    fill_in target, with: value
end

Then(/I should be on the (.*) page/) do |page_name|
    current_path = URI.parse(current_url).path
    assert_equal path_to(page_name), current_path
end

Then(/I should( not)? see "(.*)"/) do |inverse, text|
    if (inverse)
        expect(page).not_to have_content(text)
    else
        expect(page).to have_content(text)
    end
end