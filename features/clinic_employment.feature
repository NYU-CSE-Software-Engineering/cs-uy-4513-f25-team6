Feature: Doctor signs up to work at a clinic
  As a doctor
  So that I can see and manage appointments at a clinic
  I want to sign up to work at a specific clinic

  Background:
    Given the following clinics exist:
      | name  | specialty   | location | rating |
      | ClinA | Dermatology | New York | 4.5    |
      | ClinB | Dermatology | Boston   | 5      |
    And the following users exist:
      | role   | email               | username | password |
      | doctor | drsmith@example.com | dr_smith | Secret12 |

  Scenario: Successfully sign up for a clinic
    Given I am signed in as a doctor
    When I visit the clinic employment page
    And I select "ClinA" from "Clinic"
    And I press "Sign up"
    Then I should see "You are now employed at ClinA"
    And I should see "ClinA" in my list of employments

  Scenario: Cannot sign up for the same clinic twice
    Given I am signed in as a doctor
    And I am already employed at "ClinA"
    When I visit the clinic employment page
    And I select "ClinA" from "Clinic"
    And I press "Sign up"
    Then I should see "You are already employed at this clinic"

  Scenario: Must be logged in as a doctor to sign up for a clinic
    Given I am logged out
    When I visit the clinic employment page
    Then I should be on the login page
    And I should see "You must be logged in as a doctor to access this page"
