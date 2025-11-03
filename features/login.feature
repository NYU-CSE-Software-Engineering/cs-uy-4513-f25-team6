@auth @ui
Feature: User logs in
  As a registered user (patient, doctor, or admin)
  I want to log in with my email/username and password
  So that I can access my dashboard

  Background:
    Given the following users exist:
      | role   | email                 | username   | password |
      | patient| pat@example.com       | pat_user   | Secret12 |
      | doctor | drsmith@example.com   | dr_smith   | Secret12 |
      | admin  | admin@example.com     | admin_user | Secret12 |

  @happy_path
  Scenario: Patient logs in successfully with email
    Given I am on the login page
    When I fill in "Email or Username" with "pat@example.com"
    And I fill in "Password" with "Secret12"
    And I click "Log in"
    Then I should see "Welcome, pat_user"
    And I should be on the patient dashboard page

  @username_login
  Scenario: Doctor logs in successfully with username
    Given I am on the login page
    When I fill in "Email or Username" with "dr_smith"
    And I fill in "Password" with "Secret12"
    And I click "Log in"
    Then I should see "Welcome, dr_smith"
    And I should be on the doctor dashboard page

  @sad_path
  Scenario: Login fails with invalid password
    Given I am on the login page
    When I fill in "Email or Username" with "admin@example.com"
    And I fill in "Password" with "wrongpass"
    And I click "Log in"
    Then I should see "Invalid credentials"
    And I should be on the login page
