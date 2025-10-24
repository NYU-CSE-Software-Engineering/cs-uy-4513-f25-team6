Feature: View appointments as a doctor
  As a doctor
  I want to view my upcoming appointments
  So that I can manage my schedule and prepare for each patient

  Background:
    Given I am signed in as a doctor

  Scenario: Doctor views their upcoming appointments
    Given I have the following appointments
      | patient_id | appointment_time | status    | clinic_name |
      | 321        | 2025-04-13 10:00 | Completed | ClinicA     |
      | 678        | 2025-11-11 10:00 | Upcoming  | ClinicA     |
    And I visit the appointments page
    Then I should see a list of my upcoming appointments
    And each appointment should display the patient's name, date, and clinic

  Scenario: Doctor filters appointments by status
    Given I have the following appointments
      | patient_id | appointment_time | status    | clinic_name |
      | 321        | 2025-04-13 10:00 | Completed | ClinicA     |
      | 678        | 2025-11-11 10:00 | Upcoming  | ClinicA     |
    And I am on the appointments page
    When I select "Completed" from the status dropdown
    Then I should see only completed appointments

  Scenario: Doctor has no upcoming appointments
    When I visit the appointments page
    Then I should see the message "No upcoming appointments found."

  Scenario: Unauthorized user tries to view another doctor's appointments
    When I attempt to access another doctor's appointments page
    Then I should see the message "You are not authorized to view this page."