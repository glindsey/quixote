# frozen_string_literal: true

require_relative '../structures/token_tape'

# Splits a string into an array of tokens.
# Right now this is very basic.
# TODO: flesh this baby out
class Tokenizer
  class << self
    # Parse the string into a token tape.
    # That regex is a nightmare, so the following describes what it splits on:
    # - \s+       -- One or more spaces
    # - "         -- Double-quotes
    # - \.\.\.    -- An ellipsis (...)
    # - --        -- Double-dash (commonly used as an em-dash)
    # - -         -- Single-dash (commonly used as an en-dash)
    # - ,         -- Comma
    # - \.        -- Period
    # - \?        -- Question mark
    # - \!        -- Exclamation point
    # - ;         -- Semicolon
    # - :         -- Colon
    # - \*+       -- One or more asterisks
    # - \( and \) -- Open/close parenthesis
    # - \[ and \] -- Open/close bracket
    # - \{ and \} -- Open/close curly brace
    # - < and >   -- Open/close angle bracket
    SPLIT_REGEX = /(\s+|"|\.\.\.|--|-|,|\.|\?|!|;|:|\*+|\(|\)|\[|\]|\{|\}|<|>)/

    def parse(str)
      TokenTape.new(str.split(SPLIT_REGEX).reject { |elem| elem.strip.empty? })
    end
  end
end
