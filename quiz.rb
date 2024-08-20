# frozen_string_literal: true

require 'date'
require_relative 'question'
# quiz class have creating, editing, publish/unpublish, lock, unlock, view_quizzes and attempts
class Quiz
  attr_accessor :questions, :attempts, :published, :locked, :title, :deadline, :attempt_log

  def initialize(title, created_at, availability_days)
    @questions = []
    @published = false
    @locked = false
    @attempts = 0
    @attempt_log = {}
    @title = title
    @created_at = created_at
    @deadline = @created_at + availability_days
  end

  def add_question
    loop do
      question = create_question
      question.add_options_with_correct_answer
      @questions << question
      break unless multiple_question_input
    end
    publish!
    lock!
  end

  def edit
    loop do
      options_for_edit
      handle_options_for_edit
      break unless multiple_question_input
    end
  end

  def lock!(require_confirmation = true)
    return unless common_input_for_publish_lock('lock') if require_confirmation

    @locked = true
    puts 'Quiz Locked successfully!'
  end

  def unlock!(require_confirmation = true)
    return unless common_input_for_publish_lock('un-lock') if require_confirmation

    @locked = false
    puts 'Quiz Unlocked successfully!'
  end

  def publish!(require_confirmation = true)
    return unless common_input_for_publish_lock('publish') if require_confirmation

    @published = true
    puts 'Quiz Published successfully!'
  end

  def unpublish!(require_confirmation = true)
    return unless common_input_for_publish_lock('un-publish') if require_confirmation

    @published = false
    puts 'Quiz Un-published successfully!'
  end

  def attempt(student)
    student_score = 0
    list_questions
    @questions.each_with_index do |question, index|
      print 'Your answer: '
      user_answer = gets.chomp.to_i - 1
      student_score += 1 if user_answer == question.correct_answer_index
    end
    student.attempts += 1
    @attempts += 1
    @attempt_log[student.email] ||= []
    attempt_record = { date: Time.now, score: student_score, attempts: student.attempts }
    @attempt_log[student.email] << attempt_record
    student_score
  end

  def view_attempts(student_email)
    attempts = @attempt_log[student_email]
    return puts "No attempts found" unless attempts
  
    attempts.each do |atp|
      puts "Attempt Date: #{atp[:date]}, Score: #{atp[:score]}, Attempts: #{atp[:attempts]}"
    end
    puts "Total Attempts for #{student_email} are #{attempts.length}."
  end

  def view_all_attempts
    return puts 'No attempts have been made for this quiz yet.' if @attempt_log.empty?

    @attempt_log.each do |email, attempts|
      puts "\nAttempts by #{email}:"
      attempts.each do |attempt|
        puts "Attempt Date: #{attempt[:date]}, Score: #{attempt[:score]}"
      end
    end
  end

  def available_on_date?(date)
    (@created_at..@deadline).cover?(date)
  end

  # private

  def multiple_question_input
    puts 'Do you want to add/edit another question? (y/n): '
    gets.chomp.downcase == 'y'
  end

  def create_question
    loop do
      puts 'Enter Question: '
      statement = gets.chomp.strip
      break Question.new(statement) unless statement.nil?

      puts 'Question cannot be empty.'
    end
  end

  def question_edit_id_input
    loop do
      puts 'Enter question index to edit: '
      question_index = gets.chomp.to_i - 1
      break @questions[question_index] if @questions.at(question_index)
        
      puts 'Invalid question index! Please enter a valid number.'
    end
  end

  def options_for_edit
    puts '1. To edit Title of Quiz'
    puts '2. To edit question'
  end

  def new_quiz_title_input
    puts "Current Quiz Title is: #{@title}"
    puts 'Enter new quiz title: '
    gets.chomp
  end

  def handle_options_for_edit
    case gets.chomp.to_i
    when 1
      @title = new_quiz_title_input
    when 2
      list_questions
      question = question_edit_id_input
      question.edit
    else
      puts 'Invalid Input!'
    end
  end
  
  def list_questions
    @questions.each.with_index(1) do |question, index|
      puts "Question #{index}: #{question.statement}"
      question.options.each.with_index(1) do |option, opt_index|
        puts "#{opt_index}. #{option.text}"
      end
    end
  end

  def common_input_for_publish_lock(action)
    puts "Do you want to #{action} the quiz?"
    gets.chomp.downcase == 'y'
  end
end
