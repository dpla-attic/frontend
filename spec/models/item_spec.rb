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

    context 'with multiple objects' do
      let(:value) { ['http://bar.com/foo', 'http://bar.com/bat'] }
      let(:ret) { 'http://bar.com/foo' }

      it_behaves_like 'an item with an object'
    end
  end

  describe "#mainfest" do
    before(:each) do
      allow(item).to receive(:manifest).and_call_original
    end

    shared_examples 'an item with an object' do
      let(:item) { Item.new({ "object" => value }) }

      it 'returns the expected mainfest URI' do
        expect(item.manifest).to eq(ret)
      end
    end

    context 'with a valid HTTP edm:object' do
      let(:value) { 'http://example.com/1234/thumbnail' }

      let(:ret) do
        'https://www.digitalcommonwealth.org/search/commonwealth:1234/manifest'
      end

      it_behaves_like 'an item with an object'
    end

    context 'with a invalid URI value for edm:object' do
      let(:value) { '_:b3f3f2f0' }
      let(:ret) { nil }
      it_behaves_like 'an item with an object'
    end

    context 'without an object' do
      let(:item) { Item.new({ "isShownAt" => "http://bar.com/foo" }) }

      it 'returns nil when there is no object' do
        expect(item.manifest).to be_nil
      end
    end

    context 'with multiple objects' do
      let(:value) { ['http://bar.com/1234/thumbnail', 'http://bat.com/1234/thumbnail'] }

      let(:ret) do
        'https://www.digitalcommonwealth.org/search/commonwealth:1234/manifest'
      end

      it_behaves_like 'an item with an object'
    end
  end

  describe '#language' do
    it 'returns language' do
      doc = { 'sourceResource' => { 'language' => [{ 'name' => 'x' }] } }
      item = Item.new(doc)
      expect(item.language).to match_array ['x']
    end

    it 'handles nil value for sourceResource' do
      item = Item.new({})
      expect(item.language).to match_array []
    end

    it 'handles nil value for language' do
      doc = { 'sourceResource' => {} }
      item = Item.new(doc)
      expect(item.language).to match_array []
    end

    it 'handles nil value for language' do
    doc = { 'sourceResource' => { 'language' => [{}] } }
      item = Item.new(doc)
      expect(item.language).to match_array []
    end

    it 'handles language if Hash' do
      doc = { 'sourceResource' => { 'language' => { 'name' => 'x' } } }
      item = Item.new(doc)
      expect(item.language).to match_array ['x']
    end
  end

  describe '#rights' do
    it 'handles multiple values' do
      doc = { 'sourceResource' => { 'rights' => ['X', 'Y'] } }
      item = Item.new(doc)
      expect(item.rights).to match_array ['X', 'Y']
    end
  end

  describe '#standardized_rights_statement' do
    it 'returns statements' do
      statement = "https://creativecommons.org/publicdomain/zero/1.0/"
      doc = { 'rights' => [statement] }
      item = Item.new(doc)
      expect(item.standardized_rights_statement).to match_array [statement]
    end
  end
end
