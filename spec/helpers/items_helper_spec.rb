require 'spec_helper'

describe ItemsHelper do

  describe '#rs_statement' do
    it 'returns true for rightsstatements.org statement' do
      statement = "http://rightsstatements.org/vocab/NoC-NC/1.0/"
      expect(helper.rs_statement?(statement)).to be true
    end
  end

  describe '#cc_statement' do
    it 'returns true for creative commons statement' do
      statement = "https://creativecommons.org/publicdomain/zero/1.0"
      expect(helper.cc_statement?(statement)).to be true
    end
  end

  describe "#permitted_srs" do
    it 'returns array of permitted standardized rights statements' do
      valid = "http://rightsstatements.org/vocab/NoC-NC/1.0/"
      invalid = "foobar"
      statements = [valid, invalid]
      item = double('item', :standardized_rights_statement => statements)
      expect(helper.permitted_srs(item)).to match_array [valid]
    end
  end
end
