require 'spec_helper'

describe DPLA::Conditions do
  subject { DPLA::Conditions }

  before(:each) do
    @conditions = subject.new({})
  end

  describe "convert_conditions" do

    it "converts a hash of facet conditions to correct names" do
      conditions = {:facets => ["subject", "language", "type", "spec_type", "provider", 
        "partner", "date", "country", "state", "place"]}
      converted = @conditions.instance_eval{ convert_conditions(conditions) }
      converted[:facets].should include(
        "sourceResource.subject.name", 
        "sourceResource.language.name",
        "sourceResource.type",
        "sourceResource.specType",
        "admin.contributingInstitution",
        "provider.name",
        "sourceResource.date.begin.year",
        "sourceResource.spatial.country",
        "sourceResource.spatial.state",
        "sourceResource.spatial.name"
      )
    end

  end

  describe "transform_hash" do

    it "converts query hash into string" do
      conditions = {
        :q => 'love',
        :facets => ['sourceResource.type', 'admin.contributingInstitution'],
        :page_size => 150
      }
      result = @conditions.instance_eval{ transform_hash(conditions) }
      expect(result).to eq("q=love&facets=sourceResource.type,admin.contributingInstitution&page_size=150")
    end

    it "uri encodes a string" do
      conditions = {:q => "red wagon"}
      result = @conditions.instance_eval{ transform_hash(conditions) }
      expect(result).to eq ("q=red%20wagon")
    end

  end

end