@reception @user_barcode_service
Feature: Scan assets in and out of freezers

  Background:
    Given all of this is happening at exactly "10-May-2011 11:00:00+00:00"
    Given user "john" with barcode '888' exists
      And building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And storage area "Shelf2" is contained in freezer "Freezer456"
      And storage area "Shelf1" has a barcode of "111"
      And I am on the homepage

  @check_in
  Scenario: Check in 1 asset into freezer
    Given an asset with barcode "555" exists
    When I fill in "User Barcode" with "888"
      And I fill in "Storage Area Barcode" with "111"
      And I fill in "Asset Barcodes" with "555"
      And I press "Submit"
    Then I should see "Updated assets"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Storage area | Freezer    | Building area | User | Action    | Date         |
      | 555     |              |            |               |      | Check out | 10 May 11:00 |
      | 555     | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 |

  @check_in
  Scenario: Check in multiple assets into freezer
    Given an asset with barcode "555" exists
      And an asset with barcode "666" exists
      And an asset with barcode "777" exists
    When I fill in "User Barcode" with "888"
      And I fill in "Storage Area Barcode" with "111"
      And I fill in "Asset Barcodes" with "555 777 666"
      And I press "Submit"
    Then I should see "Updated assets"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Storage area | Freezer    | Building area | User | Action    | Date         |
      | 555     |              |            |               |      | Check out | 10 May 11:00 |
      | 666     |              |            |               |      | Check out | 10 May 11:00 |
      | 777     |              |            |               |      | Check out | 10 May 11:00 |
      | 555     | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 |
      | 777     | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 |
      | 666     | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 |


  @check_in
  Scenario: Check in asset which is already checked in somewhere
    Given an asset with barcode "555" exists
      And asset "555" is checked into "Shelf2"
    When I fill in "User Barcode" with "888"
      And I fill in "Storage Area Barcode" with "111"
      And I fill in "Asset Barcodes" with "555"
      And I press "Submit"
    Then I should see "Updated assets"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Storage area | Freezer    | Building area | User | Action    | Date         |
      | 555     |              |            |               |      | Check out | 10 May 11:00 |
      | 555     | Shelf2       | Freezer456 | Room123       |      | Check in  | 10 May 11:00 |
      | 555     | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 |

  @check_in
  Scenario: Previously unknown asset barcode should be created automatically
    When I fill in "User Barcode" with "888"
      And I fill in "Storage Area Barcode" with "111"
      And I fill in "Asset Barcodes" with "brand_new_asset"
      And I press "Submit"
    Then I should see "Updated assets"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode         | Storage area | Freezer    | Building area | User | Action    | Date         |
      | brand_new_asset |              |            |               |      | Check out | 10 May 11:00 |
      | brand_new_asset | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 |

  @error
  Scenario Outline: User barcode invalid
    Given an asset with barcode "555" exists
    When I fill in "User Barcode" with "<user_barcode>"
      And I fill in "Storage Area Barcode" with "111"
      And I fill in "Asset Barcodes" with "555"
      And I press "Submit"
    Then I should see "User barcode must be valid"
    Examples:
      | user_barcode         |
      |                      |
      | non_existant_barcode |

  @error
  Scenario: Storage area barcode doesnt exist
    Given an asset with barcode "555" exists
    When I fill in "User Barcode" with "888"
      And I fill in "Storage Area Barcode" with "non_existant_barcode"
      And I fill in "Asset Barcodes" with "555"
      And I press "Submit"
    Then I should see "Storage area barcode must be valid"

  @error
  Scenario: Asset barcodes blank
    When I fill in "User Barcode" with "888"
      And I fill in "Storage Area Barcode" with "111"
      And I fill in "Asset Barcodes" with ""
      And I press "Submit"
    Then I should see "Asset barcodes can't be blank"

  @check_out
  Scenario: Check out 1 asset from freezer
    Given an asset with barcode "555" exists
      And asset "555" is checked into "Shelf1"
    When I fill in "User Barcode" with "888"
      And I fill in "Asset Barcodes" with "555"
      And I press "Submit"
    Then I should see "Updated assets"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Storage area | Freezer    | Building area | User | Action    | Date         |
      | 555     |              |            |               |      | Check out | 10 May 11:00 |
      | 555     | Shelf1       | Freezer456 | Room123       |      | Check in  | 10 May 11:00 |
      | 555     |              |            |               | john | Check out | 10 May 11:00 |

  @check_out
  Scenario: Check out multiple assets where 1 doesnt exist
    Given an asset with barcode "555" exists
    When I fill in "User Barcode" with "888"
      And I fill in "Asset Barcodes" with "555 666"
      And I press "Submit"
    Then I should see "Updated assets"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Storage area | Freezer | Building area | User | Action    | Date         |
      | 555     |              |         |               |      | Check out | 10 May 11:00 |
      | 666     |              |         |               |      | Check out | 10 May 11:00 |
      | 555     |              |         |               | john | Check out | 10 May 11:00 |
      | 666     |              |         |               | john | Check out | 10 May 11:00 |
                                                                                               
  @check_out
  Scenario: Check out where some assets arent checked in already
    Given an asset with barcode "555" exists
      And asset "555" is checked into "Shelf1"
      And an asset with barcode "666" exists
    When I fill in "User Barcode" with "888"
      And I fill in "Asset Barcodes" with "555 666"
      And I press "Submit"
    Then I should see "Updated assets"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Storage area | Freezer    | Building area | User | Action    | Date         |
      | 555     |              |            |               |      | Check out | 10 May 11:00 |
      | 555     | Shelf1       | Freezer456 | Room123       |      | Check in  | 10 May 11:00 |
      | 666     |              |            |               |      | Check out | 10 May 11:00 |
      | 555     |              |            |               | john | Check out | 10 May 11:00 |
      | 666     |              |            |               | john | Check out | 10 May 11:00 |

