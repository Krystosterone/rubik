require "rails_helper"

describe EtsPdf::Etl do
  describe "#execute" do
    let(:pre_process_pipe) { double(EtsPdf::Etl::PreProcess) }
    let(:extract_pipe) { double(EtsPdf::Etl::Extract) }
    let(:transform_pipe) { double(EtsPdf::Etl::Transform) }
    subject { described_class.new("some/directory/**/*") }

    it "executes in order each pipeline" do
      expect(subject).to receive(:pipe).with(EtsPdf::Etl::PreProcess).and_return(pre_process_pipe)
      expect(pre_process_pipe).to receive(:pipe).with(EtsPdf::Etl::Extract).and_return(extract_pipe)
      expect(extract_pipe).to receive(:pipe).with(EtsPdf::Etl::Transform).and_return(transform_pipe)

      expect(subject.execute).to eq(transform_pipe)
    end
  end
end
