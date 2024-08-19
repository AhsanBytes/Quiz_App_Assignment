# frozen_string_literal: true

require 'rspec'
require_relative '../quiz_app_main'
require_relative '../teacher'
require_relative '../student'

RSpec.describe Main do
  let(:main) { described_class.new }

  before do
    allow_any_instance_of(Main).to receive(:puts)
    allow_any_instance_of(Main).to receive(:print)
    allow_any_instance_of(Main).to receive(:gets).and_return('input')
  end

  describe '#initialize' do
    it 'initializes with empty storage and no current user' do
      expect(main.instance_variable_get(:@storage)).to eq({ 'Teacher' => [], 'Student' => [] })
      expect(main.instance_variable_get(:@current_user)).to be_nil
    end
  end

  describe '#signup_login_options' do
    it 'prints signup, login, and exit options' do
      expect { main.signup_login_options }.to output(/Choose an option: \n1. Sign Up\n2. Login\n3. Exit/).to_stdout
    end
  end

  describe '#name_validation?' do
    context 'when name is too short' do
      it 'returns false and prints error message' do
        allow_any_instance_of(Main).to receive(:gets).and_return('Jo')
        expect(main.name_validation?('Jo')).to be(false)
        expect { main.name_validation?('Jo') }.to output(/Re-enters correct name! \(Should be 3 to 15 char\)/).to_stdout
      end
    end

    context 'when name contains non-alphabetic characters' do
      it 'returns false and prints error message' do
        allow_any_instance_of(Main).to receive(:gets).and_return('John123')
        expect(main.name_validation?('John123')).to be(false)
        expect { main.name_validation?('John123') }.to output(/Name must be Alphabetic!/).to_stdout
      end
    end

    context 'when name is valid' do
      it 'returns true' do
        expect(main.name_validation?('John')).to be(true)
      end
    end
  end

  describe '#email_validation?' do
    context 'when email is valid' do
      it 'returns true' do
        expect(main.email_validation?('test@gmail.com')).to be(true)
      end
    end

    context 'when email is invalid' do
      it 'returns false and prints error message' do
        allow_any_instance_of(Main).to receive(:gets).and_return('invalid_email')
        expect(main.email_validation?('invalid_email')).to be(false)
        expect { main.email_validation?('invalid_email') }.to output(/Enter Valid Email \(Gmail Account only\)/).to_stdout
      end
    end
  end

  describe '#password_validation?' do
    context 'when password is too short' do
      it 'returns false and prints error message' do
        expect(main.password_validation?('short')).to be(false)
        expect { main.password_validation?('short') }.to output(/Password should be 9 to 15 char/).to_stdout
      end
    end

    context 'when password is valid' do
      it 'returns true' do
        expect(main.password_validation?('validpassword')).to be(true)
      end
    end
  end

  describe '#valid_email' do
    it 'returns a valid email' do
      allow_any_instance_of(Main).to receive(:gets).and_return('test@gmail.com')
      expect(main.valid_email).to eq('test@gmail.com')
    end
  end

  describe '#valid_password' do
    it 'returns a valid password' do
      allow_any_instance_of(Main).to receive(:gets).and_return('validpassword')
      expect(main.valid_password).to eq('validpassword')
    end
  end

  describe '#common_input' do
    it 'returns valid email and password' do
      allow_any_instance_of(Main).to receive(:valid_email).and_return('test@gmail.com')
      allow_any_instance_of(Main).to receive(:valid_password).and_return('validpassword')
      expect(main.common_input).to eq(['test@gmail.com', 'validpassword'])
    end
  end

  describe '#role_input' do
    it 'prints role options' do
      expect { main.role_input }.to output(/Choose an Option: \n1. Teacher\n2. Student/).to_stdout
    end
  end

  describe '#signup_input' do
    it 'prompts for user details and returns them' do
      allow_any_instance_of(Main).to receive(:name_validation?).and_return(true)
      allow_any_instance_of(Main).to receive(:common_input).and_return(['test@gmail.com', 'validpassword'])
      allow_any_instance_of(Main).to receive(:role_input)

      expect(main.signup_input).to eq(['input', 'test@gmail.com', 'validpassword'])
    end
  end

  describe '#role_initialization_and_adding_to_storage' do
    it 'creates a new role instance and adds it to storage' do
      allow_any_instance_of(Teacher).to receive(:new).and_return(double('Teacher', name: 'Test', email: 'test@example.com', password: 'password'))
      expect { main.role_initialization_and_adding_to_storage(Teacher, 'Test', 'test@example.com', 'password') }.to change { main.instance_variable_get(:@storage)['Teacher'].size }.by(1)
    end
  end

  describe '#signup' do
    it 'calls role_initialization_and_adding_to_storage with valid role' do
      allow_any_instance_of(Main).to receive(:signup_input).and_return(['Test', 'test@example.com', 'password'])
      allow_any_instance_of(Main).to receive(:gets).and_return('1') # Teacher
      expect(main).to receive(:role_initialization_and_adding_to_storage).with(Teacher, 'Test', 'test@example.com', 'password')
      main.signup
    end

    it 'prints an invalid role message if role is invalid' do
      allow_any_instance_of(Main).to receive(:signup_input).and_return(['Test', 'test@example.com', 'password'])
      allow_any_instance_of(Main).to receive(:gets).and_return('3') # Invalid role
      expect { main.signup }.to output(/Invalid role! Please select 1 for Teacher or 2 for Student./).to_stdout
    end
  end

  describe '#login' do
    it 'sets @current_user if credentials are valid' do
      teacher = Teacher.new('Test', 'test@example.com', 'password')
      main.instance_variable_set(:@storage, { 'Teacher' => [teacher], 'Student' => [] })
      allow_any_instance_of(Main).to receive(:common_input).and_return(['test@example.com', 'password'])
      expect(main).to receive(:find_user_by_credentials).with('test@example.com', 'password').and_return(teacher)
      main.login
      expect(main.instance_variable_get(:@current_user)).to eq(teacher)
    end

    it 'prints a no email message if credentials are invalid' do
      allow_any_instance_of(Main).to receive(:common_input).and_return(['test@example.com', 'wrongpassword'])
      expect { main.login }.to output(/No email exist, SignUp first/).to_stdout
    end
  end

  describe '#find_user_by_email' do
    it 'returns user by email if found' do
      teacher = Teacher.new('Test', 'test@example.com', 'password')
      main.instance_variable_set(:@storage, { 'Teacher' => [teacher], 'Student' => [] })
      expect(main.find_user_by_email('test@example.com')).to eq(teacher)
    end

    it 'returns nil if email not found' do
      expect(main.find_user_by_email('nonexistent@example.com')).to be_nil
    end
  end

  describe '#verify_user_password' do
    it 'returns true if password matches' do
      teacher = Teacher.new('Test', 'test@example.com', 'password')
      expect(main.verify_user_password(teacher, 'password')).to be(true)
    end

    it 'returns false if password does not match' do
      teacher = Teacher.new('Test', 'test@example.com', 'password')
      expect(main.verify_user_password(teacher, 'wrongpassword')).to be(false)
    end
  end

  describe '#find_user_by_credentials' do
    it 'returns user if credentials are valid' do
      teacher = Teacher.new('Test', 'test@example.com', 'password')
      main.instance_variable_set(:@storage, { 'Teacher' => [teacher], 'Student' => [] })
      expect(main.find_user_by_credentials('test@example.com', 'password')).to eq(teacher)
    end

    it 'returns nil if credentials are invalid' do
      expect(main.find_user_by_credentials('test@example.com', 'wrongpassword')).to be_nil
    end
  end

  describe '#handle_signup_login_options' do
    it 'calls process_signup_login_choice with user choice' do
      allow_any_instance_of(Main).to receive(:user_choice).and_return(1)
      expect(main).to receive(:process_signup_login_choice).with(1)
      main.handle_signup_login_options
    end
  end

  describe '#user_choice' do
    it 'returns the user choice from input' do
      allow_any_instance_of(Main).to receive(:gets).and_return('1')
      expect(main.user_choice).to eq(1)
    end
  end

  describe '#process_signup_login_choice' do
    it 'calls signup when choice is 1' do
      allow_any_instance_of(Main).to receive(:signup)
      expect(main).to receive(:signup)
      main.process_signup_login_choice(1)
    end

    it 'calls login when choice is 2' do
      allow_any_instance_of(Main).to receive(:login)
      expect(main).to receive(:login)
      main.process_signup_login_choice(2)
    end

    it 'exits when choice is 3' do
      expect { main.process_signup_login_choice(3) }.to raise_error(SystemExit)
    end

    it 'prints invalid option message for invalid choice' do
      expect { main.process_signup_login_choice(4) }.to output(/Invalid option, please try again!/).to_stdout
    end
  end

  describe '#logout' do
    it 'sets @current_user to nil' do
      main.instance_variable_set(:@current_user, double('User'))
      expect { main.logout }.to change { main.instance_variable_get(:@current_user) }.from(double('User')).to(nil)
    end
  end

  describe '#published_unlocked_quizzes' do
    it 'returns quizzes from teachers if current_user is a student' do
      student = Student.new('Student', 'student@example.com', 'password')
      teacher = double('Teacher', list_published_quizzes: ['Quiz1'], list_unlocked_quizzes: ['Quiz2'])
      main.instance_variable_set(:@current_user, student)
      main.instance_variable_set(:@storage, { 'Teacher' => [teacher], 'Student' => [student] })
      expect(main.published_unlocked_quizzes).to eq(['Quiz2'])
    end

    it 'returns empty array if current_user is a teacher' do
      teacher = Teacher.new('Teacher', 'teacher@example.com', 'password')
      main.instance_variable_set(:@current_user, teacher)
      expect(main.published_unlocked_quizzes).to eq([])
    end
  end

  describe '#main' do
    it 'runs the loop and handles user interactions' do
      allow_any_instance_of(Main).to receive(:signup_login_options)
      allow_any_instance_of(Main).to receive(:handle_signup_login_options)
      allow_any_instance_of(Main).to receive(:logout)
      expect(main).to receive(:signup_login_options).twice
      expect(main).to receive(:handle_signup_login_options).twice
      expect(main).to receive(:logout).once
      main.main
    end
  end
end
