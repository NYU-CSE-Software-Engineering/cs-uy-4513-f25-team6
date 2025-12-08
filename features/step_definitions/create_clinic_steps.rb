Then(/a clinic called "(.*)" in "(.*)" should( not)? exist with specialty "(.*)" and rating "(.*)/) do |name, location, inverse, specialty, rating|
    clinic = Clinic.find_by(name: name, location: location, specialty: specialty, rating: rating)
    if inverse
        expect(clinic).to be_nil
    else
        expect(clinic).not_to be_nil
    end
end

Then('No clinics should exist') do
    expect(Clinic.count).to eq(0)
end