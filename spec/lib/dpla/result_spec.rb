require 'spec_helper'

describe DPLA::Result do
  subject { DPLA::Result }

  let(:response) do
    { 'count' => 12, 'limit' => 10, 'start' => 0, 'docs' => Array.new(10, {}) }
  end

  describe '#position_after' do
    it 'returns position of next item in search results' do
      result = subject.new(response)
      expect(result.position_after(9)).to eq 10
    end

    it 'returns nil if no next item' do
      response['count'] = 10
      result = subject.new(response)
      expect(result.position_after(9)).to eq nil
    end

    it 'recognizes pages' do
      response['start'] = 10
      result = subject.new(response)
      expect(result.position_after(0)).to eq 11
    end
  end

  describe '#position_before' do
    it 'returns position of previous item in search results' do
      result = subject.new(response)
      expect(result.position_before(1)).to eq 0
    end

    it 'returns nil if no previous item' do
      result = subject.new(response)
      expect(result.position_before(0)).to eq nil
    end

    it 'returns correct position if previous item is on previous page' do
      response['start'] = 10
      result = subject.new(response)
      expect(result.position_before(0)).to eq 9
    end
  end
end
