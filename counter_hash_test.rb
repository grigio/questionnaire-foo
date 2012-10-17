require 'minitest/autorun'
require './counter_hash'

describe CounterHash do

  let(:ch) { CounterHash.new }

  it '#to_hash is an hash' do
    ch.to_hash.must_equal({})
  end

  it '#add a pair' do
    ch.add('key1','value1')
    ch.to_hash.must_equal({'key1' => {'value1' => {:count => 1}}})
    ch.add('key1','value1')
    ch.to_hash.must_equal({'key1' => {'value1' => {:count => 2}}})
  end

  it '#add a pair with same key and different values' do
    ch.add('key1','value1')
    ch.add('key2','value2')
    ch.add('key1','value2')
    ch.add('key2','value2')
    ch.to_hash.must_equal({"key1"=>{"value1"=>{:count=>1},
                                    "value2"=>{:count=>1}},
                            "key2"=>{"value2"=>{:count=>2}}})
  end

  it '#add_hash directly' do
    ch.add_hash({'key1' => 'value1', 'key2' => 'value2'})
    ch.add_hash({'key1' => 'value2', 'key2' => 'value2'})
    ch.to_hash.must_equal({"key1"=>{"value1"=>{:count=>1},
                                    "value2"=>{:count=>1}},
                            "key2"=>{"value2"=>{:count=>2}}})
    ch.count.must_equal 2
  end

end