@appointments @ui
Feature: Patient picks an appointment time with a doctor
  As a patient
  I want to view a doctor’s available time slots and book one
  So that I can schedule an appointment

  Background:
    Given the following users exist:
      | role    | email           | username | password |
      | patient | pat@example.com | pat_user | Secret12 |
      | doctor  | dr@example.com  | dr_user  | Secret12 |
    And a clinic called "Midtown Health" exists
    And doctor "dr_user" works at clinic "Midtown Health"
    And the following time slots exist for doctor "dr_user":
      | starts_at | ends_at |
      | 09:00     | 09:30   |
      | 09:30     | 10:00   |

  @happy_path
  Scenario: Patient books an available time slot
    Given I am logged in as patient "pat_user"
    And I am on the find doctor page for clinic "Midtown Health"
    Then I should see "dr_user"
    When I click "dr_user"
    Then I should be on the time slots page for doctor "dr_user"
    And I should see "9:00 AM - 9:30 AM"
    When I book the slot starting at "9:00 AM"
    Then I should see "Appointment confirmed"
    And I should be on my appointments page
    And an appointment should exist for patient "pat_user" with doctor "dr_user" at "09:00 AM"

  @happy_path
  Scenario: Patient cannot see a slot that is already booked
    Given I am logged in as patient "pat_user"
    And the slot starting at "9:00 AM" for doctor "dr_user" is already booked
    And I am on the time slots page for doctor "dr_user"
    Then I should not see "9:00 AM - 9:30 AM"

  @sad_path
  Scenario: Patient cannot book a slot that was booked while they were viewing the page
    Given I am logged in as patient "pat_user"
    And I am on the time slots page for doctor "dr_user"
    And the slot starting at "9:00 AM" for doctor "dr_user" is already booked
    Then I should see "9:00 AM - 9:30 AM"
    When I book the slot starting at "9:00"
    Then I should see "Time slot no longer available"
    And I should stay on the time slots page for doctor "dr_user"
