Given(/a clinic named "(.*)" already exists/) do |name|
    FactoryBot.create(:clinic, name: name)
end

Then(/a clinic named "(.*)" in "(.*)" should( not)? exist with specialty "(.*)" and rating "(.*)/) do |name, location, inverse, specialty, rating|
    clinic = Clinic.find_by(name: name, location: location, specialty: specialty, rating: rating)
    if inverse
        expect(clinic).to be_nil
    else
        expect(clinic).not_to be_nil
    end
end

Then('no clinics should exist') do
    expect(Clinic.count).to eq(0)
end