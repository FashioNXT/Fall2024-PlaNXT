@drag_and_drop
@javascript
Feature: Drag and Drop items to the canvas

Background:
Given I am on the "home" page
When I click on the "Get Started" button
Then I should be on the "plans" page
Given the following plans exist:
    | name        | owner   | venue_length     | venue_width |
    | My Plan     | test@email.com    | 100               | 100         |
When I add a step for "My Plan" with the following details:
| start_date | start_time       | end_time         |
| 2021-04-01 | 2021-04-01 10:00 | 2021-04-01 11:00 |
    
    Scenario: Testing the drag and drop functionality and show the item in the table
    Given I am on the "plans" page
    Then I click on the button with "play" icon for the plan "My Plan" to enter the "edit floorplans 2d" page
    Then It should load all the items in the floorplans 2d page
    When I click on the "Furniture Layer" Accordion
    Then I should see the "FurnitureLayer" Accordion expand
    # When I drag "Chair" from the "Furniture Layer" Accordion and drop at x=0, y=0 on the canvas
    # Then I should see the item "Chair" appear on the canvas at x=0, y=0
    # And I should see the item "Chair" appear in the table
        
    