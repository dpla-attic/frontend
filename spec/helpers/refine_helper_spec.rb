require 'spec_helper'

describe RefineHelper do
  
	describe "#refine_path" do

		it "creates a new query term" do
			results = helper.refine_path(:provider, "University of Awesome")
			expect(results).to include(:provider => ["University of Awesome"], :page => nil)
		end

		it "adds a property to an existing query term" do 
			helper.stub(:params) { { :provider => "Provider 1" } }
			results = helper.refine_path(:provider, "Provider 2")
			expect(results).to include(
				:provider => ["Provider 1", "Provider 2"], 
				:page => nil
			)
		end

	end

end
