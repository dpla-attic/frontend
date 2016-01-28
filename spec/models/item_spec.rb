require 'spec_helper'

describe Item do
  describe "#preview_image" do
    before(:each) do
      allow(item).to receive(:preview_image).and_call_original
    end

    shared_examples 'an item with an object' do
      let(:item) { Item.new({"object" => value}) }

      it 'returns the expected thumbnail URI' do
        expect(item.preview_image).to eq(ret)
      end
    end

    context 'with a valid HTTP edm:object' do
      let(:value) { 'http://example.com/1.png' }
      let(:ret) { value }
      it_behaves_like 'an item with an object'
    end

    context 'with a valid HTTPS edm:object' do
      let(:value) { 'https://example.org/2.gif' }
      let(:ret) { value }
      it_behaves_like 'an item with an object'
    end

    context 'with a invalid URI value for edm:object' do
      let(:value) { '_:b3f3f2f0' }
      let(:ret) { nil }
      it_behaves_like 'an item with an object'
    end

    context 'without an object' do
      let(:item) { Item.new({"isShownAt" => "http://bar.com/foo"}) }

      it 'returns nil when there is no object' do
        expect(item.preview_image).to be_nil
      end
    end
  end
end
