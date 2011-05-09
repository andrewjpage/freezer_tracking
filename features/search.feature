@search
Feature: Search for assets

  Background:
    Given building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And asset "123456" is contained in storage area "Shelf1"
      And storage area "Shelf1" has a barcode of "333"
      And asset "987654" with location "A1" is contained in asset "123456"

    Given building area "AnotherRoom" exists
      And freezer "AnotherFreezer" is contained in building area "AnotherRoom"
      And storage area "AnotherShelf" is contained in freezer "AnotherFreezer"
      And asset "asset_2" is contained in storage area "AnotherShelf"
      And storage area "AnotherShelf" has a barcode of "444"
      And asset "sub_asset_3" with location "H12" is contained in asset "asset_2"

    Given I am on the homepage

  Scenario Outline: Search by using box on every page for a barcode and view the results as a report
    When I fill in "Search query" with "<search_query>"
      And I press "Search"
    Then the list of assets should be:
      | Name   | Container | Storage area | Freezer    | Building area | Number of assets contained | Map |
      | 123456 |           | Shelf1       | Freezer456 | Room123       | 1                          |     |
      | 987654 | 123456    | Shelf1       | Freezer456 | Room123       | 0                          | A1  |
    When I follow "Download asset details"
    Then I should see the asset report:
      | Name   | Container | Storage area | Freezer    | Building area | Number of assets contained | Map |
      | 123456 |           | Shelf1       | Freezer456 | Room123       | 1                          |     |
      | 987654 | 123456    | Shelf1       | Freezer456 | Room123       | 0                          | A1  |
    Examples:
      | search_query |
      | 333          |
      | 123456       |

  Scenario: Advanced search with multiple keywords and view the results as a report
    When I follow "Advanced Search"
      And I fill in "Search query" with "987654 sub_asset_3"
    Then the list of assets should be:
      | Name        | Container | Storage area | Freezer        | Building area | Number of assets contained | Map |
      | 987654      | 123456    | Shelf1       | Freezer456     | Room123       | 0                          | A1  |
      | sub_asset_3 | asset_2   | AnotherShelf | AnotherFreezer | AnotherRoom   | 0                          | H12 |
    When I follow "Download asset details"
    Then I should see the asset report:
      | Name        | Container | Storage area | Freezer        | Building area | Number of assets contained | Map |
      | 987654      | 123456    | Shelf1       | Freezer456     | Room123       | 0                          | A1  |
      | sub_asset_3 | asset_2   | AnotherShelf | AnotherFreezer | AnotherRoom   | 0                          | H12 |

  Scenario: No results found
    When I fill in "Search query" with "query_with_no_results"
      And I press "Search"
    Then I should see "No results found"
    Then the list of assets should be:
      | Name   | Container | Storage area | Freezer    | Building area | Number of assets contained | Map |
