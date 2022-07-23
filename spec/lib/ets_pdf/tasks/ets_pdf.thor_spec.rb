# frozen_string_literal: true

require "rails_helper"

describe "ets_pdf:etl", type: :thor_command do
  let(:etl) { instance_double(EtsPdf::Etl) }
  let(:patterns) { ["another/path/file.txt"] }

  before { allow(EtsPdf::Etl).to receive(:call).with(patterns) }

  it "executes with the pdf folder parameter" do
    thor_command.call({ data: patterns })

    expect(EtsPdf::Etl).to have_received(:call)
  end
end
