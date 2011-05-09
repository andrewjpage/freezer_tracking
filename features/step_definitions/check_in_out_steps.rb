Given /^asset "([^"]*)" with location "([^"]*)" is contained in asset "([^"]*)"$/ do |asset_barcode, map_description, container_barcode|
  container = Asset.find_by_barcode(container_barcode)
  map = Map.find_by_description(map_description)
  Factory :asset_without_associations, :barcode => asset_barcode, :map => map, :container => container
end

Then /^I should see the asset report:$/ do |expected_results_table|
  worksheet = page.body
  csv_rows = worksheet.split(/\r\n/)
  #csv_rows.shift(2)
  actual_table = CSV.parse( csv_rows.map{|c| "#{c}\r\n"}.join(''))
  expected_results_table.diff!(actual_table)
end

Given /^user "([^"]*)" with barcode '(\d+)' exists$/ do |user_name, barcode|
  FakeUserBarcodeService.instance.user_barcode(user_name,barcode)
end

Given /^rack "([^"]*)" is flagged as dirty$/ do |asset_barcode|
  Asset.find_by_barcode(asset_barcode).update_attributes!(:dirty => true)
end

Given /^an asset with barcode "([^"]*)" exists$/ do |asset_barcode|
  Factory :asset_without_associations, :barcode => asset_barcode
end

Given /^asset "([^"]*)" is checked into "([^"]*)"$/ do |asset_barcode, storage_area_name|
  storage_area = StorageArea.find_by_name(storage_area_name)
  Asset.find_by_barcode(asset_barcode).update_attributes!(:storage_area => storage_area)
end