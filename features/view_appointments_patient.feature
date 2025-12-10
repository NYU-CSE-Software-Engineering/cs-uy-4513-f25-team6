Feature: View appointments as a patient
  As a patient
  I want to view my upcoming appointments
  So that I can plan my schedule around them

Scenario: Patient views upcoming appointments on dashboard
    Given I am signed in as a patient
    And I have the following appointments as a patient
      | time  | date       | doctor |
      | 9:45  | 2024-07-07 | Old Dr |
      | 10:00 | 2026-04-13 | Mr Joe |
      | 11:30 | 2026-11-11 | Sbeve  |
    And I am on the patient dashboard page
    Then I should see all my upcoming appointments
    And I should not see the string "Old Dr"
    And I should not see the string "You have no upcoming appointments."

Scenario: Patient has no upcoming appointents on dashboard
    Given I am signed in as a patient
    And I am on the patient dashboard page
    Then I should see the string "You have no upcoming appointments."
    And I should not see any appointments

Scenario: Patient views all appointments on dedicated page
    Given I am signed in as a patient
    And I have the following appointments as a patient
      | time  | date       | doctor  |
      | 10:00 | 2024-11-11 | oldman  |
      | 10:00 | 2026-06-18 | realman |
      | 11:30 | 2026-10-20 | fakeman |
    And I am on the patient appointments page
    Then I should see all my appointments