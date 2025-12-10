Feature: Doctor creates a bill for an appointment
    As a doctor
    I want to create a bill for an appointment
    So that I can get paid for my work

Background:
    Given I am signed in as a doctor
    And an appointment exists on "2025-01-01"

Scenario: Doctor succesfully creates bill from appointment page
    Given I am on the doctor appointments page
    Then I should see the string "Create bill"
    When I click "Create bill"
    Then I should be on the bill creation page
    When I fill in "bill_amount" with "350"
    And I fill in "bill_due_date" with "2026-02-02"
    And I click "Create bill"
    Then I should be on the doctor appointments page
    And a bill of "350" due on "2026-02-02" should exist

Scenario: Doctor fails to create bill with no amount
    Given I am on the bill creation page
    And I fill in "bill_due_date" with "2026-02-02"
    And I click "Create bill"
    Then I should not be on the doctor appointments page
    And I should see the string "Invalid bill details"

Scenario: Doctor fails to create bill with due date in the past
    Given I am on the bill creation page
    When I fill in "bill_amount" with "350"
    And I fill in "bill_due_date" with "2024-02-02"
    And I click "Create bill"
    Then I should not be on the doctor appointments page
    And I should see the string "Invalid bill details"