Feature: configure doctor time slots
    As a doctor
    I want to configure my time slots
    So that patients can see when I'm available

Scenario: doctor vists the time slot page
    Given I am signed in as a doctor
    And I have the slots "10:00 AM, 3:30 PM"
    And I am on the time slot page
    Then I should see "10:00 AM - " before "3:30 PM -"

Scenario: non-doctor fails to visit the time slot page
    Given I am on the time slot page
    Then I should be on the login page
    And I should see the string "This page or action requires you to be logged in"

Scenario: doctor changes time slots
    Given I am signed in as a doctor
    And I have the slots "10:00 AM, 3:30 PM"
    And I am on the time slot page
    When I add the slots "9:30 AM, 11:00 AM"
    And I remove the slot "10:00 AM"
    Then I should have the slots "9:30 AM, 11:00 AM, 3:30 PM"
    And I should see the strings "9:30 AM -, 11:00 AM -, 3:30 PM -"
    And I should not have the slot "10:00 AM"
    And I should not see the string "10:00 AM"