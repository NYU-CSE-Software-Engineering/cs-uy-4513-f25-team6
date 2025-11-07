require 'uri'
require 'digest'

def path_to(page_name)
    case page_name

    # add whatever pages you need to this mapping
    when 'login' then '/login'
    when 'doctor sign up' then '/login/signup_doctor'

    when 'patient dashboard' then '/patient/dashboard'
    when 'prescriptions' then '/patient/prescriptions'

    when 'doctor dashboard' then '/doctor/dashboard'
    when 'doctor appointments' then '/doctor/appointments'
    when 'time slot' then '/doctor/time_slots'

    when 'admin dashboard' then '/admin/dashboard'
    

    else raise "Can't find mapping from \"#{page_name}\" to a path."
    end
end

Given('the following users exist:') do |table|
    table.hashes.each do |row|
      pass_hash = Digest::MD5.hexdigest(row.fetch("password"))
      case row.fetch('role')
      when 'patient'
        Patient.create!(email: row.fetch("email"), username: row.fetch("username"), password: pass_hash)
      when 'doctor'
        Doctor.create!(email: row.fetch("email"), username: row.fetch("username"), password: pass_hash)
      when 'admin'
        Admin.create!(email: row.fetch("email"), username: row.fetch("username"), password: pass_hash)
      else
        raise "#{type} is not a valid role."
      end
    end
end

Given(/I am signed in as a (.*)/) do |type|
    pass_hash = Digest::MD5.hexdigest('testPassword')
    case type
    when 'patient'
        @test_user = Patient.create!(email: 'patient@example.com', username: 'testPatient', password: pass_hash)
    when 'doctor'
        @test_user = Doctor.create!(email: 'doctor@example.com', username: 'testDoctor', password: pass_hash)
    when 'admin'
        @test_user = Admin.create!(email: 'admin@example.com', username: 'testAdmin', password: pass_hash)
    else
        raise "#{type} is not a valid role."
    end
    visit '/login'
    fill_in 'Email', with: @test_user.email
    fill_in 'Password', with: 'testPassword'
    click_button 'Log In'
end

Given(/I am on the (.*) page$/) do |page_name|
    visit path_to(page_name)
end

When(/I click "(.*)"/) do |label|
    click_on label
end

When(/I choose "(.*)"/) do |label|
    choose label
end

When(/I fill in "(.*)" with "(.*)"/) do |label, value|
    fill_in label, with: value
end

Then(/I should be on the (.*) page$/) do |page_name|
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

Then("I should see {string} before {string}") do |first_text, second_text|
    a = page.text.index(first_text)
    b = page.text.index(second_text)
    expect(a).not_to be_nil, "Expected to find '#{first_text}'"
    expect(b).not_to be_nil, "Expected to find '#{second_text}'"
    expect(a).to be < b
end