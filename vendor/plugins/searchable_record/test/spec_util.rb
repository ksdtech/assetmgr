require File.join(File.dirname(__FILE__) + '/searchable_record_test_helper')
require 'active_support/core_ext/blank'
require 'util'

include SearchableRecord

context "Unit" do
  specify "should parse positive integers" do
    Util.parse_positive_int('1').should.equal 1
    Util.parse_positive_int('1sdfgsdf').should.equal 1
    Util.parse_positive_int(nil).should.equal nil
    Util.parse_positive_int('0').should.equal nil
    Util.parse_positive_int('-1').should.equal nil
    Util.parse_positive_int('sdfgdfg').should.equal nil
  end

  specify "should prune and duplicate hashes" do
    str = "don't remove me"

    Util.pruned_dup({ :excess => 'foobar', :preserve => str }, [ :preserve ]).should.equal Hash[ :preserve => str ]
    Util.pruned_dup({ :excess => 'foobar', 'preserve' => str }, [ :preserve ]).should.equal Hash[ :preserve => str ]

    # A contrived example of calling #to_a for the second argument.
    Util.pruned_dup({ :e => 'foobar', [ :p, str ] => str }, { :p => str }).should.equal Hash[ [:p, str] => str ]

    Util.pruned_dup({ :excess => 'foobar' }, [ :preserve ]).should.equal Hash.new
    Util.pruned_dup({ }, [ ]).should.equal Hash.new
    Util.pruned_dup({ }, [ :preserve ]).should.equal Hash.new
    
    lambda { Util.pruned_dup(nil, [ :foo ]) }.should.raise NoMethodError
  end
end
