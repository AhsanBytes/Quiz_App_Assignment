# frozen_string_literal: true

require 'rspec'
require_relative '../quiz_app_main'

RSpec.describe Main do
  let(:main_instance) { described_class.new }

  before do
    # Prevent actual calls to exit during testing
    allow(main_instance).to receive(:exit)
  end

  describe '#process_signup_login_choice' do
    context 'when user selects sign up (1)' do
      it 'calls signup' do
        allow(main_instance).to receive(:gets).and_return("1\n")
        expect(main_instance).to receive(:signup)
        main_instance.process_signup_login_choice
      end
    end

    context 'when user selects login (2)' do
      it 'calls login' do
        allow(main_instance).to receive(:gets).and_return("2\n")
        expect(main_instance).to receive(:login)
        main_instance.process_signup_login_choice
      end
    end

    context 'when user selects exit (3)' do
      it 'calls exit' do
        allow(main_instance).to receive(:gets).and_return("3\n")
        expect(main_instance).to receive(:exit)
        main_instance.process_signup_login_choice
      end
    end

    context 'when user selects an invalid option' do
      it 'prints an error message' do
        allow(main_instance).to receive(:gets).and_return("5\n")
        expect(main_instance).to receive(:puts).with('Invalid option, please try again!')
        main_instance.process_signup_login_choice
      end
    end
  end

  describe '#signup' do
    before do
      allow(main_instance).to receive(:puts)
      allow(main_instance).to receive(:find_user_by_email).and_return(nil)
      allow(main_instance).to receive(:role_initialization_and_adding_to_storage)
    end

    it 'calls role_initialization_and_adding_to_storage with correct parameters' do
      allow(main_instance).to receive(:signup_input).and_return(['Name', 'email@example.com', 'password'])
      allow(main_instance).to receive(:role_checks).and_return(Teacher)
      expect(main_instance).to receive(:role_initialization_and_adding_to_storage).with(Teacher, 'Name', 'email@example.com', 'password')
      main_instance.signup
    end
  end

  describe '#login' do
    before do
      allow(main_instance).to receive(:puts)
      allow(main_instance).to receive(:find_user_by_credentials).and_return(nil)
    end
  end

  describe '#signup_login_options' do
    it 'prints the signup/login options' do
      expect { main_instance.signup_login_options }.to output("Choose an option: \n1. Sign Up\n2. Login\n3. Exit\n").to_stdout
    end
  end

  describe '#role_input' do
    it 'prints the role options' do
      expect { main_instance.role_input }.to output("Choose an Option: \n1. Teacher\n2. Student\n").to_stdout
    end
  end

  describe '#name_validation?' do
    it 'returns true for valid name' do
      expect(main_instance.name_validation?('John')).to eq(true)
    end

    it 'returns an error message for invalid name' do
      expect(main_instance.name_validation?('Jo')).to eq("Name should be 3 to 15 aplhabetic chars")
    end
  end

  describe '#email_validation?' do
    it 'returns true for valid email' do
      expect(main_instance.email_validation?('test@gmail.com')).to eq(true)
    end

    it 'prints an error message for invalid email' do
      expect { main_instance.email_validation?('test@com') }.to output("Enter Valid Email (Gmail Account only)\n").to_stdout
    end
  end

  describe '#password_validation?' do
    it 'returns true for valid password' do
      expect(main_instance.password_validation?('password123')).to eq(true)
    end

    it 'prints an error message for invalid password' do
      expect { main_instance.password_validation?('short') }.to output("Password should be 9 to 15 char\n").to_stdout
    end
  end

  describe '#valid_email' do
    before do
      allow(main_instance).to receive(:email_validation?).and_return(true)
    end

    it 'returns the email if valid' do
      allow(main_instance).to receive(:gets).and_return('test@example.com')
      expect(main_instance.valid_email).to eq('test@example.com')
    end
  end

  describe '#valid_password' do
    before do
      allow(main_instance).to receive(:password_validation?).and_return(true)
    end

    it 'returns the password if valid' do
      allow(main_instance).to receive(:gets).and_return('validpassword')
      expect(main_instance.valid_password).to eq('validpassword')
    end
  end

  describe '#find_user_by_email' do
    it 'finds a user by email' do
      user = double('User', email: 'test@example.com')
      main_instance.instance_variable_set(:@storage, { 'Teacher' => [user], 'Student' => [] })
      expect(main_instance.find_user_by_email('test@example.com')).to eq(user)
    end
  end

  describe '#find_user_by_credentials' do
    it 'finds a user by credentials' do
      user = double('User', email: 'test@example.com', password: 'password')
      allow(main_instance).to receive(:find_user_by_email).and_return(user)
      expect(main_instance.find_user_by_credentials('test@example.com', 'password')).to eq(user)
    end
  end

  describe '#role_initialization_and_adding_to_storage' do
    it 'adds a user to storage' do
      expect(main_instance).to receive(:puts).with('SignUp Successful!')
      main_instance.role_initialization_and_adding_to_storage(Teacher, 'Name', 'email@example.com', 'password')
    end
  end
end
