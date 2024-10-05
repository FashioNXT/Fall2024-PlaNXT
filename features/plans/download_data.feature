@javascript

Feature: Download Floor Plan as CSV
    As a PlanXT user,
    So that I can easily interpret and utilize the floorplan setups outside the application,
    I want the downloaded data from my saved floorplans to be presented in a more readable format, ensuring layout configurations are clearly depicted

  Scenario: Downloading a CSV file of floor plan data
    Given I am on the Floor Plan 2D page
    When I click the "Save" link
    Then I should receive a downloaded CSV file