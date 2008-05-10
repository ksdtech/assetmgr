require File.join(File.dirname(__FILE__) + '/searchable_record_test_helper')
require 'logger'
require 'searchable_record'

class Record; include SearchableRecord; end

context "SearchableRecord, for finding queried records" do
  setup do
    Record.stubs(:logger).returns(stub(:debug))
    #Record.stubs(:logger).returns(Logger.new(STDOUT))
  end

  specify "should be able to modify default settings" do
    new_settings = {
      :cast_since_as     => 'time',
      :cast_until_as     => 'date',
      :pattern_operator  => 'regexp',
      :pattern_converter => lambda { |val| val }
    }

    org_settings = Record.searchable_record_settings.dup

    Record.searchable_record_settings = new_settings
    Record.searchable_record_settings.should.equal new_settings

    Record.searchable_record_settings = org_settings
    Record.searchable_record_settings.should.equal org_settings
  end

  specify "should execute find with no parameters, discarding unrecognized parameters" do
    Record.expects(:find).times(2).with(:all, { })

    Record.find_queried(:all, { }, { })
    Record.find_queried(:all, { :foo => 'bar' }, { })
  end

  specify "should execute find with a positive offset parameter" do
    Record.expects(:find).times(1).with(:all, { :offset => 1 })

    Record.find_queried(:all, { :offset => '1' }, { :offset => nil })

    Record.expects(:find).times(2).with(:all, { :offset => 4 })

    Record.find_queried(:all, { :offset => '4' }, { :offset => nil })
    Record.find_queried(:all, { :offset => '4', :limit => '3' }, { :offset => nil })
  end

  specify "should discard other than positive offset parameters" do
    Record.expects(:find).times(4).with(:all, { })

    Record.find_queried(:all, { },                  { :offset => nil })
    Record.find_queried(:all, { :offset => 'aii' }, { :offset => nil })
    Record.find_queried(:all, { :offset => '0' },   { :offset => nil })
    Record.find_queried(:all, { :offset => '-1' },  { :offset => nil })
  end

  specify "should execute find with a positive limit parameter" do
    Record.expects(:find).times(1).with(:all, { :limit => 1 })

    Record.find_queried(:all, { :limit => '1' }, { :limit => nil })

    Record.expects(:find).times(2).with(:all, { :limit => 4 })

    Record.find_queried(:all, { :limit => '4' }, { :limit => nil })
    Record.find_queried(:all, { :limit => '4', :offset => '3' }, { :limit => nil })
  end

  specify "should discard other than positive limit parameters" do
    Record.expects(:find).times(4).with(:all, { })

    Record.find_queried(:all, { },                 { :limit => nil })
    Record.find_queried(:all, { :limit => 'aii' }, { :limit => nil })
    Record.find_queried(:all, { :limit => '0' },   { :limit => nil })
    Record.find_queried(:all, { :limit => '-1' },  { :limit => nil })
  end

  specify "should execute find with sort parameter" do
    Record.expects(:find).times(1).with(:all, { :order  => 'users.first_name' })

    Record.find_queried(:all, { :sort => 'first_name' },
                              { :sort => { 'first_name' => 'users.first_name' } })
  end

  specify "should execute find with reverse sort parameter" do
    Record.expects(:find).times(1).with(:all, { :order  => 'users.first_name desc' })

    Record.find_queried(:all, { :rsort => 'first_name' },
                              { :sort  => { 'first_name' => 'users.first_name' },
                                :rsort => nil })
  end

  specify "should raise an exception if rsort is specified without sort rule" do
    lambda { Record.find_queried(:all, { :rsort => 'first_name' },
             { :rsort  => { 'first_name' => 'users.first_name' } }) }.should.raise(ArgumentError)
  end

  specify "should execute find with sort parameter, favoring 'sort' over 'rsort'" do
    Record.expects(:find).times(1).with(:all, { :order  => 'users.first_name' })

    Record.find_queried(:all, { :sort => 'first_name', :rsort => 'last_name' },
                              { :sort  => { 'first_name' => 'users.first_name',
                                            'last_name'  => 'users.last_name' },
                                :rsort => nil })
  end

  specify "should discard other than specified sort parameters" do
    Record.expects(:find).times(1).with(:all, {  })

    Record.find_queried(:all, { :sort => 'first' },
                              { :sort => { 'first_name' => 'users.first_name' } })

    Record.expects(:find).times(1).with(:all, { :order => 'users.last_name desc' })

    Record.find_queried(:all, { :sort  => 'last', :rsort => 'last_name' },
                              { :sort  => { 'first_name' => 'users.first_name',
                                            'last_name'  => 'users.last_name' },
                                :rsort => nil })
  end

  specify "should execute find with since parameter, with default settings" do
    Record.expects(:find).times(2).with(:all, { :conditions => [ '(users.created_at >= cast(:since as datetime))',
                                                                 { :since => '2008-02-26' } ] })

    Record.find_queried(:all, { :since => '2008-02-26' },
                              { :since => 'users.created_at' })
    Record.find_queried(:all, { :since => '2008-02-26' },
                              { :since => { :column => 'users.created_at' } })
  end

  specify "should execute find with since parameter, with custom settings" do
    Record.expects(:find).times(3).with(:all, { :conditions => [ '(users.time >= cast(:since as time))',
                                                                 { :since => '11:04' } ] })

    Record.find_queried(:all, { :since => '11:04' },
                              { :since => { :column  => 'users.time',
                                            :cast_as => 'time' } })

    org_settings = Record.searchable_record_settings.dup
    Record.searchable_record_settings[:cast_since_as] = 'time'

    Record.find_queried(:all, { :since => '11:04' },
                              { :since => 'users.time'})

    Record.find_queried(:all, { :since => '11:04' },
                              { :since => { :column  => 'users.time' } })

    Record.searchable_record_settings = org_settings
  end

  specify "should execute find with until parameter, with default settings" do
    Record.expects(:find).times(2).with(:all, { :conditions => [ '(users.created_at <= cast(:until as datetime))',
                                                                 { :until => '2008-04-28' } ] })

    Record.find_queried(:all, { :until => '2008-04-28' },
                              { :until => 'users.created_at' })
    Record.find_queried(:all, { :until => '2008-04-28' },
                              { :until => { :column => 'users.created_at' } })
  end

  specify "should execute find with until parameter, with custom settings" do
    Record.expects(:find).times(3).with(:all, { :conditions => [ '(users.time <= cast(:until as time))',
                                                                 { :until => '13:06' } ] })

    Record.find_queried(:all, { :until => '13:06' },
                              { :until => { :column  => 'users.time',
                                            :cast_as => 'time' } })

    org_settings = Record.searchable_record_settings.dup
    Record.searchable_record_settings[:cast_until_as] = 'time'

    Record.find_queried(:all, { :until => '13:06' },
                              { :until => 'users.time'})

    Record.find_queried(:all, { :until => '13:06' },
                              { :until => { :column  => 'users.time' } })

    Record.searchable_record_settings = org_settings
  end

  specify "should execute find with pattern matching parameters" do
    Record.expects(:find).times(1).with(:all, :conditions => [ "(users.first_name like :name)",
                                                               { :name => '%john%' } ])

    Record.find_queried(:all, { :name     => 'john' },
                              { :patterns => { :name => 'users.first_name'} })
  end

  specify "should execute find with a pattern matching parameter, with default settings" do
    Record.expects(:find).times(1).with(:all, :conditions => [ "(sites.status like :status)",
                                                               { :status => '%active%' } ])

    Record.find_queried(:all, { :status   => 'active' },
                              { :patterns => { :status => 'sites.status' } })
  end

  specify "should execute find with a pattern matching parameter, with custom settings" do
    Record.expects(:find).times(1).with(:all, :conditions => [ "(sites.domain like :domain)",
                                                               { :domain => '%www.example.fi%' } ])

    Record.find_queried(:all, { :domain   => 'www_example_fi' },
                              { :patterns => { :domain => { :column    => 'sites.domain',
                                                            :converter => lambda { |val| "%#{val.gsub('_', '.')}%" } } } })

    Record.expects(:find).times(2).with(:all, :conditions => [ "(sites.domain regexp :domain)",
                                                               { :domain => 'www.example.fi' } ])

    Record.find_queried(:all, { :domain   => 'www_example_fi' },
                              { :patterns => { :domain => { :column    => 'sites.domain',
                                                            :converter => lambda { |val| val.gsub('_', '.') },
                                                            :operator  => 'regexp' } } })

    org_settings = Record.searchable_record_settings.dup
    Record.searchable_record_settings[:pattern_operator]  = 'regexp'
    Record.searchable_record_settings[:pattern_converter] = lambda { |val| val.gsub('_', '.') }

    Record.find_queried(:all, { :domain   => 'www_example_fi' },
                              { :patterns => { :domain => 'sites.domain' } })

    Record.searchable_record_settings = org_settings
  end

  specify "should execute find with multiple pattern matching parameters" do
    results = [
     { :conditions => [ "(sites.domain like :domain) and (sites.status like :status)",
                      { :domain => '%www.another.example.fi%',
                        :status => '%active%' } ]},
     { :conditions => [ "(sites.status like :status) and (sites.domain like :domain)",
                      { :domain => '%www.another.example.fi%',
                        :status => '%active%' } ]}
    ]

    Record.expects(:find).times(1).with(:all, any_of(equals(results[0]), equals(results[1])))

    Record.find_queried(:all, { :domain   => 'www_another_example_fi',
                                :status   => 'active' },
                              { :patterns => { :domain => { :column    => 'sites.domain',
                                                            :converter => lambda { |val| "%#{val.gsub('_', '.')}%" } },
                                               :status => 'sites.status' } })
  end

  specify "should preserve additional options" do
    Record.expects(:find).times(1).with(:all, :include => [ :affiliates ],
                                        :conditions => [ "(sites.flags = 'fo') and (sites.domain like :domain)",
                                                         { :domain => '%www.still-works.com%' } ])

    Record.find_queried(:all, { :domain     => 'www_still-works_com' },
                              { :patterns   => { :domain => { :column    => 'sites.domain',
                                                              :converter => lambda { |val| "%#{val.gsub('_', '.')}%" } } } },
                              { :conditions => "sites.flags = 'fo'",
                                :include    => [ :affiliates ] })

    Record.expects(:find).times(1).with(:all, :include => [ :affiliates ],
                                        :conditions => [ "(sites.flags = 'fo') and (users.time <= cast(:until as time))",
                                                         { :until => '13:06' } ])

    Record.find_queried(:all, { :until      => '13:06' },
                              { :until      => { :column  => 'users.time',
                                                 :cast_as => 'time' } },
                              { :conditions => "sites.flags = 'fo'",
                                :include    => [ :affiliates ] })
  end

  specify "should work with all rules combined" do
    Item = Record
  
    Item.expects(:find).times(1).with(:all,
                                      :include => [ :owners ],
                                      :order   => 'items.name desc',
                                      :offset  => 4,
                                      :limit   => 5,
                                      :conditions => [ "(items.flag = 'f') and (items.created_at <= cast(:until as datetime)) and (items.name like :name)",
                                                       { :until => '2008-02-28', :name => '%foo.bar%' } ])

    query_params = {
      :offset => '4',
      :limit  => '5',
      :rsort  => 'name',
      :until  => '2008-02-28',
      :name   => 'foo_bar'
    }

    rules = {
      :limit    => nil,
      :offset   => nil,
      :sort     => { 'name' => 'items.name', 'created' => 'items.created_at' },
      :rsort    => nil,
      :since    => 'items.created_at',
      :until    => 'items.created_at',
      :patterns => { :type => 'items.type',
                     :name => { :column    => 'items.name',
                                :converter => lambda { |val| "%#{val.gsub('_', '.')}%" } } }
    }

    options = {
      :include    => [ :owners ],
      :conditions => "items.flag = 'f'"
    }

    Item.find_queried(:all, query_params, rules, options)
  end
end
