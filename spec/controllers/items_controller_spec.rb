require 'spec_helper'

describe ItemsController, type: :controller do
  let(:back_uri) { 'http://test.host/search?q=dog' }
  let(:item1) { double('item', id: 'a') }
  let(:item2) { double('item', id: 'b') }

  # The variable 'items' represents a DPLA::Result, which is a subclass of an
  # Array with additional methods.  Stubbing methods of an Array singleton
  # creates a reasonable substitute that works well for tests.  In individual
  # tests, take care not to manipulate 'items' in such a way that the Array is
  # copied; stub methods do not work on copies.
  let(:items) { [] }
  before do
    items.stub(:position_before) { nil }
    items.stub(:position_after) { nil }
  end

  describe '#show' do
    before { items << item1 }

    it 'sets @item variable' do
      allow(DPLA::Items).to receive(:by_ids).with('a').and_return(items)
      get :show, id: 'a'
      expect(assigns(:item)).to eq item1
    end

    it 'returns 404 status if item not found' do
      allow(DPLA::Items).to receive(:by_ids).with('a').and_return([])
      get :show, id: 'a'
      expect(response.status).to eq 404
    end

    it 'assigns @next variable' do
      allow(DPLA::Items).to receive(:by_ids).and_return(items)
      get :show, id: 'a', next: '1'
      expect(assigns(:next)).to eq '1'
    end

    it 'assings @previous variable' do
      allow(DPLA::Items).to receive(:by_ids).and_return(items)
      get :show, id: 'a', previous: '1'
      expect(assigns(:previous)).to eq '1'
    end

    it 'handles missing next param' do
      allow(DPLA::Items).to receive(:by_ids).and_return(items)
      get :show, id: 'a'
      expect(assigns(:next)).to eq nil
    end

    it 'handles missing previous param' do
      allow(DPLA::Items).to receive(:by_ids).and_return(items)
      get :show, id: 'a'
      expect(assigns(:next)).to eq nil
    end

    it 'handles non-integer next param' do
      allow(DPLA::Items).to receive(:by_ids).and_return(items)
      get :show, id: 'a', next: 'blah'
      expect(assigns(:next)).to eq nil
    end

    it 'handles non-integer previous param' do
      allow(DPLA::Items).to receive(:by_ids).and_return(items)
      get :show, id: 'a', previous: 'bloop'
      expect(assigns(:next)).to eq nil
    end
  end

  describe '#next' do
    before do
      items << item1
      items << item2
    end

    it 'returns 404 status if position missing' do
      post :next, back_uri: back_uri
      expect(response.status).to eq 404
    end

    it 'returns 404 status if back_uri missing' do
      post :next, position: '1'
      expect(response.status).to eq 404
    end

    it 'returns 404 status if API search return no items' do
      ItemsController.any_instance.stub(:search_items).and_return([])
      post :next, back_uri: back_uri, position: '1'
      expect(response.status).to eq 404
    end

    it 'gets next item' do
      ItemsController.any_instance.stub(:search_items).and_return(items)
      post :next, back_uri: back_uri, position: '1'
      expect(assigns(:item)).to eq item2
    end

    it 'sets @search_params to Hash with indifferent access' do
      post :next, back_uri: back_uri, position: '1'
      expect(assigns(:search_params)).to be_a HashWithIndifferentAccess
    end

    it 'renders show view with correct params' do
      items.stub(:position_before) { 0 }
      ItemsController.any_instance.stub(:search_items).and_return(items)
      post :next, back_uri: back_uri, position: '1'
      expect(response)
        .to redirect_to action: :show, id: 'b', back_uri: back_uri, previous: 0
    end

    context 'given first position on page' do
      it 'gets the next page' do
        back_uri = 'http://test.host/search'
        post :next, back_uri: back_uri, position: '20'
        expect(assigns(:search_params)).to include({ 'page' => '2' })
      end

      it 'gets the first item' do
        ItemsController.any_instance.stub(:search_items).and_return(items)
        post :next, back_uri: back_uri, position: '0'
        expect(assigns(:item)).to eq item1
      end
    end
  end

  describe '#previous' do
    before do
      items << item1
      items << item2
    end

    it 'returns 404 status if position missing' do
      post :previous, back_uri: back_uri
      expect(response.status).to eq 404
    end

    it 'returns 404 status if back_uri missing' do
      post :previous, previous: '0'
      expect(response.status).to eq 404
    end

    it 'returns 404 status if API search return no items' do
      ItemsController.any_instance.stub(:search_items).and_return([])
      post :previous, back_uri: back_uri, position: '0'
      expect(response.status).to eq 404
    end

    it 'gets previous item' do
      ItemsController.any_instance.stub(:search_items).and_return(items)
      post :previous, back_uri: back_uri, position: '0'
      expect(assigns(:item)).to eq item1
    end

    it 'sets @search_params to Hash with indifferent access' do
      post :previous, back_uri: back_uri, position: '0'
      expect(assigns(:search_params)).to be_a HashWithIndifferentAccess
    end

    it 'renders show view with correct params' do
      items.stub(:position_after) { 1 }
      ItemsController.any_instance.stub(:search_items).and_return(items)
      post :previous, back_uri: back_uri, position: '0'
      expect(response)
        .to redirect_to action: :show, id: 'a', back_uri: back_uri, next: 1
    end

    context 'given last position on page' do
      it 'get the previous page' do
        back_uri = 'http://test.host/search?page=2'
        post :previous, back_uri: back_uri, position: '19'
        expect(assigns(:search_params)).to include({ 'page' => '1' })
      end

      it 'gets the last item' do
        back_uri = 'http://test.host/search?page=2&page_size=10'
        items = Array.new(9, double('item'))
        items << item1
        items.stub(:position_before) { nil }
        items.stub(:position_after) { nil }
        ItemsController.any_instance.stub(:search_items).and_return(items)
        post :previous, back_uri: back_uri, position: '9'
        expect(assigns(:item)).to eq item1
      end
    end
  end

  describe '#search_items' do
    it 'return nil if @search_params undefined' do
      expect(@controller.instance_eval{ search_items }).to be nil
    end
  end
end
