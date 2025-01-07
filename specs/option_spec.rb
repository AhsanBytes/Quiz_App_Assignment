# frozen_string_literal: true

require 'rspec'
require_relative '../option'

RSpec.describe Option do
  let(:option1) { described_class.new('Option 1') }

  describe '#initialize' do
    it 'checking instance is of Option class' do
      expect(option1).to be_an(Option)
    end

    it 'assigns text correctly during initialization' do
      expect(option1.text).to eq('Option 1')
    end
  end

  describe 'attr_accessor :text' do
    it 'allows reading the text attribute' do
      expect(option1.text).to eq('Option 1')
    end

    it 'allows modifying the text attribute' do
      expect { option1.text = 'New Option 1' }.to change { option1.text }.from('Option 1').to('New Option 1')
    end
  end

  describe 'edge cases' do
    context 'when text is an empty string' do
      let(:option_with_empty_text) { described_class.new('') }

      it 'allows text to be an empty string' do
        expect(option_with_empty_text.text).to eq('')
      end
    end

    context 'when text is nil' do
      let(:option_with_nil_text) { described_class.new(nil) }

      it 'allows text to be nil' do
        expect(option_with_nil_text.text).to be_nil
      end
    end

    context 'when text is a very long string' do
      let(:long_string) { 'a' * 20 }
      let(:option_with_long_text) { described_class.new(long_string) }

      it 'handles long strings for text attribute' do
        expect(option_with_long_text.text).to eq(long_string)
      end
    end
  end
end
