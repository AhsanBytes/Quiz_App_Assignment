# frozen_string_literal: true

require_relative 'user'
require_relative 'quiz'
require 'date'
# teacher class actions like creating quizzes,editing quizzes,view attempts,publish,unpublis,lock and unlock quizzes
class Teacher < User
  attr_reader :quizzes
  def initialize(name, email, password)
    super
    @quizzes = []
  end

  def options(_)
    loop do
      puts 'Choose an option: '
      puts '1. Create Quiz'
      puts '2. Edit Quiz'
      puts '3. Publish Quiz'
      puts '4. Un-publish Quiz'
      puts '5. Lock Quiz'
      puts '6. Unlock Quiz'
      puts '7. View Attempts'
      puts '8. Logout'
      puts '9. Exit'
      return if handle_teacher_options
    end
  end

  def select_quizzes(quizzes, action)
    quizzes.select { |quiz| quiz.public_send(action) }
  end

  def reject_quizzes(quizzes, action)
    quizzes.reject {|quiz| quiz.public_send(action)}
  end

  def handle_teacher_options
    choice = gets.strip.to_i
    case choice
    when 1 then create_quiz
    when 2 then edit_quiz
    when 3 then publish_quiz
    when 4 then unpublish_quiz
    when 5 then lock_quiz
    when 6 then unlock_quiz
    when 7 then view_attempts
    when 8 then 'Logging out...'
    when 9 then exit
    else
      puts 'Invalid option, please try again!'
    end
  end

  def quiz_title_input
    loop do
      puts 'Enter Quiz Title: '
      title = gets.chomp.strip
      break title if title.match(/\A[a-zA-Z]+(?:\s[a-zA-Z]+)*\z/)

      puts 'Title must contain alphabets and spaces'
    end
  end

  def quiz_availability_input
    loop do
      puts "Enter days for quiz availability: "
      days = gets.chomp.to_i
      break days if days.between?(1, 99)

      puts 'Invalid input! Please enter a valid number of days.'
    end
  end

  def create_quiz
    quiz = Quiz.new(quiz_title_input, Date.today(), quiz_availability_input)
    quiz.add_question
    @quizzes << quiz
    puts 'Quiz created Successfully! '
  end

  def quiz_id_input(quizzes)
    loop do
      puts 'Enter Quiz ID to perform action: '
      quiz_id = gets.chomp.to_i - 1
      break quizzes[quiz_id] if @quizzes.at(quiz_id)

      puts 'Invalid Quiz ID!'
    end
  end

  def edit_quiz
    return puts 'No quizzes available to edit!' if @quizzes.empty?

    list_all_quizzes
    quiz = quiz_id_input(@quizzes)
    quiz.edit
    puts 'Quiz updated successfully!'
  end

  def helper_listing_quizzes(quizzes)
    quizzes.each_with_index do |quiz, index|
      puts "Quiz ID: #{index + 1}, Title: #{quiz.title}, Published: #{quiz.published}, " \
            "Locked: #{quiz.locked}, Deadline: #{quiz.deadline}, Quiz Attempts: #{quiz.attempts}"
    end
  end

  def list_all_quizzes
    helper_listing_quizzes(@quizzes)
  end

  def helper_for_publish_lock(action, selection_method)
    quizzes = public_send(selection_method, @quizzes, action)
    return puts 'No quizzes to show for action' if quizzes.empty?

    helper_listing_quizzes(quizzes)
    quiz_id_input(quizzes)
  end

  def publish_quiz
    quiz = helper_for_publish_lock(:published, :reject_quizzes)
    quiz.publish!(false) if quiz
  end

  def unpublish_quiz
    quiz = helper_for_publish_lock(:published, :select_quizzes)
    quiz.unpublish!(false) if quiz
  end

  def lock_quiz
    quiz = helper_for_publish_lock(:locked, :reject_quizzes)
    quiz.lock!(false) if quiz
  end

  def unlock_quiz
    quiz = helper_for_publish_lock(:locked, :select_quizzes)
    quiz.unlock!(false) if quiz
  end

  def view_attempts
    return puts 'No quizzes available to view attempts.' if @quizzes.empty?

    @quizzes.each_with_index do |quiz, index|
      puts "Viewing attempts for Quiz ID: #{index + 1}, Title: #{quiz.title}"
      next puts 'No attempts found for this quiz.' if quiz.attempts.zero?

      quiz.view_all_attempts
    end
    false
  end
end
