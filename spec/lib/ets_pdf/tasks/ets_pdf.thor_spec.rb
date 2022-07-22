# frozen_string_literal: true

require "rails_helper"

describe "ets_pdf:etl", type: :thor_command do
  let(:etl) { instance_double(EtsPdf::Etl) }
  let(:patterns) { ["another/path/file.txt"] }

  it "executes with the pdf folder parameter" do
    expect(EtsPdf::Etl).to receive(:call).with(patterns)

    thor_command.call({ data: patterns })
  end
end
