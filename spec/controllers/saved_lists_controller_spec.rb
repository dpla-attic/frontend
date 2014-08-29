require 'spec_helper'

describe SavedListsController do

	describe "#get_api_items" do

		before(:each) do
			@item1 = double('saved_items_positions', :saved_item => double('saved_item', :item_id => 'id1'))
			@item2 = double('saved_items_positions', :saved_item => double('saved_item', :item_id => 'id2'))
		end

		it "sends correct params to DPLA::Items.by_ids" do
			saved_items_positions = [@item1, @item2]
			params = {:q => 'search_param', :page_size=>'50'}
			DPLA::Items.should_receive(:by_ids).with(['id1', 'id2'], params)
			@controller.instance_eval{get_api_items(saved_items_positions, 'search_param')}
		end

		it "returns aggregated search results" do			
			saved_items_positions = [@item1, @item2]
			api_result1 = double('item', :id => 'api_id1') 
			api_result2 = double('item', :id => 'api_id2') 
			DPLA::Items.stub(:by_ids).and_return([api_result1, api_result2])
			result = @controller.instance_eval{get_api_items(saved_items_positions, '')}
			result.should eq({
				'api_id1' => api_result1,
				'api_id2' => api_result2
			})
		end

		it "constructs multiple API requests for long lists" do
			saved_items_positions = []
			101.times { saved_items_positions.push(@item1) } 
			DPLA::Items.should_receive(:by_ids).exactly(3).times
			@controller.instance_eval{get_api_items(saved_items_positions, 'search_param')}
		end

	end 

end