require 'spec_helper'

describe Search do

  describe "#conditions" do

  	it "returns correct conditions with :q param" do
  	  @model = Search.new('finch')
  	  result = @model.conditions
  	  expect(result[:q]).to eq("finch")
  	  expect(result[:facets]).to match_array(["subject", "language", "type", "provider", 
  	  	"partner", "country", "state", "place"])
  	end

  	it "returns correct conditions with filter param" do
  	  @model = Search.new('finch', {:provider => ["Provider 1"]})
  	  result = @model.conditions
  	  expect(result[:provider]).to eq(["Provider 1"])
  	end

  end

end
