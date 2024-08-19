# frozen_string_literal: true

require 'rspec'
require_relative '../student'
require_relative '../quiz'

RSpec.describe Student do
  let(:student) { described_class.new('John Doe', 'john@example.com', 'password') }
  let(:quiz) { Quiz.new('Sample Quiz') }
  let(:quizzes) { [quiz] }

  before do
    allow_any_instance_of(Student).to receive(:puts)
    allow_any_instance_of(Student).to receive(:print)
    allow_any_instance_of(Student).to receive(:gets).and_return('input')
  end

  describe '#options' do
    it 'prints the available options' do
      expect { student.options(quizzes) }.to output(/Choose an option:/).to_stdout
    end

    it 'returns "logout" when the user chooses to logout' do
      allow_any_instance_of(Student).to receive(:handle_student_options).and_return('logout')
      expect(student.options(quizzes)).to eq('logout')
    end
  end

  describe '#handle_student_options' do
    it 'handles the student options input and calls the corresponding method' do
      allow_any_instance_of(Student).to receive(:gets).and_return('1')
      expect(student).to receive(:attempt_quiz).with(quizzes)
      student.handle_student_options(quizzes)
    end
  end

  describe '#attempt_quiz' do
    it 'attempts a quiz and prints the score' do
      allow_any_instance_of(Student).to receive(:print)
      allow_any_instance_of(Student).to receive(:quiz_id_input).and_return(1)
      allow(quiz).to receive(:attempt).with(student.email).and_return(5)
      expect { student.attempt_quiz(quizzes) }.to output(/Quiz Attempted Successfully. Your score: 5/).to_stdout
    end

    it 'prints a message when no quizzes are available' do
      expect { student.attempt_quiz([]) }.to output(/No quizzes available!/).to_stdout
    end
  end

  describe '#view_attempts' do
    it 'views the attempts for the student' do
      allow_any_instance_of(Student).to receive(:puts)
      allow(quiz).to receive(:attempt_log).and_return({ student.email => ['Attempt 1'] })
      allow(quiz).to receive(:view_attempts).with(student.email).and_return(true)
      expect { student.view_attempts(quizzes) }.to output(/Quiz: Sample Quiz/).to_stdout
    end

    it 'prints a message when no attempts are found' do
      allow(quiz).to receive(:attempt_log).and_return({})
      expect { student.view_attempts(quizzes) }.to output(/No attempts found./).to_stdout
    end
  end

  describe '#view_quizzes_by_date' do
    it 'views quizzes by date' do
      allow_any_instance_of(Student).to receive(:gets).and_return('2024-08-15')
      allow(Date).to receive(:parse).and_return(Date.new(2024, 8, 15))
      allow(quiz).to receive(:available_on_date?).with(Date.new(2024, 8, 15)).and_return(true)
      expect { student.view_quizzes_by_date(quizzes) }.to output(/Quiz: Sample Quiz, Deadline:/).to_stdout
    end

    it 'prints a message when no quizzes are available on the given date' do
      allow_any_instance_of(Student).to receive(:gets).and_return('2024-08-15')
      allow(Date).to receive(:parse).and_return(Date.new(2024, 8, 15))
      allow(quiz).to receive(:available_on_date?).with(Date.new(2024, 8, 15)).and_return(false)
      expect { student.view_quizzes_by_date(quizzes) }.to output(/No quizzes available on this date./).to_stdout
    end
  end

  describe '#list_quizzes' do
    it 'lists all quizzes' do
      expect { student.list_quizzes(quizzes) }.to output(/Quiz ID: 1, Quiz Title: Sample Quiz/).to_stdout
    end
  end

  describe '#quiz_id_input' do
    it 'returns a valid quiz ID when input is correct' do
      allow_any_instance_of(Student).to receive(:gets).and_return('1')
      expect(student.quiz_id_input(quizzes)).to eq(1)
    end

    it 'repeats input prompt for invalid quiz ID' do
      allow_any_instance_of(Student).to receive(:gets).and_return('99', '1')
      expect(student.quiz_id_input(quizzes)).to eq(1)
    end
  end
end
