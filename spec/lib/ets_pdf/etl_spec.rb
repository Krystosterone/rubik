require "rails_helper"

describe EtsPdf::Etl do
  describe "#execute" do
    subject(:etl) { described_class.new("some/directory/**/*") }
    let(:pre_process_pipe) { instance_double(EtsPdf::Etl::PreProcess) }
    let(:extract_pipe) { instance_double(EtsPdf::Etl::Extract) }
    let(:transform_pipe) { instance_double(EtsPdf::Etl::Transform) }
    before do
      allow(EtsPdf::Etl::PreProcess).to receive(:new).with("some/directory/**/*").and_return(pre_process_pipe)
      allow(EtsPdf::Etl::Extract).to receive(:new).with(:output_1).and_return(extract_pipe)
      allow(EtsPdf::Etl::Transform).to receive(:new).with(:output_2).and_return(transform_pipe)
    end

    it "executes in order each pipeline" do
      allow(pre_process_pipe).to receive(:execute).and_return(:output_1)
      allow(extract_pipe).to receive(:execute).and_return(:output_2)
      allow(transform_pipe).to receive(:execute).and_return(:last_output)

      etl.execute
    end
  end
end
