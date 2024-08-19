# frozen_string_literal: true

require_relative 'option'

# Class for options for a question
class Question
  attr_accessor :statement, :options, :correct_answer_index

  def initialize(statement)
    @statement = statement
    @options = []
    @correct_answer_index = nil
  end

  def edit
    loop do
      edit_options
      handle_edit_options
      break unless multiple_edit_input

    end
  end

  private

  def add_options_with_correct_answer
    3.times do |i|
      loop do
        puts "Enter Option #{i + 1}: "
        option_text = gets.chomp.strip
        break @options << Option.new(option_text) unless option_text.empty?
        
        puts 'Option cannot be empty.'
      end
    end
    set_correct_answer
  end

  def set_correct_answer
    loop do
      puts 'Enter the option number of the correct answer (1, 2, or 3): '
      @correct_answer_index = gets.chomp.to_i - 1
      break if @correct_answer_index.between?(0, 2)

      puts 'Invalid answer index. Please select between 1 and 3.'
    end
  end

  def edit_options
    puts 'What do you want to edit?'
    puts '1. Edit Question Statement'
    puts '2. Edit Options'
    puts '3. Set Correct Option'
  end

  def new_statement_input
    puts 'Enter new question statement: '
    gets.chomp
  end

  def clear_and_add_options
    @options.clear
    add_options_with_correct_answer
  end

  def process_choice(choice)
    case choice
    when 1
      @statement = new_statement_input
    when 2
      clear_and_add_options
    when 3
      set_correct_answer
    else
      puts 'Invalid choice!'
    end
  end

  def handle_edit_options
    choice = gets.chomp.to_i
    process_choice(choice)
  end

  def multiple_edit_input
    puts 'Do you want to edit anything else? (y/n): '
    gets.chomp.downcase == 'y'
  end

end
