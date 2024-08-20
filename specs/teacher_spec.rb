# frozen_string_literal: true

require 'rspec'
require_relative '../teacher'
require_relative '../quiz'

RSpec.describe Teacher do
  subject(:teacher) {described_class.new('Jane Doe', 'jane@example.com', 'password')}

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
    it 'logs out when choice is 8' do
      allow(teacher).to receive(:gets).and_return('8')
      result = teacher.handle_teacher_options
      expect(result).to eq('Logging out...')
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

  describe '#create_quiz' do

    before do
      allow_any_instance_of(described_class).to receive(:loop).and_yield
    end

    describe '#quiz_title_input' do
    it 'puts error message if title is empty' do
      allow_any_instance_of(Teacher).to receive(:gets).and_return('')
      expect { teacher.quiz_title_input }.to output(/Title must contain alphabets and spaces/).to_stdout
    end

    it 'accepts a valid title' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('Valid Title')
      expect(teacher.quiz_title_input).to eq('Valid Title')
    end

    it 'puts error message if title contains non-alphabetic characters' do
      allow_any_instance_of(described_class).to receive(:gets).and_return('Invalid123')
      expect { teacher.quiz_title_input }.to output(/Title must contain alphabets and spaces/).to_stdout
    end
  end

    context 'quiz_title_input' do
      it 'puts error message if title is empty' do
        allow_any_instance_of(described_class).to receive(:gets).and_return('')
        expect { teacher.quiz_title_input }.to output(/Title must contain alphabets and spaces/).to_stdout
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
end
