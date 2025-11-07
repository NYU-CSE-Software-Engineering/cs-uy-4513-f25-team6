require 'digest'

FactoryBot.define do
  factory :user do
    transient do
      role { 'patient' }
    end

    email { "user#{SecureRandom.hex(4)}@example.com" }
    username { "user#{SecureRandom.hex(4)}" }
    
    after(:build) do |user, evaluator|
      # If password is provided as plain text, hash it
      if user.password && user.password.length != 32
        user.password = Digest::MD5.hexdigest(user.password)
      elsif user.password.nil?
        user.password = Digest::MD5.hexdigest('secret12')
      end
    end

    initialize_with do
      attrs = attributes.except(:role)
      case role
      when 'patient'
        Patient.new(attrs)
      when 'doctor'
        Doctor.new(attrs)
      when 'admin'
        Admin.new(attrs)
      else
        Patient.new(attrs)
      end
    end

    to_create do |instance|
      instance.save!
    end
  end

  factory :patient, class: Patient do
    email { "patient#{SecureRandom.hex(4)}@example.com" }
    username { "patient#{SecureRandom.hex(4)}" }
    password { Digest::MD5.hexdigest('secret12') }
  end

  factory :doctor, class: Doctor do
    email { "doctor#{SecureRandom.hex(4)}@example.com" }
    username { "doctor#{SecureRandom.hex(4)}" }
    password { Digest::MD5.hexdigest('secret12') }
  end

  factory :admin, class: Admin do
    email { "admin#{SecureRandom.hex(4)}@example.com" }
    username { "admin#{SecureRandom.hex(4)}" }
    password { Digest::MD5.hexdigest('secret12') }
  end
end

