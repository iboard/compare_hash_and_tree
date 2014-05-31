require "rspec"
require "tree"

class NestedTree

  # @param [Array] lines
  # @example
  #   NestedTree.new( [ "1", "1.a", "1.a.i", "1.a.ii", "2" ] )
  def initialize lines
    _array = lines.map { |l| l.split(".") }
    build_tree(_array)
  end

  # @param [Hash] _hash
  # @return [String] HTML-UL
  # @example
  #   render( { "1"=>{"a"=>{} } )
  #   "<ul>
  #      <li>1<ul>
  #             <li>a</li>
  #           </ul>
  #      </li>
  #   </ul>"
  def render _node=@root
    render_node _node
  end

  private

  def build_tree _array
    @root = _array.inject(Tree::TreeNode.new("ROOT", "Unordered List")) do |parent, entry|
      add_entry(parent,entry)
      parent
    end
  end

  def add_entry target, entry
    return if entry.empty?
    node = target[entry.first] || insert_node(target,entry)
    add_entry(node,entry[1..-1]) if entry.count > 1
  end

  def insert_node target, entry
    target << (node = Tree::TreeNode.new( entry.first, entry.join(".") ))
    node
  end


  START_LIST = "<ul><li>"
  MIDDLE_LIST= "</li><li>"
  CLOSE_LIST="</li></ul>"

  def render_node _node
    node_name(_node) + render_children(_node)
  end

  def render_children _node
    return "" unless _node.children.any?
    [ START_LIST , rendered_children(_node).join(MIDDLE_LIST), CLOSE_LIST ].join
  end

  def rendered_children _node
    _node.children.map { |n| render n }
  end

  def node_name _node
    _node == @root ? "" :  _node.name
  end


end


describe "A list with one item" do

  subject(:input_list) { [ "001" ] }

  it "outputs an ul with one li" do
    expect(NestedTree.new(input_list).render).to eq( "<ul><li>001</li></ul>" )
  end

end


describe "A list with two top level items" do
  subject(:input_list) { %w( 001 002 ) }
  it "outputs an ul with two LIs" do
    expect(NestedTree.new(input_list).render).to eq( "<ul><li>001</li><li>002</li></ul>" )
  end
end

describe "A 1 level nested list", focus: true do
  subject(:expected) { %q{<ul> <li>1
                                  <ul> <li>a
                                       <ul>
                                         <li>i</li>
                                         <li>ii</li>
                                       </ul>
                                    </li>
                                  </ul>
                                </li>
                              <li>2
                                 <ul><li>a</li><li>b</li></ul>
                              </li>
                          </ul>}.gsub(/\s+/,'')
                    }
  subject(:input_list) { %w( 1 1.a 1.a.i 1.a.ii 2 2.a 2.b ) }
  it "outputs a nested ul" do
    expect(NestedTree.new(input_list).render).to eq( expected )
  end
end


