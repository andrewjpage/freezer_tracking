@rack
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
      And I fill in "Rack barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "Uploaded rack"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Container| Storage area | Freezer    | Building area | User | Action   | Date         | Map |
      | 555   | 123456   | Shelf1       | Freezer456 | Room123       | john | Check in | 10 May 11:00 | A1  |
      | 666   | 123456   | Shelf1       | Freezer456 | Room123       | john | Check in | 10 May 11:00 | B2  |
      | 777   | 123456   | Shelf1       | Freezer456 | Room123       | john | Check in | 10 May 11:00 | H12 |
    
  @error
  Scenario Outline: User barcode invalid
    When I fill in "User Barcode" with "<user_barcode>"
      And I fill in "Rack barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "User barcode must be provided"
    Examples:
      | user_barcode         |
      |                      |
      | non_existant_barcode |
      
  @error
  Scenario: Rack barcode not provided
    When I fill in "User Barcode" with "888"
      And I attach the file "test/data/valid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "Rack barcode must be provided"

  @error
  Scenario: No layout file provided
    When I fill in "User Barcode" with "888"
      And I fill in "Rack barcode" with "123456"
      And I press "Submit"
    Then I should see "Layout file required"
  
  @error
  Scenario: Invalid layout file format
    When I fill in "User Barcode" with "888"
      And I fill in "Rack barcode" with "123456"
      And I attach the file "test/data/invalid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "Invalid layout file"
  
  @check_in @warning
  Scenario: Some tubes are already scanned into a different rack so flag rack as dirty
    Given asset "another_rack" is contained in storage area "Shelf1"
      And asset "555" with location "A1" is contained in asset "another_rack"
    When I fill in "User Barcode" with "888"
      And I fill in "Rack barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "Uploaded rack but other racks need to be scanned"
      And I should see "Racks which need to have layout rescanned"
    Then the list of dirty racks should be:
      | Container    | Storage area | Freezer    | Building area |
      | another_rack | Shelf1       | Freezer456 | Room123       |
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Container| Storage area | Freezer    | Building area | User | Action   | Date         | Map |
      | 555   | 123456   | Shelf1       | Freezer456 | Room123       | john | Check in | 10 May 11:00 | A1  |
      | 666   | 123456   | Shelf1       | Freezer456 | Room123       | john | Check in | 10 May 11:00 | B2  |
      | 777   | 123456   | Shelf1       | Freezer456 | Room123       | john | Check in | 10 May 11:00 | H12 |
      
  @check_in @warning   
  Scenario: Check in the layout of assets within a rack where the rack isnt scanned into a storage area
    When I fill in "User Barcode" with "888"
      And I fill in "Rack barcode" with "987"
      And I attach the file "test/data/valid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "Uploaded rack but rack is not checked into a storage area"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Container | Storage area | Freezer | Building area | User | Action   | Date         | Map |
      | 555   | 123456    |              |         |               | john | Check in | 10 May 11:00 | A1  |
      | 666   | 123456    |              |         |               | john | Check in | 10 May 11:00 | B2  |
      | 777   | 123456    |              |         |               | john | Check in | 10 May 11:00 | H12 |
    

  Scenario: Overwrite pre-existing tube locations with rearray on same rack
    When I fill in "User Barcode" with "888"
      And I fill in "Rack barcode" with "123456"
      And I attach the file "test/data/valid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "Uploaded rack"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode |  Map |
      | 555   |  A1  |
      | 666   |  B2  |
      | 777   |  H12 |
      
    When I fill in "User Barcode" with "888"
      And I fill in "Rack barcode" with "98765"
      And I attach the file "test/data/valid_rearray_rack_file.csv" to "rack_layout"
      And I press "Submit"
    When I follow "Recent activity"
    Then the list of asset audits should be:
      | Barcode | Container | Storage area | Freezer    | Building area | User | Action    | Date         | Map |
      | 777   | 98765     |              |            |               | john | Check in  | 10 May 11:00 | A1  |
      | 555   | 98765     |              |            |               | john | Check in  | 10 May 11:00 | B2  |
      | 666   | 98765     |              |            |               | john | Check in  | 10 May 11:00 | H12 |
      | 555   | 123456    | Shelf1       | Freezer456 | Room123       | john | Check out | 10 May 11:00 | A1  |
      | 666   | 123456    | Shelf1       | Freezer456 | Room123       | john | Check out | 10 May 11:00 | B2  |
      | 777   | 123456    | Shelf1       | Freezer456 | Room123       | john | Check out | 10 May 11:00 | H12 |
      | 555   | 123456    | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 | A1  |
      | 666   | 123456    | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 | B2  |
      | 777   | 123456    | Shelf1       | Freezer456 | Room123       | john | Check in  | 10 May 11:00 | H12 |

  Scenario: Rescan a rack and it should disappear from dirty list
    Given rack "98765" is flagged as dirty
    When I follow "Racks which need to have layout rescanned"
    Then the list of dirty racks should be:
      | Container | Storage area | Freezer | Building area |
      | 98765     |              |         |               |
    When I follow "Scan rack layout"
    When I fill in "User Barcode" with "888"
      And I fill in "Rack barcode" with "98765"
      And I attach the file "test/data/valid_rack_file.csv" to "rack_layout"
      And I press "Submit"
    Then I should see "Uploaded rack"
    When I follow "Racks which need to have layout rescanned"
    Then the list of dirty racks should be:
      | Container | Storage area | Freezer | Building area |

  