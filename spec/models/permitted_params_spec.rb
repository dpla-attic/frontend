require 'spec_helper'

describe PermittedParams do
  describe '#search' do
	  it 'returns an array of search params' do
	  	params = { :q => 'finch', 'provider' => ['Provider 1'] }
	  	@model = PermittedParams.new(params)
	  	expect(@model.search).to match_array(
	  		['finch',{ :provider => ['Provider 1'] }]
	  	)
	  end
  end

  describe '#args' do
    it 'defaults to page size of 20' do
      @model = PermittedParams.new({})
      expect(@model.args[:page_size]).to eq '20'
    end
  end
end
