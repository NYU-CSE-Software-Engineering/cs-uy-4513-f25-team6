Feature: View bill as non-patient
    As a doctor or admin
    I want to look at a bill
    So that I can see if it has been paid

Scenario: Doctor successfully views a bill for their patient (but cannot pay it)
    Given I am signed in as a doctor
    And one of my patients has a bill
    When I visit the page for the bill
    Then I should not see the string "You are not authorized to access this bill"
    And I should not see the string "Payment Information"

Scenario: Doctor fails to view a bill for someone else's patient
    Given I am signed in as a doctor
    And a bill exists
    When I visit the page for the bill
    Then I should see the string "You are not authorized to access this bill"

Scenario: Admin views a bill (but cannot pay it)
    Given I am signed in as an admin
    And a bill exists
    When I visit the page for the bill
    Then I should not see the string "You are not authorized to access this bill"
    And I should not see the string "Payment Information"