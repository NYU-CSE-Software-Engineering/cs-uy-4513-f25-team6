FactoryBot.define do

    sequence :clinic_name do |n|
        # define a sequence called :clinic_name
        "Clinic #{n}" # each time the sequence is used, `n` increments (1, 2, 3, ...)
    end


    # this is the real factory that will be used to create clinics
    factory :clinic do # define a factory called :clinic
        name { generate :clinic_name } # set the `name` attribute to the value of the :clinic_name sequence
        specialty { "General" } # set the `specialty` attribute to "General"
        location { "New York" } # set the `location` attribute to "New York"
        rating { 4.0 } # set the `rating` attribute to 4.0
    end
end



