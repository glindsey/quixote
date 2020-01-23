# frozen_string_literal: true

require 'stack_machine/processor'

# Normally this would be output from a lexer first.
example_input =
[
  'you', 'put', 'the', 'red', 'ball',
  'and', 'the', 'blue', 'block',
  'in', 'the', 'corner', '.'
]

StackMachine::Sentence.process(example_input)
