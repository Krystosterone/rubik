require "rails_helper"

describe EtsPdf::Etl::Transform::PeriodUpdater do
  describe "#execute" do
    described_class::TYPES.each do |parsed_type, transformed_type|
      context "for a period of type #{parsed_type}" do
        subject(:period_updater) { described_class.new(group, period_data) }
        let(:group) { Group.new(number: 1) }
        let(:period_data) do
          instance_double(
            EtsPdf::Parser::ParsedLine::Period,
            type: parsed_type,
            weekday: "Lun",
            start_time: "8:00",
            end_time: "10:00"
          )
        end
        let(:period) { Period.new(type: transformed_type, starts_at: 1920, ends_at: 2040) }

        context "with no periods already defined" do
          before { period_updater.execute }

          it "initialized them" do
            expect(group.periods).to eq([period])
          end
        end

        context "with the period defined but of different type" do
          let(:existent_period) { Period.new(type: "OTHER", starts_at: 1920, ends_at: 2040) }
          before do
            group.periods = [existent_period]
            period_updater.execute
          end

          it "updates it" do
            expect(group.periods).to eq([period])
          end
        end

        context "with the periods already defined" do
          before { group.periods = [period] }

          it "does not initialize new ones" do
            expect { period_updater.execute }.not_to change { group.periods.size }
          end
        end
      end
    end
  end
end
