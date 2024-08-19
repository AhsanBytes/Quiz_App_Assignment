# frozen_string_literal: true

require_relative 'user'
require_relative 'quiz'
# student class have actions like attempt quiz, view attempts, list all quizzes and view quizzes by date
class Student < User
  quizzes ||= []

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

  private

  def handle_student_options(quizzes)
    choice = gets.strip.to_i
    case choice
    when 1
      attempt_quiz(quizzes)
      false
    when 2
      view_attempts(quizzes)
      false
    when 3
      view_quizzes_by_date(quizzes)
      false
    when 4
      list_quizzes(quizzes)
      false
    when 5
      true
    when 6
      exit
    else
      puts 'Invalid option, please try again!'
      false
    end
  end

  def print(quizzes)
    quizzes.each_with_index do |quiz, index|
      puts "Quiz ID: #{index + 1}, Quiz Title: #{quiz.title}"
    end
  end

  def quiz_id_input(quizzes)
    loop do
      puts 'Enter Quiz ID to Attempt: '
      quiz_id = gets.chomp.to_i - 1
      break quiz_id if quizzes.at(quiz_id)

      puts 'Invalid Quiz ID!'
    end
  end

  def attempt_quiz(quizzes)
    return puts 'No quizzes available!' if quizzes.empty?

    print(quizzes)
    quiz_id = quiz_id_input(quizzes)
    quiz = quizzes[quiz_id]
    student_score = quiz.attempt(email)
    puts "Quiz Attempted Successfully. Your score: #{student_score}"
  end

  def view_attempts(quizzes)
    return puts 'No quizzes available!' if quizzes.empty?

    quizzes.each do |quiz|
      next puts 'No attempts found for this quiz.' if quiz.attempts.zero?

      puts "\nQuiz: #{quiz.title}"
      attempts = quiz.view_attempts(email)
    end
  end

  def verify_date
    loop do
      puts 'Enter date to view quizzes (YYYY-MM-DD):'
      input = gets.chomp
      if input.match(/\A\d{4}-\d{2}-\d{2}\z/)
        break Date.parse(input)
      end

      puts 'Invalid date. Please enter a valid date in the format YYYY-MM-DD.'
    end
  end

  def view_quizzes_by_date(published_unlocked_quizzes)
    input_date = verify_date
    available_quizzes = published_unlocked_quizzes.select do |quiz|
      quiz.available_on_date?(input_date)
    end
    return puts 'No quizzes available on this date.' if available_quizzes.empty?

    available_quizzes.each do |quiz|
      puts "Quiz: #{quiz.title}, Deadline: #{quiz.deadline}"
    end
  end

  def list_quizzes(quizzes)
    print(quizzes)
  end
end
