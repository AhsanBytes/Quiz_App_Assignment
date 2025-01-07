# frozen_string_literal: true

require 'rspec'
require_relative '../user'

RSpec.describe User do
  let(:user1) { described_class.new('name', 'email', 'password') }
  let(:user2) { described_class.new('Ahsan', 'ahsan@gmail.com', '123456789') }

  describe '#initialize' do
    it 'creates an instance of User class' do
      expect(user1).to be_a(described_class)
    end

    it 'assigns name, email, and password correctly' do
      expect(user2.name).to eq('Ahsan')
      expect(user2.email).to eq('ahsan@gmail.com')
      expect(user2.password).to eq('123456789')
    end
  end

  describe 'attr_reader methods' do
    it 'allows reading of the name attribute' do
      expect(user1.name).to eq('name')
    end

    it 'allows reading of the email attribute' do
      expect(user1.email).to eq('email')
    end

    it 'allows reading of the password attribute' do
      expect(user1.password).to eq('password')
    end
  end

  describe 'edge cases' do
    context 'when attributes are empty strings' do
      let(:user_with_empty_attributes) { described_class.new('', '', '') }

      it 'allows name, email, and password to be empty strings' do
        expect(user_with_empty_attributes.name).to eq('')
        expect(user_with_empty_attributes.email).to eq('')
        expect(user_with_empty_attributes.password).to eq('')
      end
    end

    context 'when attributes are nil' do
      let(:user_with_nil_attributes) { described_class.new(nil, nil, nil) }

      it 'allows name, email, and password to be nil' do
        expect(user_with_nil_attributes.name).to be_nil
        expect(user_with_nil_attributes.email).to be_nil
        expect(user_with_nil_attributes.password).to be_nil
      end
    end

    context 'when attributes are very long strings' do
      let(:long_string) { 'a' * 10 }
      let(:user_with_long_attributes) { described_class.new(long_string, long_string, long_string) }

      it 'handles long strings for name, email, and password' do
        expect(user_with_long_attributes.name).to eq(long_string)
        expect(user_with_long_attributes.email).to eq(long_string)
        expect(user_with_long_attributes.password).to eq(long_string)
      end
    end
  end

  describe 'immutability of attributes' do
    it 'does not allow modification of the name attribute' do
      expect { user1.name = 'New Name' }.to raise_error(NoMethodError)
    end

    it 'does not allow modification of the email attribute' do
      expect { user1.email = 'newemail@example.com' }.to raise_error(NoMethodError)
    end

    it 'does not allow modification of the password attribute' do
      expect { user1.password = 'newpassword' }.to raise_error(NoMethodError)
    end
  end
end
