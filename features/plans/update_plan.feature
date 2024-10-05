@javascript 
Feature: Update a new plan

Background:
Given I am on the "home" page
When I click on the "Get Started" button
Then I should be on the "plans" page
Given the following plans exist:
    | name        | owner   | venue_length     | venue_width |
    | My Plan     | test@email.com    | 10               | 10          |
    | My Plan 2   | test@email.com    | 20               | 20          |

    Scenario: Update an existed plan
        Given I am on the "plans" page
        Then I click on the button with "edit" icon for the plan "My Plan" to enter the "edit" page
        When I fill in "Plan Name" with "My Plan - Updated"
        And I fill in "Venue Length" with 20
        And I fill in "Venue Width" with 20
        And I click on the "Update" button
        Then I should be on the "plans" page
        And I should see the name being updated to "My Plan - Updated" in the list of plans

    Scenario: Add steps to the existed plan
        Given I am on the "plans" page
        Then I click on the button with "edit" icon for the plan "My Plan" to enter the "edit" page
        When I click on the "Add Step" button
        Then I should see a template of step being added
        When I set "start_date" with "2016-01-01"
        And I set "start_time" with "10:00"
        And I set "end_time" with "11:00"
        And I set "break1_start_time" with "12:00"
        And I set "break1_end_time" with "13:00"
        And I set "break2_start_time" with "14:00"
        And I set "break2_end_time" with "15:00"
        And I click on the "Update" button
        Then I should be on the "plans" page
        And I should see "My Plan" to have 1 step(s)

        