@search
Feature: Search for assets

  Background:
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And asset "4360133339849" is contained in storage area "Shelf1"
      And storage area "Shelf1" has a barcode of "333"
      And asset "987654" with location "A1" is contained in asset "4360133339849"

    Given building area "AnotherRoom" exists
      And freezer "AnotherFreezer" is contained in building area "AnotherRoom"
      And storage area "AnotherShelf" is contained in freezer "AnotherFreezer"
      And asset "asset_2" is contained in storage area "AnotherShelf"
      And storage area "AnotherShelf" has a barcode of "444"
      And asset "sub_asset_3" with location "H12" is contained in asset "asset_2"

    Given I am on the homepage

  @asset
  Scenario Outline: Search by using box on every page for an asset barcode and view the results as a report
    When I fill in "Search query" with "<search_query>"
      And I press "Search"
    Then the list of assets should be:
      | Barcode       | Decoded Barcode Number | Container | Storage area | Freezer    | Building area | Number of contained assets | Map |
      | 4360133339849 | 133339                 |           | Shelf1       | Freezer456 | Room123       | 1                          |     |
    Examples:
      | search_query  |
      | 4360133339849 |
      | 133339        |
      
  @storage_area
  Scenario Outline: Search for a storage area
    When I fill in "Search query" with "<search_query>"
      And I press "Search"
    Then the list of storage areas should be:
      | Name         | Freezer    | Building area |
      | Shelf1       | Freezer456 | Room123       |
    Examples:
      | search_query |
      | Shelf1       |
      | 333          |
  
  @freezer
  Scenario: Search for a freezer
    When I fill in "Search query" with "Freezer456"
      And I press "Search"
    Then the list of freezers should be:
      | Name       | Building area |
      | Freezer456 | Room123       |
      
  @building_area
  Scenario: Search for a building area
    When I fill in "Search query" with "Room123"
      And I press "Search"
    Then the list of building areas should be:
      | Name    |
      | Room123 |

  Scenario: Advanced search with multiple keywords and view the results as a report
    When I follow "Advanced Search"
      And I fill in "Search query" with "987654 sub_asset_3"
      And I press "Search"
    Then the list of assets should be:
      | Barcode     | Container     | Storage area | Freezer | Building area | Number of contained assets | Map |
      | 987654      | 4360133339849 |              |         |               | 0                          | A1  |
      | sub_asset_3 | asset_2       |              |         |               | 0                          | H12 |

  Scenario: No results found
    When I fill in "Search query" with "query_with_no_results"
      And I press "Search"
    Then I should see "No results found"
