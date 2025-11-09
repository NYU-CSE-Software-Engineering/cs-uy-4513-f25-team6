require 'digest'

FactoryBot.define do
  sequence :tag, "0000"

  factory :user do
    transient do
      role { 'patient' }
    end

    username { "user#{generate :tag}" }
    email { |u| "#{u.username}@example.com" }
    
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
    username { "patient#{generate :tag}" }
    email { |p| "#{p.username}@example.com" }
    password { Digest::MD5.hexdigest('secret12') }
  end

  factory :doctor, class: Doctor do
    username { "doctor#{generate :tag}" }
    email { |d| "#{d.username}@example.com" }
    password { Digest::MD5.hexdigest('secret12') }
  end

  factory :admin, class: Admin do
    username { "admin#{generate :tag}" }
    email { |a| "#{a.username}@example.com" }
    password { Digest::MD5.hexdigest('secret12') }
  end
end

