Feature: View appointments as a doctor
  As a doctor
  I want to view my upcoming appointments
  So that I can manage my schedule and prepare for each patient

  Scenario: Doctor views their upcoming appointments
    Given I am signed in as a doctor
    And I have the following appointments
      | patient_id | appointment_time | status    | clinic_name |
      | 321        | 2025-04-13 10:00 | Completed | ClinicA     |
      | 678        | 2025-11-11 10:00 | Upcoming  | ClinicA     |
    And I am on the doctor appointments page
    Then I should see a list of my upcoming appointments
    And each appointment should display the patient's name, date, and clinic

  Scenario: Doctor filters appointments by status
    Given I am signed in as a doctor
    And I have the following appointments
      | patient_id | appointment_time | status    | clinic_name |
      | 321        | 2025-04-13 10:00 | Completed | ClinicA     |
      | 678        | 2025-11-11 10:00 | Upcoming  | ClinicA     |
    And I am on the doctor appointments page
    When I select "Completed" from the status dropdown
    Then I should see only completed appointments

  Scenario: Doctor has no upcoming appointments
    Given I am signed in as a doctor
    And I am on the doctor appointments page
    Then I should see the message "No upcoming appointments found."

  Scenario: Unauthorized user tries to view doctor appointments
    Given I am on the doctor appointments page
    Then I should see the message "You are not authorized to view this page."