require "rails_helper"

describe ScheduleGeneratorTestCase do
  before(:all) do
    @current_folder_path = described_class.folder_path
    @tmp_folder_path = Rails.root.join("tmp/schedule_generator_test_cases")
    described_class.folder_path = @tmp_folder_path
  end
  after(:all) { described_class.folder_path = @current_folder_path }
  before { FileUtils.mkdir_p(@tmp_folder_path) }
  after { FileUtils.rm_rf(@tmp_folder_path) }

  describe ".folder_path" do
    specify { expect(described_class.folder_path).to eq(@tmp_folder_path) }
  end

  describe ".all" do
    let(:tokens) { Array.new(3) { SecureRandom.hex } }
    let(:test_cases) do
      test_cases = tokens.collect do |token|
        content = { token: token }
        [token, content]
      end
      test_cases.sort_by { |token, _| token }
    end
    before do
      test_cases.each do |token, content|
        File.write @tmp_folder_path.join("#{token}.yml"), content.to_yaml
      end
    end

    it "returns the content of all test cases" do
      expect(described_class.all).to eq(test_cases.collect(&:second))
    end
  end

  describe "#write" do
    let(:agenda) { create(:combined_agenda) }
    let(:test_case) { YAML.load_file(@tmp_folder_path.join("#{agenda.token}.yaml")) }
    let(:test_case_data) do
      {
        agenda_attributes: {
          courses_per_schedule: agenda.courses_per_schedule,
          courses: agenda.courses,
          leaves: agenda.leaves,
          mandatory_course_ids: agenda.mandatory_course_ids,
          token: agenda.token,
        },
        generated_course_groups: agenda.schedules.collect(&:course_groups)
      }
    end
    subject { described_class.new(agenda.token) }
    before { subject.write }

    it "writes to file everything needed for testing the schedule generator" do
      expect(test_case).to eq(test_case_data)
    end
  end
end
