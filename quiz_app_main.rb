# frozen_string_literal: true

require_relative 'teacher'
require_relative 'student'
# class for controlling all flow
class Main
  def initialize
    @storage = { 'Teacher' => [], 'Student' => [] }
    @current_user = nil
  end

  def main
    loop do
      if @current_user
        @current_user.options(published_unlocked_quizzes)
        logout 
      else
        signup_login_options
        process_signup_login_choice
      end
    end
  end

  ROLE_MAP = { 1 => Teacher, 2 => Student }

  def signup_login_options
    puts 'Choose an option: '
    puts '1. Sign Up'
    puts '2. Login'
    puts '3. Exit'
  end

  def name_validation?(name)
    return "Name should be 3 to 15 aplhabetic chars" unless name.match?(/^[a-zA-Z]{3,15}$/)

    true
  end

  def email_validation?(email)
    return puts 'Enter Valid Email (Gmail Account only)' unless email.match?(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
    
    true
  end

  def password_validation?(password)
    return puts 'Password should be 9 to 15 char' unless password.length.between?(9, 15)

    true
  end

  def valid_email
    loop do
      print 'Enter your Email: '
      email = gets.strip
      break email if email_validation?(email)
    end
  end

  def valid_password
    loop do
      print 'Enter your Password: '
      password = gets.strip
      break password if password_validation?(password)
    end
  end

  def find_user_by_email(email)
    @storage.values.flatten.find { |u| u.email == email }
  end

  def find_user_by_credentials(email, password)
    user = find_user_by_email(email)
    user if user&.password == password
  end

  def role_input
    puts 'Choose an Option: '
    puts '1. Teacher'
    puts '2. Student'
  end

  def signup_input
    return 'You must be logged-out to SignUp for another email! ' if @current_user

    loop do
      print 'Enter your Name: '
      name = gets.strip
      break if name_validation?(name)
    end
    email = valid_email
    user = find_user_by_email(email)
    if user
      puts 'Email already exists!'
      return signup_login_options
    end
    password = valid_password
    [name, email, password]
  end

  def role_checks
    loop do
      role_input
      role = gets.strip.to_i
      role_class = ROLE_MAP[role]
      return role_class if role_class
      puts 'Invalid role! Please select 1 for Teacher or 2 for Student.'
    end
  end

  def signup
    name, email, password = signup_input    
    role_initialization_and_adding_to_storage(role_checks, name, email, password)
  end

  def login
    user = find_user_by_credentials(valid_email, valid_password)
    if user
      @current_user = user
      puts 'Login Successful!'
    else
      puts 'No email exist, SignUp first'
    end
  end

  def process_signup_login_choice
    case gets.strip.to_i
    when 1 then signup
    when 2 then login
    when 3 then exit
    else
      puts 'Invalid option, please try again!'
    end
  end

  def logout
    @current_user = nil
    puts 'You have been logged out!'
  end

  def published_unlocked_quizzes
    quizzes = []
    return quizzes if @current_user.is_a?(Teacher)
  
    @storage['Teacher'].each do |teacher|
      published_quizzes = teacher.select_quizzes(teacher.quizzes, :published)
      teacher.reject_quizzes(published_quizzes, :locked).each do |quiz|
        if Date.today <= quiz.deadline
          quizzes << quiz unless quizzes.include?(quiz)
        end
      end
    end
    quizzes
  end

  def role_initialization_and_adding_to_storage(role_class, name, email, password)
    instance = role_class.new(name, email, password)
    role_key = role_class.name
    @storage[role_key] << instance
    puts 'SignUp Successful!'
  end

  def default_users
    password = '123456789'
    role_initialization_and_adding_to_storage(Teacher, 'Ahsan', 'ahsan@gmail.com', password)
    role_initialization_and_adding_to_storage(Student, 'Ans', 'ans@gmail.com', password)
  end
end

if __FILE__ == $0
  obj = Main.new
  obj.default_users
  obj.main
end
