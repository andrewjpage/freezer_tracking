@browse
Feature: Browser contents building areas, freezers, and storage areas

  Background:
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And asset "123456" is contained in storage area "Shelf1"
      And asset "987654" with location "A1" is contained in asset "123456"
      
    Given building area "AnotherRoom" exists
      And freezer "AnotherFreezer" is contained in building area "AnotherRoom"
      And storage area "AnotherShelf" is contained in freezer "AnotherFreezer"
      And asset "asset_2" is contained in storage area "AnotherShelf"
      And asset "sub_asset_3" with location "H12" is contained in asset "asset_2"
      
      And I am on the homepage
      
  @building_area
  Scenario: View all building areas
    When I follow "Building areas"
    Then the list of building areas should be:
      | Name        | Number of freezers |
      | AnotherRoom | 1                  |
      | Room123     | 1                  |
  
  @freezer
  Scenario: View all freezers
    When I follow "Freezers"
    Then the list of freezers should be:
      | Name           | Building area | Number of storage areas |
      | AnotherFreezer | AnotherRoom   | 1                       |
      | Freezer456     | Room123       | 1                       |

  @freezer @building_area
  Scenario: View all freezers within a building area
    When I follow "Building areas"
    Then the list of building areas should be:
      | Name        | Number of freezers |
      | AnotherRoom | 1                  |
      | Room123     | 1                  |
    When I follow "Room123"
    Then the list of freezers should be:
      | Name       | Building area | Number of storage areas |
      | Freezer456 | Room123       | 1                       |
  
  @storage_area
  Scenario: View all storage areas
    When I follow "Storage areas"
    Then the list of storage areas should be:
      | Name         | Freezer        | Building area | Number of assets |
      | AnotherShelf | AnotherFreezer | AnotherRoom   | 1                |
      | Shelf1       | Freezer456     | Room123       | 1                |
  
  @storage_area @freezer
  Scenario: View all storage areas within a freezer
    When I follow "Freezers"
    Then the list of freezers should be:
      | Name           | Building area | Number of storage areas |
      | AnotherFreezer | AnotherRoom   | 1                       |
      | Freezer456     | Room123       | 1                       |
    When I follow "Freezer456"
    Then the list of storage areas should be:
      | Name   | Freezer    | Building area | Number of assets |
      | Shelf1 | Freezer456 | Room123       | 1                |
  
  @storage_area @asset
  Scenario: View all assets within a storage area
    When I follow "Storage areas"
    Then the list of storage areas should be:
      | Name         | Freezer        | Building area | Number of assets |
      | AnotherShelf | AnotherFreezer | AnotherRoom   | 1                |
      | Shelf1       | Freezer456     | Room123       | 1                |
    When I follow "Shelf1"
    Then the list of assets should be:
      | Barcode | Storage area | Freezer    | Building area | Number of contained assets |
      | 123456  | Shelf1       | Freezer456 | Room123       | 1                          |
  
  @storage_area @asset @rack
  Scenario: View all assets within a asset (tubes within a rack)
    When I follow "Storage areas"
    Then the list of storage areas should be:
      | Name         | Freezer        | Building area | Number of assets |
      | AnotherShelf | AnotherFreezer | AnotherRoom   | 1                |
      | Shelf1       | Freezer456     | Room123       | 1                |
    When I follow "Shelf1"
    Then the list of assets should be:
      | Barcode | Storage area | Freezer    | Building area | Number of contained assets | Map |
      | 123456  | Shelf1       | Freezer456 | Room123       | 1                          |     |
    When I follow "123456"
    Then the list of assets should be:
      | Barcode | Container | Number of contained assets | Map |
      | 987654  | 123456    | 0                          | A1  |
  
  @asset_report @building_area
  Scenario: Report with list of all assets within building area
    When I follow "Building areas"
      And I follow "Room123"
      And I follow "Download asset details"
    Then I should see the asset report:
      | Barcode |  Storage area | Freezer    | Building area | Number of contained assets | 
      | 123456  |  Shelf1       | Freezer456 | Room123       | 1                          | 

  
  @asset_report @freezer
  Scenario: Report with list of all assets within freezer
    When I follow "Freezers"
      And I follow "Freezer456"
      And I follow "Download asset details"
    Then I should see the asset report:
      | Barcode |  Storage area | Freezer    | Building area | Number of contained assets | 
      | 123456  |  Shelf1       | Freezer456 | Room123       | 1                          | 
  
  @asset_report @storage_area
  Scenario: Report with list of all assets within storage area
    When I follow "Storage areas"
      And I follow "Shelf1"
      And I follow "Download asset details"
    Then I should see the asset report:
      | Barcode |  Storage area | Freezer    | Building area | Number of contained assets | 
      | 123456  |  Shelf1       | Freezer456 | Room123       | 1                          | 
  
  @asset_report @rack @asset
  Scenario: Report with list of all assets within container
    When I follow "Storage areas"
      And I follow "Shelf1"
      And I follow "123456"
      And I follow "Download asset details"
    Then I should see the asset report:
      | Barcode | Container |  Number of contained assets | Map |
      | 987654  | 123456    |  0                          | A1  |

  