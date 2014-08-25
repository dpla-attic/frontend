require 'spec_helper'

describe PermittedParams do
  describe "#search" do
	  it "returns an array of search params" do
	  	params = {:q=>"finch", "provider"=>["Provider 1"]}
	  	@model = PermittedParams.new(params)
	  	expect(@model.search).to match_array(
	  		["finch",{:provider =>["Provider 1"]}]
	  	)
	  end
  end
end
