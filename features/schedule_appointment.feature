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
    And the following clinic exists:
      | name              | id |
      | Midtown Health    | 1  |
    And doctor "dr_user" works at clinic "Midtown Health"
    And the following time slots exist for doctor "dr_user":
      | starts_at           | ends_at             |
      | 2026-01-05 09:00 AM | 2026-01-05 09:30 AM |
      | 2026-01-05 09:30 AM | 2026-01-05 10:00 AM |

  @happy_path
  Scenario: Patient books an available time slot
    Given I am logged in as patient "pat_user"
    And I am on the find doctor page for clinic "Midtown Health"
    When I click "dr_user"
    Then I should be on the schedule page for doctor "dr_user"
    And I should see "Available time slots"
    And I should see "2026-01-05 09:00 AM – 09:30 AM"
    When I press "Book 2026-01-05 09:00 AM"
    Then I should see "Appointment confirmed"
    And I should be on my appointments page
    And an appointment should exist for patient "pat_user" with doctor "dr_user" at "2026-01-05 09:00 AM"

  @sad_path
  Scenario: Patient cannot book an already taken slot
    Given I am logged in as patient "pat_user"
    And time slot "101" for doctor "dr_user" is already booked
    And I am on the schedule page for doctor "dr_user"
    When I press "Book 2026-01-05 09:00 AM"
    Then I should see "Time slot no longer available"
    And I should stay on the schedule page for doctor "dr_user"
