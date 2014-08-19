require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SearchHelper. For example:
#
# describe SearchHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
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
