require "rspec"

class NestedHash

  # @param [Array] lines
  # @example
  #   NestedHash.new( [ "1", "1.a", "1.a.i", "1.a.ii", "2" ] )
  def initialize lines
    _array = lines.map { |l| l.split(".") }
    @hash = build_hash(_array)
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
  def render _hash=@hash
    "<ul>#{render_hash(_hash)}</ul>"
  end

  private

  def render_hash _hash
    _hash.map { |key,sub_hash|
      sub_hash == {} ? "<li>#{key}</li>" : "<li>#{key}#{render(sub_hash)}</li>"
    }.join
  end

  def build_hash _array
    _array.inject({}) do |_hash,_entry|
      set_hash _hash, *split_entry(_entry)
      _hash
    end
  end

  def set_hash _hash, _key, _rest
    return _hash unless _key
    _hash[_key] ||= {}
    set_hash( _hash[_key], *split_entry(_rest) ) if _rest
    _hash[_key]
  end

  def split_entry _entry
    _rest = Array(_entry)
    _key = _rest.shift
    [_key, _rest]
  end

end

describe "A list with one item" do

  subject(:input_list) { [ "001" ] }

  it "outputs an ul with one li" do
    expect(NestedHash.new(input_list).render).to eq( "<ul><li>001</li></ul>" )
  end

end

describe "A list with two top level items" do
  subject(:input_list) { %w( 001 002 ) }
  it "outputs an ul with two LIs" do
    expect(NestedHash.new(input_list).render).to eq( "<ul><li>001</li><li>002</li></ul>" )
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
    expect(NestedHash.new(input_list).render).to eq( expected )
  end
end
