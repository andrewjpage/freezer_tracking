Given /^I am logged in as an administrator$/ do
  #pending # express the regexp above with the code you wish you had
end

Then /^the list of (building areas|freezers|storage areas|assets|dirty racks|asset audits) should be:$/ do |name, expected_table|
  table_name = name.gsub(/ /, '_')
  expected_table.diff!(table(tableish("##{table_name} tr", 'td,th')))
end

Given /^building area "([^"]*)" exists$/ do |name|
  Factory :building_area, :name => name
end

Given /^storage area "([^"]*)" has a barcode of "([^"]*)"$/ do |storage_area_name, barcode|
  StorageArea.find_by_name(storage_area_name).update_attributes!(:barcode => barcode)
end


Given /^freezer "([^"]*)" is contained in building area "([^"]*)"$/ do |freezer_name, building_area_name|
  building_area = BuildingArea.find_by_name(building_area_name)
  Factory :freezer_without_associations, :name => freezer_name, :building_area => building_area
end

Given /^storage area "([^"]*)" is contained in freezer "([^"]*)"$/ do |storage_area_name, freezer_name|
  freezer = Freezer.find_by_name(freezer_name)
  Factory :storage_area_without_associations, :name => storage_area_name, :freezer => freezer
end

Given /^asset "([^"]*)" is contained in storage area "([^"]*)"$/ do |asset_barcode, storage_area_name|
  storage_area = StorageArea.find_by_name(storage_area_name)
  Factory :asset_without_associations, :barcode => "123456", :storage_area => storage_area
end
