# frozen_string_literal: true

# class for options for a question
class Option
  attr_accessor :text

  def initialize(text)
    @text = text
  end
end
