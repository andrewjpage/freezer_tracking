Feature: Admin storage areas

  Background:
    Given I am logged in as an administrator
      And I am on the admin homepage

  Scenario:  Add a storage area
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
    When I follow "Manage storage areas"
    Then the list of storage areas should be:
      | Name | Freezer | Building area | Number of assets | Edit | Delete |
    When I follow "New storage area"
      And I fill in "Name" with "Shelf1"
      And I fill in "Barcode" with "12345"
      And I select "Freezer456" from "Freezer"
      And I press "Create storage area"
    Then I should see "Created storage area"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 0                |

   @error
  Scenario:  Add a storage area where the barcode has been taken already
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And storage area "Shelf1" has a barcode of "12345"
    When I follow "Manage storage areas"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 0                |
    When I follow "New storage area"
      And I fill in "Name" with "Shelf2"
      And I fill in "Barcode" with "12345"
      And I select "Freezer456" from "Freezer"
      And I press "Create storage area"
    Then I should see "Barcode must be unique"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 0                |

  @error
  Scenario:  A storage area name must be unique to the freezer
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And freezer "AnotherFreezer" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And storage area "Shelf1" has a barcode of "12345"
    When I follow "Manage storage areas"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 0                |
    When I follow "New storage area"
      And I fill in "Name" with "Shelf1"
      And I fill in "Barcode" with "98765"
      And I select "Freezer456" from "Freezer"
      And I press "Create storage area"
    Then I should see "Name must be unique to the freezer"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 0                |
    When I follow "New storage area"
      And I fill in "Name" with "Shelf1"
      And I fill in "Barcode" with "98765"
      And I select "AnotherFreezer" from "Freezer"
      And I press "Create storage area"
    Then I should see "Created storage area"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer        | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456     | Room123       | 0                |
      | Shelf1 | 98765   | AnotherFreezer | Room123       | 0                |

  @error
  Scenario:  A storage area needs a barcode when its created but none is provided
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
    When I follow "Manage storage areas"
    Then the list of storage areas should be:
      | Name | Freezer | Building area | Number of assets | Edit | Delete |
    When I follow "New storage area"
      And I fill in "Name" with "Shelf1"
      And I select "Freezer456" from "Freezer"
      And I press "Create storage area"
    Then I should see "Barcode must be provided"
    Then the list of storage areas should be:
      | Name | Freezer | Building area | Number of assets | Edit | Delete |

  Scenario: Edit storage area
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And freezer "AnotherFreezer" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And storage area "Shelf1" has a barcode of "12345"
    When I follow "Manage storage areas"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 0                |
    When I follow "Edit Shelf1"
      And I fill in "Name" with "Shelf2"
      And I fill in "Barcode" with "98765"
      And I select "Freezer456" from "Freezer"
      And I press "Update storage area"
    Then I should see "Updated storage area"
    When I follow "Back to index"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer        | Building area | Number of assets |
      | Shelf2 | 98765   | AnotherFreezer | Room123       | 0                |

  Scenario: Delete storage area
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
    When I follow "Manage storage areas"
    Then the list of storage areas should be:
      | Name   |  Freezer    | Building area | Number of assets |
      | Shelf1 |  Freezer456 | Room123       | 0                |
    When I follow "Delete Shelf1"
    Then I should see "Deleted storage area"
    Then the list of storage areas should be:
      | Name   | Freezer    | Building area | Number of assets |

  @error
  Scenario: Delete a storage area that has assets contained within it shouldnt be allowed
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And asset "123456" is contained in storage area "Shelf1"
    When I follow "Manage storage areas"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 1                |
    When I follow "Delete Shelf1"
    Then I should see "Cannot delete because assets still linked to this storage area"
    Then the list of storage areas should be:
      | Name   | Barcode | Freezer    | Building area | Number of assets |
      | Shelf1 | 12345   | Freezer456 | Room123       | 1                |
