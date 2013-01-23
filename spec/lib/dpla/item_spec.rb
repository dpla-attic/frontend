require 'spec_helper'

describe DPLA::Item do
  context 'preparing conditions' do
    subject { DPLA::Item.new }

    it 'should returns simple keys as-is' do
      conditions = { q: 'civil war', foo: 'bar', count: 1 }
      subject.prepare_conditions(conditions).should eql(conditions)
    end

    it 'should flatten nested hash' do
      conditions = { spatial: { city: 'New York City', state: 'NY'} }
      expected   = { :'spatial.city' => 'New York City', :'spatial.state' => 'NY' }
      subject.prepare_conditions(conditions).should eql(expected)
    end

    it 'should convert array values to comma-separated strings' do
      conditions = { facets: ['subject.name', 'format'] }
      expected   = { facets: 'subject.name,format' }
      subject.prepare_conditions(conditions).should eql(expected)
    end
  end
end