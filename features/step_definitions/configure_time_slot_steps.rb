require 'time'

def slot_names()
    output = []
    10.times do |i|
        hour = if i<5 then (i + 8) else (i - 4) end
        suffix = if i<4 then 'am' else 'pm' end
        output.push "#{hour}:00#{suffix}"
        output.push "#{hour}:30#{suffix}"
    end
    return output
end

When ('I have the slots {string}') do |slots|
    slots.split(', ').each do |slot|
        TimeSlot.create!(doctorID: @test_user.id, time:Time.parse(slot))
    end
end

When('I try to edit my time slots') do
    click_button 'Edit Time Slots'
end

Then('my current time slots should be selected') do
    TimeSlot.where(doctorID: @test_user.id).each do |slot|
        slot_name = slot.time.strftime('%l:%M%P')
        expect(page).to have_field(slot_name, checked: true)
    end
end

When('I confirm the slots {string}') do |slots|
    to_select = slots.split(', ')
    slot_names.each do |name|
        if to_select.include?(name)
            check name
        else
            uncheck name
        end
    end
    click_button 'Confirm Time Slots'
end

Then(/I should( not)? see the time slots "(.*)"/) do |inverse, slots|
    slots.split(', ').each do |slot|
        if inverse 
            expect(page).to_not have_content(slot)
        else
            expect(page).to_not have_content(slot)
        end
    end
end