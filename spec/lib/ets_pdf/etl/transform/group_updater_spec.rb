require "rails_helper"

describe EtsPdf::Etl::Transform::GroupUpdater do
  describe "#execute" do
    subject(:group_updater) { described_class.new(academic_degree_term_course, group_data) }
    let(:academic_degree_term_course) { build(:academic_degree_term_course) }
    let(:group_data) do
      instance_double(
        EtsPdf::Parser::ParsedLine::Group,
        number: "01",
        type: "C",
        weekday: "Lun",
        start_time: "8:00",
        end_time: "10:00"
      )
    end
    let(:groups) do
      [Group.new(number: 1, periods: [Period.new(type: "C", starts_at: 1920, ends_at: 2040)])]
    end

    context "with no groups serialized" do
      before { group_updater.execute }

      it "created them" do
        expect(academic_degree_term_course.groups).to eq(groups)
      end
    end

    context "with groups already serialized" do
      before { academic_degree_term_course.groups = groups }

      it "does not create new ones" do
        expect { group_updater.execute }.not_to change { academic_degree_term_course.groups.count }
      end
    end
  end
end
