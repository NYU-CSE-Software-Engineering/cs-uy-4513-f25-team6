@wip
Feature: Manage prescriptions as a doctor
  As a signed-in doctor
  I want to view patient prescriptions and create new ones
  So that I can manage my patients' treatments

  Background:
    Given I am signed in as a doctor

  Scenario: Doctor can view the prescriptions management page
    Given I am on the doctor prescriptions page
    Then I should see the string "Prescriptions Management"
    And I should see the string "Select a Patient"

  Scenario: Doctor selects a patient and sees their prescriptions
    Given the following patients exist:
      | email              | username    |
      | john@example.com   | johnpatient |
    And the following prescriptions exist for patient "johnpatient":
      | medication_name | dosage           | instructions            | issued_on  | status |
      | Amoxicillin     | 500 mg 3x daily  | Take with food          | 2025-11-01 | active |
      | Lisinopril      | 10 mg daily      | Take in the morning     | 2025-10-15 | active |
    And I am on the doctor prescriptions page
    When I select "johnpatient" from the patient dropdown
    And I click "View Prescriptions"
    Then I should see the string "Prescriptions for johnpatient"
    And I should see the string "Amoxicillin"
    And I should see the string "Lisinopril"

  Scenario: Doctor sees empty state when patient has no prescriptions
    Given the following patients exist:
      | email              | username     |
      | empty@example.com  | emptypatient |
    And I am on the doctor prescriptions page
    When I select "emptypatient" from the patient dropdown
    And I click "View Prescriptions"
    Then I should see the string "This patient has no prescriptions."

  Scenario: Doctor creates a new prescription for a patient
    Given the following patients exist:
      | email              | username    |
      | jane@example.com   | janepatient |
    And I am on the doctor prescriptions page
    When I select "janepatient" from the patient dropdown
    And I click "View Prescriptions"
    And I fill in "Medication Name" with "Metformin"
    And I fill in "Dosage" with "500 mg twice daily"
    And I fill in "Instructions" with "Take with meals"
    And I click "Create Prescription"
    Then I should see the string "Prescription created successfully"
    And I should see the string "Metformin"

  Scenario: Doctor cannot create prescription without medication name
    Given the following patients exist:
      | email              | username    |
      | test@example.com   | testpatient |
    And I am on the doctor prescriptions page
    When I select "testpatient" from the patient dropdown
    And I click "View Prescriptions"
    And I fill in "Dosage" with "10 mg"
    And I click "Create Prescription"
    Then I should see the string "Failed to create prescription"

  Scenario: Only doctors can access the doctor prescriptions page
    Given I log out
    When I try to visit the doctor prescriptions page
    Then I should be on the login page
    And I should see the string "doctor"

  Scenario: Patients cannot access the doctor prescriptions page
    Given I log out
    And I am signed in as a patient
    When I try to visit the doctor prescriptions page
    Then I should be on the login page
    And I should see the string "doctor"

