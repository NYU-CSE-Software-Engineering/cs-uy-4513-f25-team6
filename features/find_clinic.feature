Feature: Find Clinics
    As a patient
    I want to find a clinic
    So I can sign up for appointments  

Background:
    Given the following clinics exist
      | name  | specialty   | location | rating |
      | ClinA | Dermatology | New York | 4.5    |
      | ClinB | Dermatology | Boston   | 5      |
      | ClinC | Opthamology | New York | 4.7    |
      | ClinD | Opthamology | Albany   | 4.3    |

Scenario: User searches for a clinic with valid information
    Given I am signed in as a patient
    And I am on the find clinics page
    When I select "Dermatology" from "Specialty"
    And I select "New York" from "Location"
    And I click "Search"
    Then I should see a list of clinics located in "New York" specializing in "Dermatology"

Scenario: User sorts search results by clinic rating
    Given I am signed in as a patient
    And I have searched for a clinic in "New York"
    When I click "Rating"
    Then I should see a list of clinics sorted by their ratings


     
   







