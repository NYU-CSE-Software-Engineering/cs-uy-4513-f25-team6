FactoryBot.define do

    sequence :doctor_username do |n|
        # define a sequence called :doctor_username
        "doctor#{n}" # each time the sequence is used, `n` increments (1, 2, 3, ...)
    end

    # this is the factory that will be used to create doctors
    factory :doctor, class: Doctor do # define a factory called :doctor
        username { generate :doctor_username } # set the `username` attribute to the value of the :doctor_username sequence
        email { "#{username}@example.com" } # set the `email` attribute based on the username
        password { Digest::MD5.hexdigest('secret12') } # set the `password` attribute to a hashed password
        specialty { "General" } # set the `specialty` attribute to "General"
        salary { 100000.0 } # set the `salary` attribute to 100000.0
        phone { "555-123-4567" } # set the `phone` attribute to a default phone number
        rating { 0.0 } # set the `rating` attribute to 0.0 by default
        clinic { nil } # set the `clinic` association to nil by default (optional)
    end
end