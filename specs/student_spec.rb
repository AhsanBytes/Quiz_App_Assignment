# frozen_string_literal: true

require 'rspec'
require_relative '../student'
require_relative '../quiz'

RSpec.describe Student do
  let(:student) { described_class.new('John Doe', 'john@example.com', 'password') }
  let(:quiz) { Quiz.new('Sample Quiz', Time.now, 3) }
  let(:quizzes) { [quiz] }

  describe '#options' do
    it 'prints the available options' do
      allow(student).to receive(:handle_student_options).and_return(true)
      allow_any_instance_of(described_class).to receive(:loop).and_yield
      expected_output = <<~OUTPUT
        Choose an option: 
        1. Attempt Quiz
        2. View Attempts
        3. View Quizzes by date
        4. List all quizzes
        5. Logout
        6. Exit
      OUTPUT

      expect { student.options(nil) }.to output(expected_output).to_stdout
    end

    it 'returns "logout" when the user chooses to logout' do
      allow_any_instance_of(Student).to receive(:gets).and_return('5')
      expect(student.handle_student_options(quizzes)).to eq('Logging out...')
    end
  end

  describe '#handle_student_options' do 
    it 'Attempt when choice is 1' do
      allow(student).to receive(:gets).and_return('1')
      result = student.handle_student_options(quizzes)
      expect(result).to be_nil
    end
  end

  describe '#attempt_quiz' do
    it 'prints a message when no quizzes are available' do
      expect { student.attempt([]) }.to output(/No quizzes available!/).to_stdout
    end
  end

  describe '#view_attempts' do
    it 'prints a message when no attempts are found' do
      allow(quiz).to receive(:attempt_log).and_return({})
      expect { student.view_attempts(quizzes) }.to output(/No attempts found for this quiz./).to_stdout
    end
  end

  describe '#list_quizzes' do
    it 'lists all quizzes' do
      expect { student.print(quizzes) }.to output(/Quiz ID: 1, Quiz Title: Sample Quiz/).to_stdout
    end
  end

  describe '#quiz_id_input' do
    it 'returns a valid quiz ID when input is correct' do
      allow_any_instance_of(Student).to receive(:gets).and_return('1')
      expect(student.quiz_id_input(quizzes)).to eq(0)
    end

    it 'repeats input prompt for invalid quiz ID' do
      allow_any_instance_of(Student).to receive(:gets).and_return('99', '1')
      expect(student.quiz_id_input(quizzes)).to eq(0)
    end
  end
end
