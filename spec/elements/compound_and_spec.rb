# frozen_string_literal: true

require_relative '../../elements/compound_and'
require_relative '../../elements/dummy'
require_relative '../../structures/tape'

RSpec.describe Elements::CompoundAnd do
  describe '.process' do
    let(:output) { [] }

    def process(tape, **args)
      described_class.process(tape: tape, subclass: Elements::Dummy, **args)
    end

    context 'valid statements' do
      context 'when parsing a single element' do
        let(:tape) { Tape.new(['dummy']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(tape)
          warn "result = #{result}"
          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::Dummy)
        end
      end

      context 'when parsing the form "A and B"' do
        let(:tape) { Tape.new(['A', 'and', 'B']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(tape)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::CompoundAnd)
        end
      end

      context 'when parsing the form "A, B and C"' do
        let(:tape) { Tape.new(['A', ',', 'B', 'and', 'C' ]) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(tape)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::CompoundAnd)
        end
      end

      context 'when parsing the form "A, B, and C"' do
        let(:tape) { Tape.new(['A', ',', 'B', ',', 'and', 'C' ]) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(tape)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::CompoundAnd)
        end
      end
    end # valid statements

    context 'when `allow_commas_only` is false' do
      let(:args) { { allow_commas_only: false } }

      context 'when parsing "A, B"' do
        let(:tape) { Tape.new(['A', ',', 'B']) }

        it 'does not raise an exception' do
          expect { process(tape, args) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(tape, args)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(tape, args)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position).to eq(tape.position)
        end

        it 'does not alter the output stack' do
          result = process(tape, args)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B, C"' do
        let(:tape) { Tape.new(['A', ',', 'B', ',', 'C']) }

        it 'does not raise an exception' do
          expect { process(tape, args) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(tape, args)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(tape, args)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position).to eq(tape.position)
        end

        it 'does not alter the output stack' do
          result = process(tape, args)

          expect(result[:output]).to eq(output)
        end
      end
    end

    context 'when `allow_commas_only` is true' do
      let(:args) { { allow_commas_only: true } }

      context 'when parsing "A, B"' do
        let(:tape) { Tape.new(['A', ',', 'B']) }

        it 'does not raise an exception' do
          expect { process(tape, args) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(tape, args)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::CompoundAnd)
        end
      end

      context 'when parsing "A, B, C"' do
        let(:tape) { Tape.new(['A', ',', 'B', ',', 'C']) }

        it 'does not raise an exception' do
          expect { process(tape, args) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(tape, args)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::CompoundAnd)
        end
      end
    end

    context 'when `allow_space_delimiters` is false' do
      let(:args) { { allow_space_delimiters: false } }

      context 'when parsing "A B"' do
        let(:tape) { Tape.new(['A', 'B']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns success' do
          result = process(tape)

          expect(result[:success]).to eq(true)
        end

        it 'moves the tape by one element' do
          prev_position = tape.position

          result = process(tape)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position).to eq(prev_position + 1)
        end

        it 'returns the expected result' do
          result = process(tape, args)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::Dummy)
        end
      end
    end

    context 'when `allow_space_delimiters` is true' do
      let(:args) { { allow_space_delimiters: true } }

      context 'when parsing "A B"' do
        let(:tape) { Tape.new(['A', 'B']) }

        it 'does not raise an exception' do
          expect { process(tape, args) }.not_to raise_error
        end

        it 'returns the expected result' do
          result = process(tape, args)

          expect(result[:success]).to eq(true)
          expect(result[:output].length).to eq(1)
          expect(result[:output].first).to be_a(Elements::CompoundAnd)
        end
      end
    end

    context 'invalid statements' do
      context 'when parsing "A,' do
        let(:tape) { Tape.new(['A', ',']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(tape)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(tape)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position).to eq(tape.position)
        end

        it 'does not alter the output stack' do
          result = process(tape)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A and"' do
        let(:tape) { Tape.new(['A', 'and']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(tape)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(tape)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position).to eq(tape.position)
        end

        it 'does not alter the output stack' do
          result = process(tape)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B,"' do
        let(:tape) { Tape.new(['A', ',', 'B', ',']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(tape)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(tape)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position).to eq(tape.position)
        end

        it 'does not alter the output stack' do
          result = process(tape)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B and"' do
        let(:tape) { Tape.new(['A', ',', 'B', 'and']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(tape)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(tape)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position).to eq(tape.position)
        end

        it 'does not alter the output stack' do
          result = process(tape)

          expect(result[:output]).to eq(output)
        end
      end

      context 'when parsing "A, B, and"' do
        let(:tape) { Tape.new(['A', ',', 'B', ',', 'and']) }

        it 'does not raise an exception' do
          expect { process(tape) }.not_to raise_error
        end

        it 'returns a failure' do
          result = process(tape)

          expect(result[:success]).to eq(false)
        end

        it 'does not alter the tape' do
          result = process(tape)

          expect(result[:tape].data).to eq(tape.data)
          expect(result[:tape].position). to eq(tape.position)
        end

        it 'does not alter the output stack' do
          result = process(tape)

          expect(result[:output]).to eq(output)
        end
      end
    end
  end
end
