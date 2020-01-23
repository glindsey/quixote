# frozen_string_literal: true

require_relative '../../elements/compound_and'
require_relative '../../elements/dummy'

RSpec.describe Elements::CompoundAnd do
  describe '.process' do
    let(:output) { [] }

    def process(input, output)
      described_class.process(input, output, subclass: Elements::Dummy)
    end

    context 'valid statements' do
      context 'when parsing a single element' do
        let(:input) { ['dummy'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns the expected result' do
          post_output, post_input, success = process(input, output)

          expect(success).to eq(true)
          expect(post_output.length).to eq(1)
        end
      end

      context 'when parsing the form "A and B"' do
        let(:input) { ['A', 'and', 'B'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns the expected result' do
          post_output, post_input, success = process(input, output)

          expect(success).to eq(true)
          expect(post_output.length).to eq(1)
        end
      end

      context 'when parsing the form "A, B and C"' do
        let(:input) { ['A', ',', 'B', 'and', 'C' ] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns the expected result' do
          post_output, post_input, success = process(input, output)

          expect(success).to eq(true)
          expect(post_output.length).to eq(1)
        end
      end

      context 'when parsing the form "A, B, and C"' do
        let(:input) { ['A', ',', 'B', ',', 'and', 'C' ] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns the expected result' do
          post_output, post_input, success = process(input, output)

          expect(success).to eq(true)
          expect(post_output.length).to eq(1)
        end
      end
    end # valid statements

    context 'invalid statements' do
      context 'when parsing "A,' do
        let(:input) { ['A', ','] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'does not change the I/O stacks' do
          pre_input = input.dup
          pre_output = output.dup

          post_output, post_input, success = process(input, output)

          expect(success).to eq(false)
          expect(post_input).to eq(pre_input)
          expect(post_output).to eq(pre_output)
        end
      end

      context 'when parsing "A and"' do
        let(:input) { ['A', 'and'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'does not change the I/O stacks' do
          pre_input = input.dup
          pre_output = output.dup

          post_output, post_input, success = process(input, output)

          expect(success).to eq(false)
          expect(post_input).to eq(pre_input)
          expect(post_output).to eq(pre_output)
        end
      end

      context 'when parsing "A, B"' do
        let(:input) { ['A', ',', 'B'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'does not change the I/O stacks' do
          pre_input = input.dup
          pre_output = output.dup

          post_output, post_input, success = process(input, output)

          expect(success).to eq(false)
          expect(post_input).to eq(pre_input)
          expect(post_output).to eq(pre_output)
        end
      end

      context 'when parsing "A, B,"' do
        let(:input) { ['A', ',', 'B', ','] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'does not change the I/O stacks' do
          pre_input = input.dup
          pre_output = output.dup

          post_output, post_input, success = process(input, output)

          expect(success).to eq(false)
          expect(post_input).to eq(pre_input)
          expect(post_output).to eq(pre_output)
        end
      end

      context 'when parsing "A, B and"' do
        let(:input) { ['A', ',', 'B', 'and'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'does not change the I/O stacks' do
          pre_input = input.dup
          pre_output = output.dup

          post_output, post_input, success = process(input, output)

          expect(success).to eq(false)
          expect(post_input).to eq(pre_input)
          expect(post_output).to eq(pre_output)
        end
      end

      context 'when parsing "A, B, and"' do
        let(:input) { ['A', ',', 'B', ',', 'and'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'does not change the I/O stacks' do
          pre_input = input.dup
          pre_output = output.dup

          post_output, post_input, success = process(input, output)

          expect(success).to eq(false)
          expect(post_input).to eq(pre_input)
          expect(post_output).to eq(pre_output)
        end
      end
    end
  end
end
