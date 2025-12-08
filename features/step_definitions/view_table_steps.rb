Given(/(\d) different (.*)s exist/) do |count, type|
    FactoryBot.create(type, count.to_i)
end

Then(/I should see all the (.*)s/) do |type|
    class = type.constantize
    class.all.each do |record|
        record.attributes.each do |key, value|
            expect(page).to have_content(value)
        end
    end
end