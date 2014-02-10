Feature: Visit "Request History" Web Page
  As a visitor to the website
  I want to see everything that I expect on the request_history pages
  so I can know that the site is working

  # "Request History" does not show up for PCMO and Admin.

  Scenario: Check stuff on PCV "Request History" pages
    Given I exist as a user
    And I am a "pcv"
    And I am not logged in
    And I sign in with valid credentials
    And I go to the request history page
    Then I should see pcv gear area items
    Then I should see std icon area items

    Then I should see column "Supply"
    Then I should see column "Requested"
    Then I should see column "Response"

