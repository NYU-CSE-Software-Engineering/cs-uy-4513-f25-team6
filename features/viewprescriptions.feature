Feature: View prescriptions
  As a signed-in patient
  I want to access my prescriptions
  So that I can follow my treatment correctly

  Background:
    Given I am signed in as a patient

  Scenario: Patient sees their prescriptions ordered by issue date (newest first)
    Given the following prescriptions exist for me:
      | medication_name | dosage             | instructions                 | doctor_name | issued_on  | status  |
      | Ibuprofen       | 200 mg as needed   | Take with food as necessary  | Dr Rivera   | 2025-10-15 | active  |
      | Zyrtec          | 2 tablets daily    | Take with meal               | Dr Smith    | 2025-09-20 | expired |
      | Panadol         | 1 tablet daily     | Take with evening meal       | Dr Rivera   | 2025-10-10 | active  |
    When I visit the prescriptions page
    Then I should see a prescriptions list
    And I should see "Ibuprofen" before "Panadol"
    And I should see "Panadol" before "Zyrtec"

  Scenario: Empty table when the patient has no prescriptions
    Given I have no prescriptions
    When I visit the prescriptions page
    Then I should see "You don't have any prescriptions yet."

  Scenario: Patient cannot view another patient's prescriptions
    Given another patient exists with a prescription "ConfidentialMed"
    When I visit the prescriptions page
    Then I should not see "ConfidentialMed"

  Scenario: Patient filters prescriptions by status
    Given the following prescriptions exist for me:
      | medication_name | dosage           | instructions                 | doctor_name | issued_on  | status  |
      | Ibuprofen       | 200 mg as needed | Take with food as necessary  | Dr Rivera   | 2025-10-15 | active  |
      | Zyrtec          | 2 tablets daily  | Take with meal               | Dr Smith    | 2025-09-20 | expired |
      | Panadol         | 1 tablet daily   | Take with evening meal       | Dr Rivera   | 2025-10-10 | active  |
    When I visit the prescriptions page
    And I choose "active" in the status filter
    And I apply the filter
    Then I should see "Ibuprofen"
    And I should see "Panadol"
    And I should not see "Zyrtec"

  Scenario: Patient filters and there are no matching records
    Given the following prescriptions exist for me:
      | medication_name | dosage           | instructions                 | doctor_name | issued_on  | status |
      | Ibuprofen       | 200 mg as needed | Take with food as necessary  | Dr Rivera   | 2025-10-15 | active |
      | Zyrtec          | 2 tablets daily  | Take with meal               | Dr Smith    | 2025-09-20 | expired|
      | Panadol         | 1 tablet daily   | Take with evening meal       | Dr Rivera   | 2025-10-10 | active |
    When I visit the prescriptions page with status "cancelled"
    Then I should see "No prescriptions match your filter."
