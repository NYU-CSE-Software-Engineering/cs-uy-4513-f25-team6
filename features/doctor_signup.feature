Feature: Doctor signs up for the clinic
  As a doctor
  I want to create an account
  So that I can access my provider dashboard and manage my patients

  Background:
    Given I am on the doctor sign up page

  @happy_path
  Scenario: Successful sign up with valid information
    When I fill in "Name" with "Dr. Ada Lovelace"
    And I fill in "Email" with "ada@example.com"
    And I fill in "Password" with "strongpass123"
    And I fill in "Password confirmation" with "strongpass123"
    And I fill in "Medical License Number" with "NY-123456"
    And I fill in "Phone Number" with "+1 (555) 123-4567"
    And I fill in "Account Number" with "1234567890"
    And I select "Cardiology" from "Specialty"
    And I press "Create Account"
    Then I should see "Welcome, Dr. Ada Lovelace" or "A message with a confirmation link has been sent to your email address"
    And I should be on the doctor dashboard page

  @missing_fields
  Scenario: Missing required fields
    When I press "Create Account"
    Then I should see "Email can't be blank"
    And I should see "Password can't be blank"
    And I should see "Medical License Number can't be blank"
    And I should see "Phone Number can't be blank"
    And I should see "Account Number can't be blank"

  @duplicate_email
  Scenario: Email already taken
    Given a doctor exists with email "taken@example.com"
    When I fill in "Name" with "Dr. Grace Hopper"
    And I fill in "Email" with "taken@example.com"
    And I fill in "Password" with "anotherStrong1"
    And I fill in "Password confirmation" with "anotherStrong1"
    And I fill in "Medical License Number" with "CA-777777"
    And I select "Dermatology" from "Specialty"
    And I press "Create Account"
    Then I should see "Email has already been taken"

  @invalid_license
  Scenario: Invalid medical license format
    When I fill in "Name" with "Dr. Alan Turing"
    And I fill in "Email" with "alan@example.com"
    And I fill in "Password" with "goodpass888"
    And I fill in "Password confirmation" with "goodpass888"
    And I fill in "Medical License Number" with "??bad??"
    And I select "Radiology" from "Specialty"
    And I press "Create Account"
    Then I should see "Medical License Number is invalid"

  @invalid_phone
  Scenario: Invalid phone number format
    When I fill in "Name" with "Dr. Alan Turing"
    And I fill in "Email" with "alan@example.com"
    And I fill in "Password" with "goodpass888"
    And I fill in "Password confirmation" with "goodpass888"
    And I fill in "Medical License Number" with "NY-123456"
    And I fill in "Phone Number" with "abc"
    And I fill in "Account Number" with "1234567890"
    And I select "Radiology" from "Specialty"
    And I press "Create Account"
    Then I should see "Phone Number is invalid"

  @invalid_account
  Scenario: Invalid account number format
    When I fill in "Name" with "Dr. Marie Curie"
    And I fill in "Email" with "marie@example.com"
    And I fill in "Password" with "goodpass888"
    And I fill in "Password confirmation" with "goodpass888"
    And I fill in "Medical License Number" with "NJ-555555"
    And I fill in "Phone Number" with "+1 555 111 2222"
    And I fill in "Account Number" with "12ab"
    And I select "Oncology" from "Specialty"
    And I press "Create Account"
    Then I should see "Account Number is invalid"

  @weak_password
  Scenario: Weak password
    When I fill in "Name" with "Dr. Marie Curie"
    And I fill in "Email" with "marie@example.com"
    And I fill in "Password" with "123"
    And I fill in "Password confirmation" with "123"
    And I fill in "Medical License Number" with "NJ-555555"
    And I select "Oncology" from "Specialty"
    And I press "Create Account"
    Then I should see "Password is too short"


