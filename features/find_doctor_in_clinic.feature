Feature: Find Doctor Within Clinic As Patient
    As a patient
    I want to find a doctor within a clinic
    So I can sign up for appointments  

Background:
    Given a clinic exists with the following doctors
      | name       | specialty        | rating |
      | John Smith | Physical Therapy | 4.6    |
      | Alice Doe  | Dermatology      | 4.8    |
    And I am on the "Find a Doctor" page for that clinic

Scenario: User views full list of doctors
    Then I should see all the doctors at that clinic

Scenario: User searches for a doctor with valid information
    When I select "Physical Therapy" from "specialty"
    And I click "Search"
    Then I should see a doctor named "John Smith" specializing in "Physical Therapy"

Scenario: User sorts by clinic rating
    When I click "Rating"
    Then I should see a list of doctors within this clinic sorted by their ratings

