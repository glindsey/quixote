# frozen_string_literal: true

require_relative '../../elements/sentence'
require_relative '../../elements/dummy'
require_relative '../../engines/tokenizer'
require_relative '../../structures/token_tape'

RSpec.shared_examples "sentence parsing" do |input, expected_output|
  context "when parsing '#{input}'" do
    let(:tape) { Tokenizer.parse(input) }

    xit 'does not raise an exception' do
      expect { Elements::Sentence.process(tape: tape) }.not_to raise_error
    end

    xit 'succeeds' do
      result = Elements::Sentence.process(tape: tape)

      expect(result[:success]).to be true
    end
  end
end

RSpec.describe "full-stack sentence parsing" do
  include_examples "sentence parsing", "The boy kicks the ball"
end
