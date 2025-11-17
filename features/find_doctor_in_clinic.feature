@wip
Feature: Find Doctor Within Clinic As Patient

    As a patient
    I want to find a doctor within a clinic
    So I can sign up for appointments  




Scenario: User searches for a doctor with valid information

    Given I've chosen a clinic already
    And I am on the "Find a Doctor" page for that clinic
    When I fill in "Name" with "John Smith"
    And I fill in "Speciality" with "Physical therapy"
    And I click "Search"
    Then I should see a doctor named "John Smith" specializing in "Physical therapy"


Scenario: User sorts by clinic rating

    Given I've chosen a clinic already
    And I am on the "Find a Doctor" page for that clinic
    When I click "Sort By Rating"
    Then I should see a list of doctors within this clinic sorted by their ratings


Scenario: User searches for a clinic with invalid information

    Given I've chosen a clinic already
    And I am on the "Find a Doctor" page for that clinic
    When I fill in "Name" with a nonexistent name
    When I click "Search"
    Then I should see an error message indicating doctor not found

