# frozen_string_literal: true

# class for similary functionality for student and teacher
class User
  attr_reader :name, :email, :password

  def initialize(name, email, password)
    @name = name
    @email = email
    @password = password
  end
end
