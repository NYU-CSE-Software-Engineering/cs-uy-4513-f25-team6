When(/I have the slots? "(.*)"/) do |slots|
    slots.split(', ').each do |slot|
        FactoryBot.create(:time_slot, doctor: @test_user, starts_at: slot)
    end
end

When(/I add the slots? "(.*)"/) do |slots|
    slots.split(', ').each do |slot|
        fill_in "starts_at", with: slot
        fill_in "ends_at", with: Time.parse(slot + " UTC") + 1.minutes
        click_button "Add"
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