require 'spec_helper'

describe ApplicationHelper do

  describe '#view_object_link' do
    let(:item) { double }
    before do
      allow(item).to receive(:type)
      allow(item).to receive(:data_provider)
    end

    it 'returns nil without a url' do
      allow(item).to receive(:url).and_return nil
      expect(helper.view_object_link(item)).to be nil
    end

    context 'with url' do
      before { allow(item).to receive(:url).and_return 'example.org' }

      it 'returns an HTML link' do
        expect(helper.view_object_link(item)).to start_with('<a')
        expect(helper.view_object_link(item)).to end_with('</a>')
      end

      it 'provides default values' do
        expect(helper.view_object_link(item))
          .to include('item', 'contributing institution')
      end

      it 'includes type if String' do
        allow(item).to receive(:type).and_return 'moving image'
        expect(helper.view_object_link(item)).to include('moving image')
      end

      it 'includes type if single value in Array' do
        allow(item).to receive(:type).and_return ['moving image']
        expect(helper.view_object_link(item)).to include('moving image')
      end

      it 'does not include type if multi-value in Array' do
        allow(item).to receive(:type).and_return ['type_a', 'type_b']
        expect(helper.view_object_link(item)).not_to include('type_a', 'type_b')
      end

      it 'includes data provider if String' do
        allow(item).to receive(:data_provider).and_return 'Coralville Library'
        expect(helper.view_object_link(item)).to include('Coralville Library')
      end

      it 'includes data provider if Array' do
        allow(item).to receive(:data_provider).and_return ['Winnie', 'Peaches']
        expect(helper.view_object_link(item)).to include('Winnie, Peaches')
      end
    end
  end
end
