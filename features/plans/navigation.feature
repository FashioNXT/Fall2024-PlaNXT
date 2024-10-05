@javascript

Feature: Navigate to different pages

Background:
Given I am on the "home" page
When I click on the "Get Started" button
Then I should be on the "plans" page


Given the following plans exist:
    | name        | owner   | venue_length     | venue_width |
    | My Plan     | test@email.com    | 10               | 10          |
    | My Plan 2   | test@email.com     | 20               | 20          |

    Scenario: Navigate to home page
        Given I am on the "plans" page
        When I click on the "Logout" button
        Then I should be on the Event360 user page

    Scenario: Navigate to create new plan page
        Given I am on the "plans" page
        When I click on the "Create a new plan" button
        Then I should be on the "new plan" page
    
    Scenario: Navigate to "edit floorplans 2d" page
        Given I am on the "plans" page
        Then I click on the button with "play" icon for the plan "My Plan" to enter the "edit floorplans 2d" page
