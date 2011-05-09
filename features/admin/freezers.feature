@freezer
Feature: Admin the freezers

  Background:
    Given I am logged in as an administrator
      And I am on the admin homepage
    
  Scenario:  Add a freezer
    Given building area "Room123" exists
    When I follow "Manage freezers"
    Then the list of freezers should be:
      | Name | Building area | Number of storage areas | Edit | Delete|
    When I follow "New freezer"
      And I fill in "Name" with "Freezer456"
      And I select "Room123" from "Building area"
      And I press "Create freezer"
    Then I should see "Created freezer"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas | 
      | Freezer456 | Room123       | 0                       | 
      
  @error 
  Scenario:  A freezer name must be provided
    Given building area "Room123" exists
    When I follow "Manage freezers"
    Then the list of freezers should be:
      | Name | Building area | Number of storage areas | Edit | Delete|
    When I follow "New freezer"
      And I select "Room123" from "Building area"
      And I press "Create freezer"
    Then I should see "Name must be provided"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas | Edit            | Delete            |
  
  @error
  Scenario:  A freezer name must be unique to the building area its in
    Given building area "Room123" exists
      And building area "Lab987" exists
      And freezer "Freezer456" is contained in building area "Room123"
    When I follow "Manage freezers"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas |
      | Freezer456 | Room123       | 0                       |
    When I follow "New freezer"
      And I fill in "Name" with "Freezer456"
      And I select "Room123" from "Building area"
      And I press "Create freezer"
    Then I should see "Name must be unique to building area"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas |
      | Freezer456 | Room123       | 0                       |
    When I follow "New freezer"
      And I fill in "Name" with "Freezer456"
      And I select "Lab987" from "Building area"
      And I press "Create freezer"
    Then I should see "Created freezer"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas |
      | Freezer456 | Room123       | 0                       |
      | Freezer456 | Lab987        | 0                       |
      
  
  Scenario: Edit a freezer
    Given building area "Room123" exists
      And building area "Lab987" exists
      And freezer "Freezer456" is contained in building area "Room123"
    When I follow "Manage freezers"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas |
      | Freezer456 | Room123       | 0                       |
    When I follow "Edit Freezer456"
      And I fill in "Name" with "NewFreezerName"
      And I select "Lab987" from "Building area"
      And I press "Update freezer"
    Then I should see "Updated freezer"
    When I follow "Back to index"
    Then the list of freezers should be:
      | Name           | Building area | Number of storage areas |
      | NewFreezerName | Lab987        | 0                       |
  
  Scenario: Delete a freezer
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
    When I follow "Manage freezers"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas |
      | Freezer456 | Room123       | 0                       |
    When I follow "Delete Freezer456"
    Then I should see "Deleted freezer"
    Then the list of freezers should be:
      | Name | Building area | Number of storage areas | Edit | Delete |
  
  @error
  Scenario: Delete a freezer that has storage areas contained within it shouldnt be allowed
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
    When I follow "Manage freezers"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas | 
      | Freezer456 | Room123       | 1                       | 
    When I follow "Delete Freezer456"
    Then I should see "Cannot delete because storage areas still linked to this freezer"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas |
      | Freezer456 | Room123       | 1                       |
