Feature: user creates a new account
    As a new user
    I want to create an account
    So that I can log in and use the app

Scenario: patient successfully creates account
    Given I am on the patient sign up page
    Then I should see the string "Sign up as a patient"
    When I fill in "patient_email" with "new_pat@test.com"
    And I fill in "patient_username" with "new patient"
    And I fill in "patient_password" with "batterystaple"
    And I click "Register"
    Then I should be on the login page
    And I should see the string "Patient account created"

Scenario: doctor successfully creates account
    Given I am on the doctor sign up page
    Then I should see the string "Sign up as a doctor"
    When I fill in "doctor_email" with "new_doc@test.com"
    And I fill in "doctor_username" with "new doctor"
    And I fill in "doctor_password" with "correcthorse"
    And I click "Register"
    Then I should be on the login page
    And I should see the string "Doctor account created"

Scenario: admin successfully creates account
    Given I am on the admin sign up page
    Then I should see the string "Sign up as an admin"
    When I fill in "admin_email" with "new_adm@test.com"
    And I fill in "admin_username" with "new admin"
    And I fill in "admin_password" with "chbschbs"
    And I click "Register"
    Then I should be on the login page
    And I should see the string "Admin account created"

Scenario: user fails to create account with no email
    Given I am on the patient sign up page
    And I fill in "patient_username" with "user"
    And I fill in "patient_password" with "password"
    When I click "Register"
    Then I should not be on the patient dashboard page
    And I should see the string "Invalid account details"

Scenario: user fails to create account with no username
    Given I am on the doctor sign up page
    When I fill in "doctor_email" with "user@test.com"
    And I fill in "doctor_password" with "password"
    When I click "Register"
    Then I should not be on the doctor dashboard page
    And I should see the string "Invalid account details"

Scenario: user fails to create account with no password
    Given I am on the admin sign up page
    When I fill in "admin_email" with "user@test.com"
    And I fill in "admin_username" with "user"
    When I click "Register"
    Then I should not be on the admin dashboard page
    And I should see the string "Invalid account details"

Scenario: user fails to create account when email already exists
    Given the following users exist:
      | role    | email                 | username   | password |
      | patient | pat@example.com       | pat_user   | Secret12 |
    And I am on the patient sign up page
    When I fill in "patient_email" with "pat@example.com"
    And I fill in "patient_username" with "new patient"
    And I fill in "patient_password" with "batterystaple"
    And I click "Register"
    Then I should not be on the patient dashboard page
    And I should see the string "Invalid account details"

Scenario: user successfully creates account when email exists for a different role
    Given the following users exist:
      | role   | email                 | username   | password |
      | doctor | pat@example.com       | pat_user   | Secret12 |
    And I am on the patient sign up page
    When I fill in "patient_email" with "pat@example.com"
    And I fill in "patient_username" with "new patient"
    And I fill in "patient_password" with "batterystaple"
    And I click "Register"
    Then I should be on the login page
    And I should see the string "Patient account created"