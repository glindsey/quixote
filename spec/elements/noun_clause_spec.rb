# frozen_string_literal: true

require_relative '../../elements/noun_clause'

require_relative '../../elements/element'
require_relative '../../elements/singular_noun'

RSpec.describe Elements::NounClause do
  describe '.process' do
    let(:output) { [] }

    def process(input, output)
      described_class.process(
        input: input,
        output: output
      )
    end

    def do_dummy_succeed(for_class, passing_string, args)
      if args[:input].first == passing_string
        Elements::Element.succeed(
          input: input.shift,
          output: args[:output].push(for_class.new),
          **args
        )
      else
        Elements::Element.fail(input: input, output: output, **args)
      end
    end

    before do
      allow(Elements::Adjective).to receive(:process) do |args|
        do_dummy_succeed(Elements::Adjective, 'Adjective', args)
      end

      allow(Elements::PluralNoun).to receive(:process) do |args|
        do_dummy_succeed(Elements::PluralNoun, 'PluralNoun', args)
      end

      allow(Elements::PrepAdjectivalPhrase).to receive(:process) do |args|
        do_dummy_succeed(Elements::PrepAdjectivalPhrase, 'PrepAdjPhr', args)
      end

      allow(Elements::SingularNoun).to receive(:process) do |args|
        do_dummy_succeed(Elements::SingularNoun, 'SingularNoun', args)
      end

    end

    context 'valid clauses' do
      context 'the SingularNoun' do
        let(:input) { ['the', 'SingularNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end
      end

      context 'the SingularNoun PrepAdjPhr' do
        let(:input) { ['the', 'SingularNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end

      context 'the SingularNoun PrepAdjPhr PrepAdjPhr' do
        let(:input) { ['the', 'SingularNoun', 'PrepAdjPhr', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(2)
        end
      end

      context 'the PluralNoun' do
        let(:input) { ['the', 'PluralNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(2)
        end
      end

      context 'the PluralNoun PrepAdjPhr' do
        let(:input) { ['the', 'PluralNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end

      context 'the PluralNoun PrepAdjPhr PrepAdjPhr' do
        let(:input) { ['the', 'PluralNoun', 'PrepAdjPhr', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(2)
        end
      end

      context 'the Adjective SingularNoun' do
        let(:input) { ['the', 'Adjective', 'SingularNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end
      end

      context 'the Adjective SingularNoun PrepAdjPhr' do
        let(:input) { ['the', 'Adjective', 'SingularNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end

      context 'the Adjective PluralNoun' do
        let(:input) { ['the', 'Adjective', 'PluralNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end
      end

      context 'the Adjective PluralNoun PrepAdjPhr' do
        let(:input) { ['the', 'Adjective', 'PluralNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end

      context 'a|an Adjective SingularNoun' do
        let(:input) { ['a', 'Adjective', 'SingularNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end
      end

      context 'a|an Adjective SingularNoun PrepAdjPhr' do
        let(:input) { ['a', 'Adjective', 'SingularNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end

      context 'a|an SingularNoun' do
        let(:input) { ['a', 'SingularNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end
      end

      context 'a|an SingularNoun PrepAdjPhr' do
        let(:input) { ['a', 'SingularNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::SingularNoun)
        end

        it 'keeps result.adjectives blank' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to be_empty
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end

      context 'Adjective PluralNoun' do
        let(:input) { ['Adjective', 'PluralNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end
      end

      context 'Adjective PluralNoun PrepAdjPhr' do
        let(:input) { ['Adjective', 'PluralNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'sets result.adjectives to the provided adjective' do
          result = process(input, output)[:output].first
          expect(result.adjectives).to include(Elements::Adjective)
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end

      context 'PluralNoun' do
        let(:input) { ['PluralNoun'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'keeps result.adjective_phrases blank' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to be_empty
        end
      end

      context 'PluralNoun PrepAdjPhr' do
        let(:input) { ['PluralNoun', 'PrepAdjPhr'] }

        it 'does not raise an exception' do
          expect { process(input, output) }.not_to raise_error
        end

        it 'returns a NounClause' do
          result = process(input, output)[:output].first
          expect(result).to be_a(Elements::NounClause)
        end

        it 'sets result.noun to the provided noun' do
          result = process(input, output)[:output].first
          expect(result.noun).to be_a(Elements::PluralNoun)
        end

        it 'sets result.adjective_phrases to the provided phrases' do
          result = process(input, output)[:output].first
          phrases = result.adjective_phrases
          expect(phrases).to include(Elements::PrepAdjectivalPhrase)
          expect(phrases.length).to eq(1)
        end
      end
    end

    context 'invalid clauses' do
      context ''
      context 'the'
      context 'the Adjective'
      context 'a|an'
      context 'a|an Adjective'
      context 'Adjective'
    end
  end
end