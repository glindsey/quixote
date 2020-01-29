# frozen_string_literal: true

class TapeError < StandardError; end
class EndOfTapeError < TapeError; end
class StartOfTapeError < TapeError; end

class EndOfTape; end

# A data structure that represents a "tape" of symbols to read, similar to a
# Turing machine except this tape is read-only. In essence this boils down to
# an Array and an Enumerator, but encapsulating it here makes the visuals easier
# for me.
class Tape
  attr_reader :position, :data

  def initialize(array, start_position: 0)
    unless array.is_a?(Array)
      raise ArgumentError, "Initializer requires an Array"
    end

    raise ArgumentError, "Array must be non-empty" unless array.length > 0

    @data = array
    @position = start_position
    @eot = EndOfTape.new
  end

  def next
    raise EndOfTapeError if @position == @data.length

    @position += 1
    element
  end

  def prev
    raise StartOfTapeError if @position == 0

    @position -= 1
    element
  end

  def rewind
    @position = 0
    element
  end

  def element
    end? ? @eot : @data[@position]
  end

  def start?
    (@position == 0)
  end

  def end?
    (@position == @data.length)
  end

  alias_method :advance, :next
  alias_method :previous, :prev
end
