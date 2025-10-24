Feature: Find Clinics

    As a patient
    I want to find a clinic
    So I can sign up for appointments  



Scenario: User searches for a clinic with valid information
    
    Given I am signed in as a patient
    And I am on the "Find Clinics" page
    When I fill in "Specialty" with "Dermatology"
    And I fill in "Location" with "New York"
    And I click "Search"
    Then I should see a list of clinics located in "New York" specializing in "Dermatology"


Scenario: User sorts by clinic rating

    Given I am signed in as a patient
    And I am on the "Find Clinics" page
    When I click "Sort By Rating"
    Then I should see a list of clinics sorted by their ratings


Scenario: User searches for a clinic with invalid information

    Given I am signed in as a patient
    And I am on the "Find Clinics" page
    When I click "Search"
    Then I should see an error message indicating missing search fields


     
   







