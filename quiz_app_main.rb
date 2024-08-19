# frozen_string_literal: true

require_relative 'teacher'
require_relative 'student'
# class for controlling all flow
class Main
  def initialize
    @storage = { 'Teacher' => [], 'Student' => [] }
    @current_user = nil
  end

  private

  ROLE_MAP = { 1 => Teacher, 2 => Student }

  def signup_login_options
    puts 'Choose an option: '
    puts '1. Sign Up'
    puts '2. Login'
    puts '3. Exit'
  end

  def name_validation?(name)
    if name.length <= 2 || name.length > 15
      puts 'Re-enters correct name!(Should be 3 to 15 char)'
      false
    elsif !name.match?(/[a-zA-Z]/)
      puts 'Name must be Alphabetic!'
      false
    else
      true
    end
  end

  def email_validation?(email)
    if email.match?(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      true
    else
      puts 'Enter Valid Email (Gmail Account only)'
      false
    end
  end

  def password_validation?(password)
    if password.length <= 8 || password.length > 15
      puts 'Password should be 9 to 15 char'
      false
    else
      true
    end
  end

  def valid_email
    email = ''
    loop do
      print 'Enter your Email: '
      email = gets.strip
      break if email_validation?(email)
    end
    email
  end

  def valid_password
    password = ''
    loop do
      print 'Enter your Password: '
      password = gets.strip
      break if password_validation?(password)
    end
    password
  end

  def find_user_by_email(email)
    @storage.each_value do |array|
      user = array.find { |u| u.email == email }
      return user if user
    end
    nil
  end

  def verify_user_password(user, password)
    user.password == password
  end

  def find_user_by_credentials(email, password)
    user = find_user_by_email(email)
    user if user && verify_user_password(user, password)
  end

  def role_input
    puts 'Choose an Option: '
    puts '1. Teacher'
    puts '2. Student'
  end

  def signup_input
    return 'You must be logged-out to SignUp for another email! ' if @current_user

    name = ''
    loop do
      print 'Enter your Name: '
      name = gets.strip
      break if name_validation?(name)
    end
    email = valid_email
    user = find_user_by_email(email)
    if user
      puts 'Email already exists!'
      return signup_input
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
    role_class = role_checks
    role_initialization_and_adding_to_storage(role_class, name, email, password)
  end

  def login
    email = valid_email
    password = valid_password
    user = find_user_by_credentials(email, password)
    if user
      @current_user = user
      puts 'Login Successful!'
    else
      puts 'No email exist, SignUp first'
    end
  end

  def handle_signup_login_options
    choice = gets.strip.to_i
    process_signup_login_choice(choice)
  end

  def process_signup_login_choice(choice)
    case choice
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
      available_quizzes = quizzes.concat(teacher.select_quizzes(:published) && teacher.reject_quizzes(:locked))
      available_quizzes.each do |quiz|
        if Date.today <= quiz.deadline
          quizzes << quiz unless quizzes.include?(quiz)
        end
      end
    end
    quizzes
  end

  public

  def role_initialization_and_adding_to_storage(role_class, name, email, password)
    instance = role_class.new(name, email, password)
    role_key = role_class.name
    @storage[role_key] << instance
    puts 'SignUp Successful!'
  end

  def main
    loop do
      if @current_user
        @current_user.options(published_unlocked_quizzes)
        logout 
      else
        signup_login_options
        handle_signup_login_options
      end
    end
  end
end


obj = Main.new
def obj.default_users
  password = '123456789'
  role_initialization_and_adding_to_storage(Teacher, 'Ahsan', 'ahsan@gmail.com', password)
  role_initialization_and_adding_to_storage(Student, 'Ans', 'ans@gmail.com', password)
end
obj.default_users
obj.main
