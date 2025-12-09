Given(/(\d) different (.*)s exist/) do |count, type|
    FactoryBot.create_list(type, count.to_i)
end

Then(/I should see all the (.*)s$/) do |type|
    modelClass = type.titleize.constantize
    modelClass.all.each do |record|
        record.attributes.each do |key, value|
            if key == 'password' || value == nil then next end
            expect(page).to have_content(value)
        end
    end
end