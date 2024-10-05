Feature: Testing the navigation

  Scenario: Testing the navigation to plan page
    Given I am on the "home" page
    When I click on the "Get Started" button
    Then I should be on the "plans" page