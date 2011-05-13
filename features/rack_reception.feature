@rack @user_barcode_service
Feature: Check rack layouts in and out

  Background:
    Given all of this is happening at exactly "10-May-2011 11:00:00+01:00"
      And user "john" with barcode '888' exists
      And building area "Room123" exists
      And freezer "Freezer456" is contained in building area "Room123"
      And storage area "Shelf1" is contained in freezer "Freezer456"
      And asset "123456" is contained in storage area "Shelf1"
      And I am on the rack reception page

  @check_in
  Scenario: Check in the layout of assets within a rack where the contained assets dont exist
    When I fill in "User Barcode" with "888"
      And I fill in "Rack Barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    Then I should see "Uploaded rack"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Container | Storage area | Freezer    | Building area | User | Action    | Date         | Map |
      | 123456  |           | Shelf1       | Freezer456 | Room123       |      | Check in  | 10 May 10:00 |     |
      | 555     |           |              |            |               |      | Check out | 10 May 10:00 |     |
      | 555     | 123456    |              |            |               | john | Check in  | 10 May 10:00 | A01 |
      | 666     |           |              |            |               |      | Check out | 10 May 10:00 |     |
      | 666     | 123456    |              |            |               | john | Check in  | 10 May 10:00 | B02 |
      | 777     |           |              |            |               |      | Check out | 10 May 10:00 |     |
      | 777     | 123456    |              |            |               | john | Check in  | 10 May 10:00 | H12 |

  @error
  Scenario Outline: User barcode invalid
    When I fill in "User Barcode" with "<user_barcode>"
      And I fill in "Rack Barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    Then I should see "User barcode must be valid"
    Examples:
      | user_barcode         |
      |                      |
      | non_existant_barcode |

  @error
  Scenario: Rack Barcode not provided
    When I fill in "User Barcode" with "888"
      And I attach the file "test/data/valid_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    Then I should see "Rack barcode can't be blank"

  @error
  Scenario: No layout file provided
    When I fill in "User Barcode" with "888"
      And I fill in "Rack Barcode" with "123456"
      And I press "Submit"
    Then I should see "Rack layout file can't be blank"

  @error
  Scenario: Invalid layout file format
    When I fill in "User Barcode" with "888"
      And I fill in "Rack Barcode" with "123456"
      And I attach the file "test/data/invalid_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    Then I should see "Uploaded file must be a valid format"

  @check_in @warning
  Scenario: Some tubes are already scanned into a different rack so flag rack as dirty
    Given asset "another_rack" is contained in storage area "Shelf1"
      And asset "555" with location "C12" is contained in asset "another_rack"
    When I fill in "User Barcode" with "888"
      And I fill in "Rack Barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    When I follow "Racks that need to be rescanned"
    Then the list of dirty racks should be:
      | Barcode      | Storage area | Freezer    | Building area |
      | another_rack | Shelf1       | Freezer456 | Room123       |
    Given I am on the homepage
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode      | Container    | User | Action    | Map |
      | 123456       |              |      | Check in  |     |
      | another_rack |              |      | Check in  |     |
      | 555          | another_rack |      | Check in  | C12 |
      | another_rack |              |      | Check in  |     |
      | 555          | 123456       | john | Check in  | A01 |
      | 666          |              |      | Check out |     |
      | 666          | 123456       | john | Check in  | B02 |
      | 777          |              |      | Check out |     |
      | 777          | 123456       | john | Check in  | H12 |

  Scenario: Overwrite pre-existing tube locations with rearray on same rack
    When I fill in "User Barcode" with "888"
      And I fill in "Rack Barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    Then I should see "Uploaded rack"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Map | Container | Storage area | Freezer    | Building area | User    | Action    | Date         |
      | 123456  |     |           | Shelf1       | Freezer456 | Room123       |         | Check in  | 10 May 10:00 |
      | 555     |     |           |              |            |               |         | Check out | 10 May 10:00 |
      | 555     | A01 | 123456    |              |            |               | john    | Check in  | 10 May 10:00 |
      | 666     |     |           |              |            |               |         | Check out | 10 May 10:00 |
      | 666     | B02 | 123456    |              |            |               | john    | Check in  | 10 May 10:00 |
      | 777     |     |           |              |            |               |         | Check out | 10 May 10:00 |
      | 777     | H12 | 123456    |              |            |               | john    | Check in  | 10 May 10:00 |
    Given I am on the rack reception page
    When I fill in "User Barcode" with "888"
      And I fill in "Rack Barcode" with "123456"
      And I attach the file "test/data/valid_rearray_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Map | Container | Storage area | Freezer    | Building area | User | Action    | Date         |
      | 123456  |     |           | Shelf1       | Freezer456 | Room123       |      | Check in  | 10 May 10:00 |
      | 555     |     |           |              |            |               |      | Check out | 10 May 10:00 |
      | 555     | A01 | 123456    |              |            |               | john | Check in  | 10 May 10:00 |
      | 666     |     |           |              |            |               |      | Check out | 10 May 10:00 |
      | 666     | B02 | 123456    |              |            |               | john | Check in  | 10 May 10:00 |
      | 777     |     |           |              |            |               |      | Check out | 10 May 10:00 |
      | 777     | H12 | 123456    |              |            |               | john | Check in  | 10 May 10:00 |
      | 777     | A01 | 123456    |              |            |               | john | Check in  | 10 May 10:00 |
      | 555     | B02 | 123456    |              |            |               | john | Check in  | 10 May 10:00 |
      | 666     | H12 | 123456    |              |            |               | john | Check in  | 10 May 10:00 |

  @ap13
  Scenario: Rescan a rack and it should disappear from dirty list
    Given rack "123456" is flagged as dirty
    When I follow "Racks that need to be rescanned"
    Then the list of dirty racks should be:
      | Barcode | Storage area | Freezer    | Building area |
      | 123456  | Shelf1       | Freezer456 | Room123       |
    Given I am on the rack reception page
    When I fill in "User Barcode" with "888"
      And I fill in "Rack Barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "reception_rack_layout_file"
      And I press "Submit"
    Then I should see "Uploaded rack"
    When I follow "Racks that need to be rescanned"
    Then the list of dirty racks should be:
      | Barcode | Storage area | Freezer    | Building area |

