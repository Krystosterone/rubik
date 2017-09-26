# frozen_string_literal: true
require "rails_helper"

describe EtsPdf::Etl::PeriodBuilder do
  describe ".call" do
    let(:group) { build(:group) }

    context "when the weekday is invalid" do
      [:group, :period].each do |line_type|
        context "when the line is a '#{line_type}'" do
          let(:parsed_lines) { [build("parsed_#{line_type}_line", weekday: "NOP")] }

          it "raises an error" do
            expect { described_class.call(group, parsed_lines) }.to raise_error("Invalid weekday 'NOP'")
          end
        end
      end
    end

    context "when the type is invalid" do
      [:group, :period].each do |line_type|
        context "when the line is a '#{line_type}'" do
          let(:parsed_lines) { [build("parsed_#{line_type}_line", type: "NOP")] }

          it "raises an error" do
            expect { described_class.call(group, parsed_lines) }.to raise_error("Invalid type 'NOP'")
          end
        end
      end
    end

    described_class::TYPES.each do |denormalized_type, normalized_type|
      I18n.t("date.abbr_day_names").each_with_index do |weekday, weekday_index|
        weekday_start_time = weekday_index * 24 * 60

        [:group, :period].each do |line_type|
          context "when the line is a '#{line_type}', with type '#{denormalized_type}' and weekday '#{weekday}'" do
            let(:parsed_lines) do
              [
                build(
                  "parsed_#{line_type}_line",
                  end_time: "00:10",
                  start_time: "00:00",
                  type: denormalized_type,
                  weekday: weekday
                ),
              ]
            end
            let(:period) do
              group.periods.find do |period|
                period.ends_at == weekday_start_time + 10 &&
                  period.starts_at == weekday_start_time &&
                  period.type == normalized_type
              end
            end

            it "builds the period for the group" do
              described_class.call(group, parsed_lines)

              expect(period).to be_present
            end
          end
        end
      end
    end
  end
end
