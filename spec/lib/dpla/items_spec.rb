require 'spec_helper'

describe DPLA::Items do
  subject { DPLA::Items }

    describe "#by_conditions" do

    it "should send correct query string to #load with :q" do
      conditions = {:q => 'love'}
      DPLA::Conditions.stub(:new).with(conditions).and_return("q=love")
      subject.stub(:api_key).and_return("api_key=123")
      subject.should_receive(:load).with("/items?q=love&api_key=123")
      subject.by_conditions(conditions)
    end

  end

end