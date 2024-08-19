# frozen_string_literal: true

require 'rspec'
require_relative '../teacher'
require_relative '../quiz'

RSpec.describe Teacher do
  subject(:teacher) {described_class.new('Jane Doe', 'jane@example.com', 'password')}

  let(:quiz1) { instance_double(Quiz, title: 'Math Quiz', published: false, locked: false, attempts: 2) }
  let(:quiz2) { instance_double(Quiz, title: 'Science Quiz', published: true, locked: true, attempts: 0) }

  before do
    teacher.instance_variable_set(:@quizzes, [quiz1, quiz2])
  end

  describe 'checking attr_reader' do

    it 'allow reading for name, email, password' do
      expect(teacher.name).to eql('Jane Doe')
      expect(teacher.email).to eql('jane@example.com')
      expect(teacher.password).to eql('password')
    end

    it 'Dont allow writing name, email, password' do
      expect { teacher.name = 'Ahsan' }.to raise_error(NoMethodError)
      expect { teacher.email = 'ahsan@gmail.com'}.to raise_error(NoMethodError)
      expect { teacher.password = 'ahsan123' }.to raise_error(NoMethodError)
    end

  end

  describe '#options' do

    it 'outputs the options menu to the console' do
      allow(teacher).to receive(:handle_teacher_options).and_return(true)
      allow_any_instance_of(described_class).to receive(:loop).and_yield

      expected_output = <<~OUTPUT
        Choose an option: 
        1. Create Quiz
        2. Edit Quiz
        3. Publish Quiz
        4. Un-publish Quiz
        5. Lock Quiz
        6. Unlock Quiz
        7. View Attempts
        8. Logout
        9. Exit
      OUTPUT

      expect { teacher.options(nil) }.to output(expected_output).to_stdout
    end

  end

  describe '#handle_teacher_options' do 

    it 'creates a quiz when choice is 1' do
      allow(teacher).to receive(:gets).and_return('1')
      expect(teacher).to receive(:create_quiz)
      result = teacher.handle_teacher_options
      expect(result).to be_nil
    end

    it 'logs out when choice is 8' do
      allow(teacher).to receive(:gets).and_return('8')
      result = teacher.handle_teacher_options
      expect(result).to eq('logout')
    end

    it 'exits the program when choice is 9' do
      allow(teacher).to receive(:gets).and_return('9')
      expect { teacher.handle_teacher_options }.to raise_error(SystemExit)
    end

    it 'shows an invalid option message for an invalid choice' do
      allow(teacher).to receive(:gets).and_return('99')
      expect { teacher.handle_teacher_options }.to output(/Invalid option, please try again!/).to_stdout
    end

  end

  describe 'create_quiz' do

    before do
      allow_any_instance_of(described_class).to receive(:loop).and_yield
    end

    context 'quiz_title_input' do
      it 'puts error message if title is empty' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('')
        expect { teacher.quiz_title_input }.to output(/Title cannot be empty./).to_stdout
      end

      it 'puts error message if title contains non-alphabetic characters' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('123')
        expect { teacher.quiz_title_input }.to output(/Title must only contain alphabets and spaces./).to_stdout
      end

      it 'puts error message if title contains non-alphabetic characters' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('abc')
        expect(teacher.quiz_title_input).to eq('abc')
      end

    end

    context '#quiz_availability_input' do
      
      it 'shows message of invalid input' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('a2')
        expect { teacher.quiz_availability_input }.to output(/Invalid input! Please enter a valid number of days./).to_stdout
      end

      it 'works as valid input for single digit' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('2')
        expect(teacher.quiz_availability_input).to eq(2)
      end

      it 'works as valid input for two digits' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('12')
        expect(teacher.quiz_availability_input).to eq(12)
      end

    end

  end

  describe '#edit_quiz' do
    before do
      teacher.instance_variable_set(:@quizzes, [quiz1, quiz2])
      allow_any_instance_of(described_class).to receive(:helper_listing_quizzes).and_call_original
    end

    it 'lists all quizzes and allows editing' do
      allow(teacher).to receive(:list_all_quizzes).and_call_original
      allow(teacher).to receive(:quiz_id_input).and_return(quiz1)
      allow(quiz1).to receive(:edit)
      
      expect(teacher).to have_received(:list_all_quizzes)
      expect(teacher).to have_received(:quiz_id_input).with(teacher.instance_variable_get(:@quizzes))
      expect(quiz1).to have_received(:edit)
    end

    it 'shows a message when there are no quizzes to edit' do
      teacher.instance_variable_set(:@quizzes, [])
      expect { teacher.edit_quiz }.to output(/No quizzes available to edit!/).to_stdout
    end
  end

  describe '#publish_quiz' do
    it 'publishes a quiz that is not already published' do
      allow(quiz1).to receive(:publish!).with(false)
      expect { teacher.publish_quiz }.to output(/Quiz created Successfully!/).to_stdout
    end

    it 'shows no quizzes message if all quizzes are already published' do
      allow(quiz1).to receive(:published).and_return(true)
      expect { teacher.publish_quiz }.to output(/No quizzes to show for action/).to_stdout
    end
  end

  describe '#unpublish_quiz' do
    it 'unpublishes a quiz that is published' do
      allow(quiz2).to receive(:unpublish!).with(false)
      expect { teacher.unpublish_quiz }.to output(/Quiz created Successfully!/).to_stdout
    end

    it 'shows no quizzes message if no quizzes are published' do
      allow(quiz2).to receive(:published).and_return(false)
      expect { teacher.unpublish_quiz }.to output(/No quizzes to show for action/).to_stdout
    end
  end

  describe '#lock_quiz' do
    it 'locks a quiz that is not locked' do
      allow(quiz1).to receive(:lock!).with(false)
      expect { teacher.lock_quiz }.to output(/Quiz created Successfully!/).to_stdout
    end

    it 'shows no quizzes message if all quizzes are already locked' do
      allow(quiz1).to receive(:locked).and_return(true)
      expect { teacher.lock_quiz }.to output(/No quizzes to show for action/).to_stdout
    end
  end

  describe '#unlock_quiz' do
    it 'unlocks a quiz that is locked' do
      allow(quiz2).to receive(:unlock!).with(false)
      expect { teacher.unlock_quiz }.to output(/Quiz created Successfully!/).to_stdout
    end

    it 'shows no quizzes message if no quizzes are locked' do
      allow(quiz2).to receive(:locked).and_return(false)
      expect { teacher.unlock_quiz }.to output(/No quizzes to show for action/).to_stdout
    end
  end

  describe '#view_attempts' do
    it 'views attempts for quizzes with attempts' do
      allow(quiz1).to receive(:view_all_attempts)
      expect { teacher.view_attempts }.to output(/Viewing attempts for Quiz ID: 1, Title: Math Quiz/).to_stdout
    end

    it 'shows no attempts message for quizzes with zero attempts' do
      expect { teacher.view_attempts }.to output(/No attempts found for this quiz./).to_stdout
    end
  end

end
