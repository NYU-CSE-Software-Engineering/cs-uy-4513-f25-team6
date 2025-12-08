Feature: Admin views arbitrary DB tables
    As an admin
    I want to view tables from the database
    So that I can monitor the function of the app

Background:
    Given I am signed in as an admin
    And I am on the admin dashboard page

Scenario: Admin views list of doctors
    Given 4 different doctors exist
    When I select "Doctor" from "table"
    And I click "View"
    Then I should see all the doctors

Scenario: Admin views list of patients
    Given 4 different patients exist
    When I select "Patient" from "table"
    And I click "View"
    Then I should see all the patients

Scenario: Admin views list of appointments
    Given 4 different appointments exist
    When I select "Appointment" from "table"
    And I click "View"
    Then I should see all the appointments