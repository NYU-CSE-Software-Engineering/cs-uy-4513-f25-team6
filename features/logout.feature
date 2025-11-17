Feature: User logs out
    As a logged-in user
    I want to log out of my session
    So that other people using the computer cannot see my data

Scenario: Patient logs out
    Given I am signed in as a patient
    When I click "Log Out"
    Then I should be on the login page
    And I should see "Successfully logged out"

Scenario: Doctor logs out
    Given I am signed in as a doctor
    When I click "Log Out"
    Then I should be on the login page
    And I should see "Successfully logged out"

Scenario: Admin logs out
    Given I am signed in as an admin
    When I click "Log Out"
    Then I should be on the login page
    And I should see "Successfully logged out"