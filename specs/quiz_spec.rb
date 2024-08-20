# frozen_string_literal: true

require 'rspec'
require_relative '../quiz'
require_relative '../question'
require_relative '../option'
require_relative '../student'

RSpec.describe Quiz do
  let(:quiz) { described_class.new('Sample Quiz', Date.today, 7) }
  let(:student) { Student.new('John Doe', 'john@example.com', 'password') }
  let(:teacher) { Teacher.new('Ahsan', 'ahsan@gmail.com', 'password') }

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

  describe '#question_edit_id_input' do
    it 'prompts user for question index to edit and returns the question' do
      question = double('Question')
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
      expect(quiz.question_edit_id_input).to eq(question)
    end

    it 'prints an error message for invalid index' do
      allow_any_instance_of(described_class).to receive(:loop).and_yield
      allow_any_instance_of(Quiz).to receive(:gets).and_return('99')
      expect { quiz.question_edit_id_input }.to output(/Invalid question index!/).to_stdout
    end
  end

  describe '#multiple_question_edit_input' do
    it 'returns true if user wants to edit another question' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('y')
      expect(quiz.multiple_question_input).to be(true)
    end

    it 'returns false if user does not want to edit another question' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('n')
      expect(quiz.multiple_question_input).to be(false)
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

    # it 'edits a question when input is 2' do
    #   question = double('Question')
    #   quiz.questions << question
    #   allow_any_instance_of(Quiz).to receive(:gets).and_return('2', '1')
    #   allow_any_instance_of(Quiz).to receive(:question_edit_id_input).and_return(question)
    #   quiz.handle_options_for_edit
    # end

    it 'prints invalid input message for invalid options' do
      allow_any_instance_of(Quiz).to receive(:gets).and_return('99')
      expect { quiz.handle_options_for_edit }.to output(/Invalid Input!/).to_stdout
    end
  end

  describe '#lock!' do
    context 'quiz is locked successfully by asking user yes or no' do
      it 'print that quiz is locked succesfully' do
        allow_any_instance_of(Quiz).to receive(:common_input_for_publish_lock).and_return('y')
        expect { quiz.lock! }.to output(/Quiz Locked successfully!/).to_stdout
      end
    end

    context 'quiz lokcked without confirmation' do
      it 'locks the quiz' do
        expect { quiz.lock!(false) }.to change { quiz.locked }.from(false).to(true)
      end
    end
  end

  describe '#unlock!' do
    context 'when quiz is already unlocked' do
      it 'prints a message that the quiz is already unlocked' do
        allow_any_instance_of(Quiz).to receive(:common_input_for_publish_lock).and_return('y')
        expect { quiz.unlock! }.to output(/Quiz Unlocked successfully!/).to_stdout
      end
    end
  end

  describe '#publish!' do
    context 'when quiz is already published' do
      it 'prints a message that the quiz is already published' do
        allow_any_instance_of(Quiz).to receive(:common_input_for_publish_lock).and_return('y')
        expect { quiz.publish! }.to output(/Quiz Published successfully!/).to_stdout
      end
    end

    context 'when quiz is not published' do
      it 'publishes the quiz and prints a success message' do
        expect { quiz.publish!(false) }.to change { quiz.published }.from(false).to(true)
      end
    end
  end

  describe '#unpublish!' do
    context 'when quiz is already unpublished' do
      it 'prints a message that the quiz is already unpublished' do
        allow_any_instance_of(Quiz).to receive(:common_input_for_publish_lock).and_return('y')
        expect { quiz.unpublish! }.to output(/Quiz Un-published successfully!/).to_stdout
      end
    end
  end

  describe '#attempt' do
  it 'records an attempt and updates the score' do
    allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
    expect { quiz.attempt(student) }.to change { quiz.attempts }.by(1)
    expect(quiz.instance_variable_get(:@attempt_log)[student.email].size).to eq(1)
  end
end

  describe '#view_attempts' do
    it 'shows attempts for a student' do
      question = double('Question', statement: 'Sample Question', correct_answer_index: 1, options: [double('Option', text: 'Option 1')])
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
      quiz.attempt(student)
      expect { quiz.view_attempts(student.email) }.to output(/Attempt Date: /).to_stdout
    end
  end

  describe '#view_all_attempts' do
    it 'shows all attempts for the quiz' do
      question = double('Question', statement: 'Sample Question', correct_answer_index: 1, options: [double('Option', text: 'Option 1')])
      quiz.questions << question
      allow_any_instance_of(Quiz).to receive(:gets).and_return('1')
      quiz.attempt(student)
      expect { quiz.view_all_attempts }.to output(/Attempts by #{student.email}/).to_stdout
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
