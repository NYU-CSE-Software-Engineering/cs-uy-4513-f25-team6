@wip
Feature: configure doctor time slots

    As a doctor
    I want to configure my time slots
    So that patients can see when I'm available

Scenario: doctor vists the time slot page
    Given I am signed in as a doctor
    And I am on the doctor dashboard page
    And I have the slots "10:00am, 3:30pm"
    When I try to edit my time slots
    Then I should be on the time slot page
    And my current time slots should be selected

Scenario: non-doctor fails to visit the time slot page
    Given I am on the doctor dashboard page
    When I try to edit my time slots
    Then I should be on the login page
    And I should see "You cannot perform this action without logging in!"

Scenario: doctor changes time slots
    Given I am signed in as a doctor
    And I have the slots "10:00am, 3:30pm"
    And I am on the time slot page
    When I confirm the slots "9:30am, 11:00am, 1:30pm"
    Then I should be on the doctor dashboard page
    And I should see the time slots "9:30am, 11:00am, 1:30pm"
    And I should not see the time slots "10:00am, 3:30pm"

Scenario: doctor fails to confirm time slots with none selected
    Given I am signed in as a doctor
    And I am on the time slot page
    When I confirm the slots ""
    Then I should be on the time slot page
    And I should see "You must select at least one time slot!"

Scenario: non-doctor fails to confirm time slots
    Given I am on the time slot page
    When I confirm the slots "9:30am, 11:00am, 1:30pm"
    Then I should be on the login page
    And I should see "You cannot perform this action without logging in!"