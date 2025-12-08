Feature: Admin creates a new clinic
    As an admin
    I want to create a new clinic
    So that doctors have somewhere to work

Background:
    Given I am signed in as an admin
    And I am on the admin dashboard page

Scenario: Admin successfully creates clinic
    When I fill in "clinic_name" with "newClinA"
    And I fill in "clinic_specialty" with "Fever"
    And I fill in "clinic_location" with "Albany"
    And I fill in "clinic_rating" with "4.5"
    And I click "Create clinic"
    Then a clinic named "newClinA" in "Albany" should exist with specialty "Fever" and rating "4.5"
    And I should see the string "New clinic created"

Scenario: Admin fails to create clinic with missing attributes
    When I fill in "Specialty" with "thingy"
    And I click "Create clinic"
    Then no clinics should exist
    And I should see the string "Missing required data"

Scenario: Admin fails to create clinic with existing name
    Given a clinic named "TheClinic" already exists
    When I fill in "clinic_name" with "TheClinic"
    And I fill in "clinic_specialty" with "Fever"
    And I fill in "clinic_location" with "Mississippi"
    And I fill in "clinic_rating" with "4.7"
    And I click "Create clinic"
    Then a clinic named "TheClinic" in "Mississippi" should not exist with specialty "Fever" and rating "4.7"
    And I should see the string "A clinic with that name already exists"