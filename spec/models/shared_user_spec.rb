require 'rails_helper'
require 'spec_helper'
require 'digest'

shared_examples 'user model' do
    it 'can be created with valid email, username, and password' do
        expect { described_class.create!(email: "test@test.com", username: "testUser", password: Digest::MD5.hexdigest("testPassword")) }.not_to raise_error
    end

    it 'cannot be created if any of (email, username, password) are missing' do 
        expect { described_class.create!(username: "testUser", password: Digest::MD5.hexdigest("testPassword")) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { described_class.create!(email: "test@test.com",password: Digest::MD5.hexdigest("testPassword")) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { described_class.create!(email: "test@test.com", username: "testUser") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does not allow duplicate emails or usernames' do
        patient1 = described_class.create!(email: "test@test.com", username: "testUser", password: Digest::MD5.hexdigest("testPassword"))
        expect { described_class.create!(email: "test@test.com", username: "otherTestUser", password: Digest::MD5.hexdigest("testPassword2")) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { described_class.create!(email: "otherTest@test.com", username: "testUser", password: Digest::MD5.hexdigest("testPassword3")) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'does allow duplicate passwords' do
        patient1 = described_class.create!(email: "test@test.com", username: "testUser", password: Digest::MD5.hexdigest("testPassword"))
        expect { described_class.create!(email: "otherTest@test.com", username: "otherTestUser", password: Digest::MD5.hexdigest("testPassword")) }.not_to raise_error
    end

    it 'attempts to block plaintext password assignment' do
        expect { described_class.create!(email: "test@test.com", username: "testUser", password: "rawPassword") }.to raise_error(ActiveRecord::RecordInvalid)
    end
end