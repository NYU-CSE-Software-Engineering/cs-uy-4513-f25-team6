When(/I have the slots? "(.*)"/) do |slots|
    slots.split(', ').each do |slot|
        FactoryBot.create(:time_slot, doctor: @test_user, starts_at: slot)
    end
end

When(/I add the slots? "(.*)"/) do |slots|
    slots.split(', ').each do |slot|
        fill_in "Start Time", with: slot
        fill_in "End Time", with: Time.parse(slot + " UTC") + 1.minutes
        click_button "Add Time Slot"
    end
end

When(/I remove the slots? "(.*)"/) do |slots|
    slots.split(', ').each do |slot|
        page.find('td', text: slot+" -").find('+td button').click
    end
end

Then(/I should(?: still)?( not)? have the slots? "(.*)"/) do |inverse, slots|
    slots.split(', ').each do |slot|
        expect(TimeSlot.exists?(starts_at: slot)).to eq(!inverse)
    end
end

Then(/I should( not)? see the time slots? "(.*)"/) do |inverse, slots|
    slots.split(', ').each do |slot|
        if inverse 
            expect(page).to_not have_content(slot)
        else
            expect(page).to_not have_content(slot)
        end
    end
end