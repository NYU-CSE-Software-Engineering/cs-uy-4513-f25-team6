Feature: Admin creates a new clinic
    As an admin
    I want to create a new clinic
    So that doctors have somewhere to work

Background:
    Given I am signed in as an admin
    And I am on the admin dashboard page

Scenario: Admin successfully creates clinic
    When I fill in "Clinic name" with "newClinA"
    And I fill in "Specialty" with "Fever"
    And I fill in "Location" with "Albany"
    And I fill in "Rating" with "4.5"
    And I click "Create clinic"
    Then a clinic called "newClinA" in "Albany" should exist with specialty "Fever" and rating "4.5"

Scenario: Admin fails to create clinic with missing attributes
    When I fill in "Specialty" with "thingy"
    And I click "Create clinic"
    Then no clinics should exist
    And I should see the string "Missing required data"

Scenario: Admin fails to create clinic with existing name
    Given a clinic named "TheClinic" already exists
    When I fill in "Clinic name" with "TheClinic"
    And I fill in "Specialty" with "Fever"
    And I fill in "Location" with "Mississippi"
    And I fill in "Rating" with "4.7"
    And I click "Create clinic"
    Then a clinic called "TheClinic" in "Mississippi" should not exist with specialty "Fever" and rating "4.7"
    And I should see the string "A clinic with that name already exists"