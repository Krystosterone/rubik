shared_examples 'Pipeline' do
  class First < Pipeline
    def execute
      p input
      'first_output'
    end
  end

  class Second < Pipeline
    def execute
      p input
      'second_output'
    end
  end

  class Last < Pipeline
    def execute
      p input
    end
  end

  describe '#pipe' do
    subject(:pipeline) do
      described_class.new('initial_input').pipe(First).pipe(Second).pipe(Last)
    end
    let(:expected_output) do
      <<-OUTPUT.strip_heredoc
          "initial_input"
          "first_output"
          "second_output"
      OUTPUT
    end

    it 'executes every pipe in chain' do
      expect { pipeline }.to output(expected_output).to_stdout
    end
  end
end
