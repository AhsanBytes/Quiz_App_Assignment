# frozen_string_literal: true

require_relative 'user'
require_relative 'quiz'
require 'date'
# teacher class actions like creating quizzes,editing quizzes,view attempts,publish,unpublis,lock and unlock quizzes
class Teacher < User
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

  def select_quizzes(action)
    @quizzes.select { |quiz| quiz.public_send(action) }
  end

  def reject_quizzes(action)
    @quizzes.reject {|quiz| quiz.public_send(action)}
  end

  private

  def handle_teacher_options
    choice = gets.strip.to_i
    case choice
    when 1
      create_quiz
      false
    when 2
      edit_quiz
      false
    when 3
      publish_quiz
      false
    when 4
      unpublish_quiz
      false
    when 5
      lock_quiz
      false
    when 6
      unlock_quiz
      false
    when 7
      view_attempts
      false
    when 8
      puts 'Logging out...'
      true
    when 9
      exit
    else
      puts 'Invalid option, please try again!'
      false
    end
  end

  def quiz_title_input
    loop do
      puts 'Enter Quiz Title: '
      title = gets.chomp.strip
      if title.empty?
        puts 'Title cannot be empty.'
      elsif !title.match?(/\A[a-zA-Z\s]+\z/)
        puts 'Title must only contain alphabets and spaces.'
      else
        break title

      end
    end
  end

  def quiz_availability_input
    loop do
      puts "Enter days for quiz availability: "
      input = gets.chomp
      days = input.to_i
      break days if input.match?(/\A\d{1,2}\z/)

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

  def helper_for_publish_lock(quizzes)
    helper_listing_quizzes(quizzes)
    quiz_id_input(quizzes)
  end

  def publish_quiz
    quizzes = reject_quizzes(:published)
    return puts 'No quizzes to show for action' if quizzes.empty?

    helper_for_publish_lock(quizzes).publish!(false)
  end

  def unpublish_quiz
    quizzes = select_quizzes(:published)
    return puts 'No quizzes to show for action' if quizzes.empty?

    helper_for_publish_lock(quizzes).unpublish!(false)
  end

  def lock_quiz
    quizzes = reject_quizzes(:locked)
    return puts 'No quizzes to show for action' if quizzes.empty?

    helper_for_publish_lock(quizzes).lock!(false)
  end

  def unlock_quiz
    quizzes = select_quizzes(:locked)
    return puts 'No quizzes to show for action' if quizzes.empty?

    helper_for_publish_lock(quizzes).unlock!(false)
  end

  def view_attempts
    return puts 'No quizzes available to view attempts.' if @quizzes.empty?

    @quizzes.each_with_index do |quiz, index|
      puts "Viewing attempts for Quiz ID: #{index + 1}, Title: #{quiz.title}"
      next puts 'No attempts found for this quiz.' if quiz.attempts.zero?

      quiz.view_all_attempts
    end

  end
end
