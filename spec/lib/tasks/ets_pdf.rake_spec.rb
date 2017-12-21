# frozen_string_literal: true

require "rails_helper"

describe "ets_pdf:etl" do
  let(:etl) { instance_double(EtsPdf::Etl) }

  before { ENV["PDF_FOLDER"] = "another/path/**/*" }
  after { ENV.delete("PDF_FOLDER") }

  it "executes with the pdf folder parameter" do
    allow(EtsPdf::Etl).to receive(:call).with("another/path/**/*")

    rake_task.execute
  end
end
