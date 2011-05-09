Factory.sequence :building_area_name do |n|
  "Building area #{n}"
end

Factory.sequence :freezer_name do |n|
  "Freezer #{n}"
end

Factory.sequence :storage_area_name do |n|
  "Storage area #{n}"
end

Factory.sequence :storage_area_barcode do |n|
  "#{n}"
end

Factory.sequence :asset_barcode do |n|
  "#{n}"
end


Factory.define :building_area do |n|
  n.name { |a| Factory.next :building_area_name }
end

Factory.define :freezer do |n|
  n.name          { |a| Factory.next :freezer_name }
  n.building_area { |ba| ba.association(:building_area) }
end

Factory.define :freezer_without_associations, :class => Freezer do |n|
  n.name          { |a| Factory.next :freezer_name }
end

Factory.define :storage_area do |n|
  n.name      { |a| Factory.next :storage_area_name }
  n.barcode   { |a| Factory.next :storage_area_barcode }
  n.freezer   { |f| f.association(:freezer) }
end

Factory.define :storage_area_without_associations, :class => StorageArea do |n|
  n.name      { |a| Factory.next :storage_area_name }
  n.barcode   { |a| Factory.next :storage_area_barcode }
end

Factory.define :asset do |n|
  n.barcode   { |a| Factory.next :asset_barcode }
  n.storage_area   { |f| f.association(:storage_area) }
end

Factory.define :asset_without_associations, :class => Asset do |n|
  n.barcode   { |a| Factory.next :asset_barcode }
end







