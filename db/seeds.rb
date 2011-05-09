# Creates all of the Map instances in the DB for all know plate sizes.  This assumes a horizontal orientation
# of the plate, i.e.:
#
#   1 2 3 4 5 6 7 8 9 
# A . . . . . . . . .
# B . . . . . . . . .
# C . . . . . . . . .
# D . . . . . . . . .
#

'A'.upto('H').map do |row|
  1.upto(12).map do |col|
    Map.create!(:description => "#{row}#{col}")
  end
end

