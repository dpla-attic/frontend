require 'spec_helper'

describe DPLA::Item do
  context 'preparing conditions' do
    subject { DPLA::Item.new }

    it 'should returns simple keys transparent' do
      conditions = { q: 'civil war', foo: 'bar', count: 1, facets: 'format' }
      expected   = 'q=civil%20war&foo=bar&count=1&facets=format'
      subject.prepare_conditions(conditions).should eql(expected)
    end

    it 'should flatten nested hash' do
      conditions = { spatial: { city: 'New York City', state: 'NY'} }
      expected   = "spatial.city=New%20York%20City&spatial.state=NY"
      subject.prepare_conditions(conditions).should eql(expected)
    end

    it 'should transform facets array to comma-separated string' do
      conditions = { facets: ['subject.name', 'format'] }
      expected   = 'facets=subject.name,format'
      subject.prepare_conditions(conditions).should eql(expected)
    end

    it 'should transform other arrays to "+AND+"-separated string' do
      conditions = { subject: ["First subject", "Second"] }
      expected   = 'subject=First%20subject+AND+Second'
      subject.prepare_conditions(conditions).should eql(expected)
    end
  end
end