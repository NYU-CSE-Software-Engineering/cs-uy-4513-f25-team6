Feature: configure doctor time slots
    As a doctor
    I want to configure my time slots
    So that patients can see when I'm available

Scenario: doctor vists the time slot page
    Given I am signed in as a doctor
    And I have the slots "10:00 AM, 3:30 PM"
    And I am on the time slot page
    Then I should see the time slots "10:00 AM, 3:30 PM"

Scenario: non-doctor fails to visit the time slot page
    Given I am on the time slot page
    Then I should be on the login page
    And I should see "This page requires you to be logged in"

Scenario: doctor changes time slots
    Given I am signed in as a doctor
    And I have the slots "10:00 AM, 3:30 PM"
    And I am on the time slot page
    When I add the slots "9:30 AM, 11:00 AM"
    And I remove the slot "10:00 AM"
    Then I should have the slots "9:30 AM, 11:00 AM, 3:30 AM"
    And I should see the time slots "9:30 AM, 11:00 AM, 3:30 AM"
    And I should not have the slot "10:00 AM"
    And I should not see the time slot "10:00 AM"

Scenario: doctor fails to remove last time slot
    Given I am signed in as a doctor
    And I have the slot "9:45 AM"
    And I am on the time slot page
    When I remove the slot "9:45 AM"
    Then I should see "You must have at least one time slot"
    And I should still have the slot "9:45 AM"