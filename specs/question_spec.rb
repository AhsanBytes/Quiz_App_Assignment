# frozen_string_literal: true

require 'rspec'
require_relative '../question'
require_relative '../option'

RSpec.describe Question do

  let(:question) { described_class.new('What is the capital of France?') }

  describe 'initialize' do
    it 'initializes with a statement and empty options' do
      expect(question.statement).to eq('What is the capital of France?')
      expect(question.options).to be_empty
      expect(question.correct_answer_index).to be_nil
    end
  end

  describe 'Initilaize_and_add_options_with_correct_answer' do
    before do
    allow_any_instance_of(described_class).to receive(:gets).and_return('Paris', 'London', 'Berlin', '1')
    question.add_options_with_correct_answer
    end

    context 'Add options and set correct answer' do
      it 'adds three options to the question' do
        expect(question.options.size).to eq(3)
        expect(question.options[0].text).to eq('Paris')
        expect(question.options[1].text).to eq('London')
        expect(question.options[2].text).to eq('Berlin')
      end

      it 'sets the correct answer based on user input' do
        expect(question.correct_answer_index).to eq(0)
      end
    end
  end

  describe '#set_correct_answer' do

    it 'sets the correct answer based on valid input' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('1')
      question.set_correct_answer
      expect(question.correct_answer_index).not_to eq(1)
    end

    it 'prompts for input until a valid option is selected' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('4', '2')
      question.set_correct_answer
      expect(question.correct_answer_index).not_to eq(2)
    end
  end

  describe '#new_statement_input' do
    it 'prompts for and returns a new question statement' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('What is the largest planet?')
      expect(question.new_statement_input).to eq('What is the largest planet?')
    end
  end

  describe '#add_options' do
    it 'it adds options to array' do
      allow(question).to receive(:gets).and_return('Option A')
      question.add_options(0)
      expect(question.options[0].text).to eq('Option A')

      allow(question).to receive(:gets).and_return('Option B')
      question.add_options(1)
      expect(question.options[1].text).to eq('Option B')
    end
  end

  describe '#process_choice' do
    context 'when choice is 1' do
      it 'updates the question statement' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('What is the smallest planet?')
        question.process_choice(1)
        expect(question.statement).to eq('What is the smallest planet?')
      end
    end

    context 'when choice is 2' do
      it 'clears and adds new options' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('Option X', 'Option Y', 'Option Z', '1')
        question.process_choice(2)
        expect(question.options.size).to eq(3)
        expect(question.options[0].text).to eq('Option X')
      end
    end

    context 'when choice is 3' do
      it 'sets the correct option' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('1')
        question.process_choice(3)
        expect(question.correct_answer_index).not_to eq(1)
      end
    end

    context 'when choice is invalid' do
      it 'prints an invalid choice message' do
        expect { question.process_choice(4) }.to output(/Invalid choice!/).to_stdout
      end
    end
  end

  describe '#multiple_edit_input' do
    it 'returns true if the user wants to edit something else' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('y')
      expect(question.multiple_edit_input).to be(true)
    end

    it 'returns false if the user does not want to edit anything else' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('n')
      expect(question.multiple_edit_input).to be(false)
    end

    it 'returns false if the user does not want to edit anything else' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('c')
      expect(question.multiple_edit_input).to be(false)
    end
  end
end
