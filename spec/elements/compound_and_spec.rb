# frozen_string_literal: true

require_relative '../../elements/compound_and'
require_relative '../../elements/dummy'
require_relative '../../structures/tape'

RSpec.describe Elements::CompoundAnd do
  describe '.process' do
    let(:output) { [] }

    def process(input)
      described_class.process(tape: Tape.new(input), subclass: Elements::Dummy)
    end

    context 'valid statements' do
      context 'when parsing a single element' do
        let(:input) { ['dummy'] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(input)
          warn "result = #{result}"
          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
        end
      end

      context 'when parsing the form "A and B"' do
        let(:input) { ['A', 'and', 'B'] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(input)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
        end
      end

      context 'when parsing the form "A, B and C"' do
        let(:input) { ['A', ',', 'B', 'and', 'C' ] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(input)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
        end
      end

      context 'when parsing the form "A, B, and C"' do
        let(:input) { ['A', ',', 'B', ',', 'and', 'C' ] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(input)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
        end
      end
    end # valid statements

    context 'invalid statements' do
      context 'when parsing "A,' do
        let(:input) { ['A', ','] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(input)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(input)

          expect(result[:tape].data).to eq(input)
        end

        it 'does not alter the output stack' do
          result = process(input)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A and"' do
        let(:input) { ['A', 'and'] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(input)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(input)

          expect(result[:tape].data).to eq(input)
        end

        it 'does not alter the output stack' do
          result = process(input)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B"' do
        let(:input) { ['A', ',', 'B'] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(input)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(input)

          expect(result[:tape].data).to eq(input)
        end

        it 'does not alter the output stack' do
          result = process(input)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B,"' do
        let(:input) { ['A', ',', 'B', ','] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(input)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(input)

          expect(result[:tape].data).to eq(input)
        end

        it 'does not alter the output stack' do
          result = process(input)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B and"' do
        let(:input) { ['A', ',', 'B', 'and'] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(input)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(input)

          expect(result[:tape].data).to eq(input)
        end

        it 'does not alter the output stack' do
          result = process(input)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B, and"' do
        let(:input) { ['A', ',', 'B', ',', 'and'] }

        it 'does not raise an exception' do
          expect { process(input) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(input)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(input)

          expect(result[:tape].data).to eq(input)
        end

        it 'does not alter the output stack' do
          result = process(input)

          expect(result[:output]).to eq(output)
        end
      end
    end
  end
end
