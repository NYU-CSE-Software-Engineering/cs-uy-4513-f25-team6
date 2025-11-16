require 'digest'

FactoryBot.define do
  sequence :tag, "0000"

  # This factory should never be directly used, it just exists to
  # provide the password functionality to all the actual user types
  factory :user do
    after(:build) do |user, evaluator|
      # If password is provided as plain text, hash it
      if user.password && user.password.length != 32
        user.password = Digest::MD5.hexdigest(user.password)
      elsif user.password.nil?
        user.password = Digest::MD5.hexdigest('secret12')
      end
    end
  end

  factory :patient, parent: :user, class: Patient do
    username { "patient#{generate :tag}" }
    email { "#{username}@example.com" }
  end

  factory :doctor, parent: :user, class: Doctor do
    username { "doctor#{generate :tag}" }
    email { "#{username}@example.com" }
  end

  factory :admin, parent: :user, class: Admin do
    username { "admin#{generate :tag}" }
    email { "#{username}@example.com" }
  end
end

