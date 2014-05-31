require "benchmark"
require_relative "./render_list_hash"
require_relative "./render_list_tree"


X=1000
Y=100
Z=10


one_level = (1..X).inject( [] ) do |entries,i|
  entries.push( "%05d" % i )
  entries
end
puts "ONE LEVEL HAS #{one_level.count} ENTRIES"

two_levels = one_level.inject([]) do |entries,parent|
  entries.push( parent )
  (1..Y).each do |i|
    entries.push "%s.%05d" % [ parent, i ]
  end
  entries
end
puts "TWO LEVELS HAS #{two_levels.count} ENTRIES"

three_levels = two_levels.inject([]) do |entries,parent|
  entries.push parent
  if parent =~ /\d+\.\d+/
    (1..Z).each do |i|
      entries.push("%s.%d" % [parent,i])
    end
  end
  entries
end
puts "THREE LEVELS HAS #{three_levels.count} ENTRIES"
pp three_levels[-3..-1]


one_level_tree = nil
two_levels_tree = nil
three_levels_tree = nil
one_level_hash = nil
two_levels_hash = nil
three_levels_hash = nil
Benchmark.bm(40) do |bm|
  puts "Creation"
  bm.report("1 Level creation Tree") { one_level_tree =  NestedTree.new(one_level) }
  bm.report("1 Level creation Hash") { one_level_hash =  NestedHash.new(one_level) }

  bm.report("2 Levels creation Tree") { two_levels_tree =  NestedTree.new(two_levels) }
  bm.report("2 Levels creation Hash") { two_levels_hash =  NestedHash.new(two_levels) }

  bm.report("3 Levels creation Tree") { three_levels_tree =  NestedTree.new(three_levels) }
  bm.report("3 Levels creation Hash") { three_levels_hash =  NestedHash.new(three_levels) }

  puts "\nRendering"
  bm.report("1 Level render Tree")   { one_level_tree.render }
  bm.report("1 Level render hash")   { one_level_hash.render }

  bm.report("2 Levels render Tree")  { two_levels_tree.render }
  bm.report("2 Levels render hash")  { two_levels_hash.render }

  bm.report("3 Levels render Tree")  { three_levels_tree.render }
  bm.report("3 Levels render hash")  { three_levels_hash.render }
end

