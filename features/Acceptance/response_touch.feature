Feature: Visit Response Web Pages
  As a visitor to the website
  I want to see everything that I expect on the response pages
  so I can know that the site is working

  Background:
    Given that "Quirm" is a country
    Given that "Neverland" is a country
    Given that the following supplies exist:
      | name      | shortcode |
      | Froyo     | FRO       |
      | Geckos    | GEC       |
      | Bacon     | BAC       |
      | Melons    | MEL       |
      | Chocolate | CHO       |
    And that the following pcvs exist:
      | name      | pcv_id | country   |
      | bill      | 1      | Quirm     |
      | ted       | 2      | Quirm     |
      | jennie    | 3      | Quirm     |
      | tink      | 4      | Neverland |
    And that the following orders have been made
      | pcv | supply |
      | 1   | BAC    |
      | 1   | GEC    |
      | 2   | BAC    |
      | 2   | MEL    |
      | 3   | BAC    |
      | 3   | CHO    |
      | 4   | GEC    |

  Scenario: Check stuff on PCMO Response page
    Given I am logged in as the pcmo of Quirm
    And I go to the response page
    Then I should see non-pcv gear area items
    Then I should see std icon area items

    Then I should see header with text "Fulfillment Method"
    Then I should see radiobutton "Delivery"
    Then I should see radiobutton "Pickup"
    Then I should see radiobutton "Purchase & Reimburse"
    Then I should see radiobutton "Special Instructions"

    Then I should see div with text "Edit Default SMS"
    Then I should see div with text "characters remaining"
    Then I should see field "response_instructions"
    Then I should see the button "Send Response"

  Scenario: Check stuff on Admin Response pages
    Given I am logged in as the pcmo of Quirm
    And I am a "admin"
    And I go to the response page
    Then I should see non-pcv gear area items
    Then I should see std icon area items
    Then I should see admin tab area items

    Then I should see header with text "Fulfillment Method"
    Then I should see radiobutton "Delivery"
    Then I should see radiobutton "Pickup"
    Then I should see radiobutton "Purchase & Reimburse"
    Then I should see radiobutton "Special Instructions"
    Then I should see radiobutton "Denial"

    Then I should see div with text "Edit Default SMS"
    Then I should see div with text "characters remaining"
    Then I should see field "response_instructions"
    Then I should see the button "Send Response"
