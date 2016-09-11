require "rails_helper"

describe EtsPdf::Etl::Transform::AcademicDegreeUpdater do
  describe "#execute" do
    subject(:academic_degree_updater) { described_class.new(academic_degree_term, lines) }
    let(:academic_degree_term) { create(:academic_degree_term) }
    let(:lines) do
      [
        unparsed_line,

        # LOG120
        line(:course, code: "LOG120"),
        unparsed_line,
        line(:group, number: "01", type: "C", weekday: "Lun", start_time: "8:00", end_time: "10:00"),
        line(:period, type: "TP", weekday: "Mar", start_time: "11:00", end_time: "12:00"),
        unparsed_line,
        line(:group, number: "02", type: "Labo", weekday: "Ven", start_time: "8:00", end_time: "11:00"),

        # PRE010
        line(:course, code: "PRE010"),
        line(:group, number: "01", type: "TP", weekday: "Jeu", start_time: "15:00", end_time: "16:00"),
        unparsed_line,

        # LOG240
        line(:course, code: "LOG240"),
        line(:group, number: "01", type: "TP", weekday: "Mer", start_time: "13:00", end_time: "14:00"),
        unparsed_line,
        line(:period, type: "C", weekday: "Sam", start_time: "8:00", end_time: "13:00"),
      ]
    end
    let(:log120_groups) do
      [
        Group.new(number: 1, periods: [
          Period.new(type: "C", starts_at: 1920, ends_at: 2040),
          Period.new(type: "TP", starts_at: 3540, ends_at: 3600),
        ]),
        Group.new(number: 2, periods: [Period.new(type: "Labo", starts_at: 7680, ends_at: 7860)]),
      ]
    end
    let(:log240_groups) do
      [
        Group.new(number: 1, periods: [
          Period.new(type: "TP", starts_at: 5100, ends_at: 5160),
          Period.new(type: "C", starts_at: 9120, ends_at: 9420),
        ])
      ]
    end
    let(:academic_degree_term_courses) { academic_degree_term.academic_degree_term_courses }
    let(:actual_academic_degree_term_courses_attributes) { academic_degree_term_courses.pluck(:code, :groups) }

    let(:expected_academic_degree_term_courses_attributes) do
      [
        ["LOG120", log120_groups],
        ["LOG240", log240_groups],
      ]
    end

    context "when parsing has gone wrong" do
      before { lines[-3] = unparsed_line }

      it "throws an error" do
        expect { academic_degree_updater.execute }
          .to raise_exception(described_class::ParsingError, /Parsing error for.*LOG240/)
      end
    end

    context "when no academic degree term courses exist" do
      before { academic_degree_updater.execute }

      it "populates the correct number of academix degree term courses" do
        expect(academic_degree_term_courses.count).to eq(2)
      end

      it "populates the correct data" do
        expect(actual_academic_degree_term_courses_attributes).to eq(expected_academic_degree_term_courses_attributes)
        # expect(log120.course.code).to eq("LOG120")
        # expect(log120.groups).to eq(log120_groups)
        #
        # expect(log240.course.code).to eq("LOG240")
        # expect(log240.groups).to eq(log240_groups)
      end
    end

    context "when the academic degree term courses exist" do
      before do
        academic_degree_term_courses.create!(
          course: Course.create!(code: "LOG120"),
          groups: log120_groups
        )
        academic_degree_term_courses.create!(
          course: Course.create!(code: "LOG240"),
          groups: log240_groups
        )
      end

      it "has no effect on the courses" do
        expect { academic_degree_updater.execute }
          .not_to change { academic_degree_term_courses.count }
      end
    end
  end

  private

  def unparsed_line
    parsed_line = instance_double(EtsPdf::Parser::ParsedLine)
    allow(parsed_line).to receive(:parsed?).and_return(false)
    parsed_line
  end

  def line(type, attributes = {})
    line_klass = EtsPdf::Parser::ParsedLine.const_get(type.to_s.titleize)
    typed_line = instance_double(line_klass, attributes)
    parsed_line = instance_double(EtsPdf::Parser::ParsedLine, type => typed_line)

    stub_line(parsed_line, type)

    parsed_line
  end

  def stub_line(parsed_line, type)
    allow(parsed_line).to receive(:type?).and_return(false)
    allow(parsed_line).to receive(:parsed?).and_return(true)
    allow(parsed_line).to receive(:type?).with(type).and_return(true)
  end
end
