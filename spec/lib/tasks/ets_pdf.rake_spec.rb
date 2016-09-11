require "rails_helper"

describe "ets_pdf:etl" do
  let(:etl) { instance_double(EtsPdf::Etl) }

  context "with no parameters" do
    it "executes with a default parameter" do
      allow(EtsPdf::Etl).to receive(:new).with("db/raw/ets/**/*").and_return(etl)
      allow(etl).to receive(:execute)

      rake_task.execute
    end
  end

  context "with a parameter" do
    before { ENV["PDF_FOLDER"] = "another/path/**/*" }
    after { ENV.delete("PDF_FOLDER") }

    it "executes with the pdf folder parameter" do
      allow(EtsPdf::Etl).to receive(:new).with("another/path/**/*").and_return(etl)
      allow(etl).to receive(:execute)

      rake_task.execute
    end
  end
end
