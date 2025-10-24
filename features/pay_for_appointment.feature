Feature: Pay for appointment bill
  As a signed-in patient
  I want to pay my appointment bill
  So that my balance is settled and my billing status is updated

  Background:
    Given I am signed in as a patient
    And I have an unpaid bill for one of my appointments

  @happy
  Scenario: Patient pays an unpaid bill successfully
    Given I am on the page for my unpaid bill
    When I fill in "Card Number" with "4242424242424242"
    And I fill in "Expiration Month" with "12"
    And I fill in "Expiration Year" with "2030"
    And I fill in "CVC" with "123"
    And I click "Pay Now"
    Then I should see "Payment successful"
    And I should see "Status: paid"
    And the bill should be marked paid

  @sad
  Scenario: Patient submits invalid payment information
    Given I am on the page for my unpaid bill
    When I fill in "Card Number" with ""
    And I click "Pay Now"
    Then I should see "Please enter a valid card number"
    And I should see "Status: unpaid"

  @edge
  Scenario: Patient attempts to pay an already-paid bill
    Given I have a paid bill
    And I am on the page for my paid bill
    When I click "Pay Now"
    Then I should see "This bill is already paid"
    And I should see "Status: paid"

  @authz
  Scenario: Patient tries to access someone else's bill
    Given another patient exists with a different unpaid bill
    When I visit that other patient's bill page
    Then I should see "You are not authorized to access this bill"
