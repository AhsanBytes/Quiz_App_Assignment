# frozen_string_literal: true

require_relative 'user'
require_relative 'quiz'
# student class have actions like attempt quiz, view attempts, list all quizzes and view quizzes by date
class Student < User
  attr_accessor :attempts
  def initialize(name, email, password)
    super
    @attempts = 0
  end

  def options(quizzes)
    loop do
      puts 'Choose an option: '
      puts '1. Attempt Quiz'
      puts '2. View Attempts'
      puts '3. View Quizzes by date'
      puts '4. List all quizzes'
      puts '5. Logout'
      puts '6. Exit'
      break if handle_student_options(quizzes)
    end
  end

  # private

  def handle_student_options(quizzes)
    case gets.strip.to_i
    when 1 then attempt(quizzes)
    when 2 then view_attempts(quizzes)
    when 3 then view_quizzes_by_date(quizzes)
    when 4 then print(quizzes)
    when 5 then 'Logging out...'
    when 6 then exit
    else
      puts 'Invalid option, please try again!'
    end
  end

  def print(quizzes)
    quizzes.each_with_index { |quiz, index| puts "Quiz ID: #{index + 1}, Quiz Title: #{quiz.title}" }
    false
  end

  def quiz_id_input(quizzes)
    loop do
      puts 'Enter Quiz ID to Attempt: '
      quiz_id = gets.chomp.to_i - 1
      break quiz_id if quizzes.at(quiz_id)

      puts 'Invalid Quiz ID!'
    end
  end

  def attempt(quizzes)
    return puts 'No quizzes available!' if quizzes.empty?

    print(quizzes)
    student_score = quizzes[quiz_id_input(quizzes)].attempt(self)
    puts "Quiz Attempted Successfully. Your score: #{student_score}"
  end

  def view_attempts(quizzes)
    return puts 'No quizzes available!' if quizzes.empty?

    quizzes.each do |quiz|
      next puts 'No attempts found for this quiz.' if quiz.attempts.zero?

      puts "\nQuiz: #{quiz.title}"
      quiz.view_attempts(email)
    end
    false
  end

  def verified_date
    loop do
      puts 'Enter date to view quizzes (YYYY-MM-DD):'
      input = gets.chomp
      break Date.parse(input) if input.match(/\A\d{4}-\d{2}-\d{2}\z/)

      puts 'Invalid date. Please enter a valid date in the format YYYY-MM-DD.'
    end
  end

  def view_quizzes_by_date(published_unlocked_quizzes)
    available_quizzes = published_unlocked_quizzes.select { |quiz| quiz.available_on_date?(verified_date) }
    return puts 'No quizzes available on this date.' if available_quizzes.empty?

    available_quizzes.each { |quiz| puts "Quiz: #{quiz.title}, Deadline: #{quiz.deadline}" }
    false
  end
end
