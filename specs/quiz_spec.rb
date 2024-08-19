# frozen_string_literal: true

require 'rspec'
require_relative '../quiz'
require_relative '../question'
require_relative '../option'
require_relative '../student'

RSpec.describe Quiz do
  let(:quiz) { described_class.new('Sample Quiz', Date.today, 7) }
  let(:student) { Student.new('John Doe', 'john@example.com', 'password') }

  # let(:question1) do 
  #   question = Question.new('Random')
  #   question.options = [Option.new('Option1'), Option.new('Option2'),Option.new('Option3'), '1']
  #   [question]
  # end
  # it 'mocking add question' do
  #   allow_any_instance_of(Quiz).to receive(:add_question).and_return(question1)
  # end
  # it 'mocking add question' do
  #   allow_any_instance_of(Quiz).to receive(:questions).and_return(question1)
  # end
  before do
    allow_any_instance_of(Quiz).to receive(:puts)
    allow_any_instance_of(Quiz).to receive(:print)
    allow_any_instance_of(Quiz).to receive(:gets).and_return('input')
  end

  describe '#initialize' do
    it 'initializes with default values' do
      expect(quiz.title).to eq('Sample Quiz')
      expect(quiz.questions).to eq([])
      expect(quiz.published).to be(false)
      expect(quiz.locked).to be(false)
      expect(quiz.attempts).to eq(0)
      expect(quiz.instance_variable_get(:@attempt_log)).to eq({})
    end
  end

  describe '#create_question' do
    it 'creates a new question with user input' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('What is the capital of France?')
      expect(quiz.create_question.statement).to eq('What is the capital of France?')
    end
  end

  describe '#add_question' do
    it 'adds a question to the quiz' do
      allow_any_instance_of(Quiz).to receive(:create_question).and_return(double('Question', add_options_with_correct_answer: true))
      expect { quiz.add_question }.to change { quiz.questions.size }.by(1)
    end
  end

  describe '#question_edit_id_input' do
    it 'prompts user for question index to edit and returns the question' do
      question = double('Question')
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
      expect(quiz.question_edit_id_input).to eq(question)
    end

    it 'prints an error message for invalid index' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('99')
      expect { quiz.question_edit_id_input }.to output(/Invalid question index!/).to_stdout
    end
  end

  describe '#multiple_question_edit_input' do
    it 'returns true if user wants to edit another question' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('y')
      expect(quiz.multiple_question_edit_input).to be(true)
    end

    it 'returns false if user does not want to edit another question' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('n')
      expect(quiz.multiple_question_edit_input).to be(false)
    end
  end

  describe '#options_for_edit' do
    it 'prints options for editing the quiz' do
      expect { quiz.options_for_edit }.to output(/1. To edit Title of Quiz\n2. To edit question/).to_stdout
    end
  end

  describe '#new_quiz_title_input' do
    it 'prompts for a new quiz title and returns it' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('New Quiz Title')
      expect(quiz.new_quiz_title_input).to eq('New Quiz Title')
    end
  end

  describe '#handle_options_for_edit' do
    it 'updates the quiz title when input is 1' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1', 'New Quiz Title')
      quiz.handle_options_for_edit
      expect(quiz.title).to eq('New Quiz Title')
    end

    it 'edits a question when input is 2' do
      question = double('Question', edit: true)
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('2', '1')
      allow_any_instance_of(Quiz).to receive(:question_edit_id_input).and_return(question)
      expect(question).to receive(:edit)
      quiz.handle_options_for_edit
    end

    it 'prints invalid input message for invalid options' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('99')
      expect { quiz.handle_options_for_edit }.to output(/Invalid Input!/).to_stdout
    end
  end

  describe '#edit' do
    it 'calls handle_options_for_edit in a loop until the user decides to stop' do
      allow_any_instance_of(Quiz).to receive(:options_for_edit)
      allow_any_instance_of(Quiz).to receive(:handle_options_for_edit)
      allow_any_instance_of(Quiz).to receive(:multiple_question_edit_input).and_return(true, false)

      expect(quiz).to receive(:handle_options_for_edit).twice
      quiz.edit
    end
  end

  describe '#lock!' do
    context 'when quiz is already locked' do
      it 'prints a message that the quiz is already locked' do
        quiz.instance_variable_set(:@locked, true)
        expect { quiz.lock! }.to output(/Quiz already locked!/).to_stdout
      end
    end

    context 'when quiz is not locked' do
      it 'locks the quiz and prints a success message' do
        expect { quiz.lock! }.to change { quiz.locked }.from(false).to(true)
        expect { quiz.lock! }.to output(/Quiz Locked successfully!/).to_stdout
      end
    end
  end

  describe '#unlock!' do
    context 'when quiz is already unlocked' do
      it 'prints a message that the quiz is already unlocked' do
        expect { quiz.unlock! }.to output(/Quiz already unlocked!/).to_stdout
      end
    end

    context 'when quiz is locked' do
      it 'unlocks the quiz and prints a success message' do
        quiz.lock!
        expect { quiz.unlock! }.to change { quiz.locked }.from(true).to(false)
        expect { quiz.unlock! }.to output(/Quiz Unlocked successfully!/).to_stdout
      end
    end
  end

  describe '#publish!' do
    context 'when quiz is already published' do
      it 'prints a message that the quiz is already published' do
        quiz.publish!
        expect { quiz.publish! }.to output(/Quiz already published!/).to_stdout
      end
    end

    context 'when quiz is not published' do
      it 'publishes the quiz and prints a success message' do
        expect { quiz.publish! }.to change { quiz.published }.from(false).to(true)
        expect { quiz.publish! }.to output(/Quiz Published successfully!/).to_stdout
      end
    end
  end

  describe '#unpublish!' do
    context 'when quiz is already unpublished' do
      it 'prints a message that the quiz is already unpublished' do
        expect { quiz.unpublish! }.to output(/Quiz already unpublished!/).to_stdout
      end
    end

    context 'when quiz is published' do
      it 'unpublishes the quiz and prints a success message' do
        quiz.publish!
        expect { quiz.unpublish! }.to change { quiz.published }.from(true).to(false)
        expect { quiz.unpublish! }.to output(/Quiz Un-published successfully!/).to_stdout
      end
    end
  end

  describe '#attempt' do
    it 'records an attempt and updates the score' do
      question = double('Question', correct_answer_index: 1, options: [double('Option', text: 'Option 1')])
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
      expect { quiz.attempt(student.email) }.to change { quiz.attempts }.by(1)
      expect(quiz.instance_variable_get(:@attempt_log)[student.email].size).to eq(1)
    end
  end

  describe '#view_attempts' do
    it 'shows attempts for a student' do
      question = double('Question', correct_answer_index: 1, options: [double('Option', text: 'Option 1')])
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
      quiz.attempt(student.email)
      expect { quiz.view_attempts(student.email) }.to output(/Attempt Date: /).to_stdout
    end

    it 'prints no attempts message if no attempts found' do
      expect { quiz.view_attempts(student.email) }.to output(/No attempts found./).to_stdout
    end
  end

  describe '#view_all_attempts' do
    it 'shows all attempts for the quiz' do
      question = double('Question', correct_answer_index: 1, options: [double('Option', text: 'Option 1')])
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
      quiz.attempt(student.email)
      expect { quiz.view_all_attempts }.to output(/Attempts by #{student.email}/).to_stdout
    end

    it 'prints a message if no attempts have been made' do
      expect { quiz.view_all_attempts }.to output(/No attempts have been made for this quiz yet./).to_stdout
    end
  end

  describe '#list_questions' do
    it 'lists all questions with options' do
      option1 = double('Option', text: 'Option 1')
      question = double('Question', statement: 'Question 1', options: [option1])
      quiz.questions << question
      expect { quiz.list_questions }.to output(/Question 1: /).to_stdout
    end
  end
end
