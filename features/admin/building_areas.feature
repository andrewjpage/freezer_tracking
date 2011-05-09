@building_area
Feature: Admin the building areas

  Background:
    Given I am logged in as an administrator
      And I am on the admin homepage
  
  Scenario:  Add a building area
    When I follow "Manage building areas"
    Then the list of building areas should be:
      | Name | Number of freezers | Edit | Delete| 
    When I follow "New building area"
      And I fill in "Name" with "Room123"
      And I press "Create building area"
    Then I should see "Created building area"
    Then the list of building areas should be:
      | Name    | Number of freezers | 
      | Room123 | 0                  | 
    
   @error
  Scenario:  Building area needs a name when being created
    When I follow "Manage building areas"
    Then the list of building areas should be:
      | Name | Number of freezers | Edit | Delete| 
    When I follow "New building area"
      And I fill in "Name" with ""
      And I press "Create building area"
    Then I should see "Name must be provided"
    Then the list of building areas should be:
      | Name    | Number of freezers | 
    
   @error
  Scenario:  Building area name must be unique
    Given building area "Room123" exists
    When I follow "Manage building areas"
    Then the list of building areas should be:
      | Name    | Number of freezers | 
      | Room123 | 0                  | 
    When I follow "New building area"
      And I fill in "Name" with "Room123"
      And I press "Create building area"
    Then I should see "Name must be unique"
    Then the list of building areas should be:
      | Name    | Number of freezers | 
      | Room123 | 0                  | 
    
  
  Scenario: Edit a building area
    Given building area "Room123" exists
    When I follow "Manage building areas"
    Then the list of building areas should be:
      | Name    | Number of freezers | 
      | Room123 | 0                  | 
    When I follow "Edit Room123"
      And I fill in "Name" with "Lab987"
    Then I should see "Updated building area"
    When I follow "Back to index"
    Then the list of building areas should be:
      | Name   | Number of freezers | 
      | Lab987 | 0                  | 

  
  Scenario: Delete a building area
    Given building area "Room123" exists
    When I follow "Manage building areas"
    Then the list of building areas should be:
      | Name    | Number of freezers | Edit         | Delete         |
      | Room123 | 0                  | Edit Room123 | Delete Room123 |
    When I follow "Delete Room123"
    Then I should see "Deleted building area"
    Then the list of building areas should be:
      | Name    | Number of freezers | Edit         | Delete         |

   @error
  Scenario: Delete a building area that has freezers contained within it shouldnt be allowed
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
    When I follow "Manage building areas"
    Then the list of building areas should be:
      | Name    | Number of freezers | 
      | Room123 | 1                  | 
    When I follow "Delete Room123"
    Then I should see "Cannot delete because freezers still linked to this building area"
    Then the list of building areas should be:
      | Name    | Number of freezers | 
      | Room123 | 1                  | 
