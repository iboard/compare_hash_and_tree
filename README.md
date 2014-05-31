COMPARISON OF HASH AND TREE
===========================

Usage:

  1. `bundle`
  2. `ruby benchmark.rb`
  3. `rspec render_list_hash.rb`
  4. `rspec render_list_tree.rb`

`render_list_hash` and `render_list_tree` does the same thing:

    * Read input from a plain array containing strings
      * 001
      * 001.001
      * 001.001.001
      * 001.001.002
      * 001.002
      * 001.002.001
      * ....
    * Converts the input into a nested list
      * 001
      *   001
      *     001
      *     002
      *   002
      *     001

`render_list_hash` converts the input into a nested hash:

    { "001" => { "001" => { "001" => "", "002" => "" }, "002" => .... }

`render_list_tree` uses the RubyTree-Gem and reads the input-array into a Tree

                   ROOT
                    001
               001        002
                        001


The Benchmark shows that plain hash-objects are a lot faster than using
a Tree.

    ONE LEVEL HAS 1,000 ENTRIES
    TWO LEVELS HAS 101,000 ENTRIES
    THREE LEVELS HAS 1,101,000 ENTRIES
                                                   user     system      total        real
    Creation
    1 Level creation Tree                      0.010000   0.000000   0.010000 (  0.010529)
    1 Level creation Hash                      0.000000   0.000000   0.000000 (  0.002905)
    2 Levels creation Tree                     1.490000   0.040000   1.530000 (  1.543189)
    2 Levels creation Hash                     0.450000   0.020000   0.470000 (  0.460114)
    3 Levels creation Tree                    34.280000   0.520000  34.800000 ( 34.962842)
    3 Levels creation Hash                    10.300000   0.170000  10.470000 ( 10.522603)

    Rendering
    1 Level render Tree                        0.010000   0.000000   0.010000 (  0.003143)
    1 Level render hash                        0.000000   0.000000   0.000000 (  0.000745)
    2 Levels render Tree                       0.310000   0.000000   0.310000 (  0.316488)
    2 Levels render hash                       0.960000   0.010000   0.970000 (  0.968256)
    3 Levels render Tree                      11.850000   0.040000  11.890000 ( 11.948506)
    3 Levels render hash                      10.890000   0.030000  10.920000 ( 10.974792)
