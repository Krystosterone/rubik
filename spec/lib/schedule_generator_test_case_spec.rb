# frozen_string_literal: true

require "rails_helper"

describe ScheduleGeneratorTestCase do
  before do
    @current_folder_path = described_class.folder_path
    @tmp_folder_path = Rails.root.join("tmp", "schedule_generator_test_cases")

    FileUtils.mkdir_p(@tmp_folder_path)
    described_class.folder_path = @tmp_folder_path
  end
  after do
    FileUtils.rm_rf(@tmp_folder_path)
    described_class.folder_path = @current_folder_path
  end

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
      expect(described_class.all).to contain_exactly(*test_cases.collect(&:second))
    end
  end

  describe "#write" do
    subject(:generator) { described_class.new(agenda.token) }

    let(:agenda) { create(:combined_agenda) }
    let(:test_case) { YAML.load_file(@tmp_folder_path.join("#{agenda.token}.yml")) }
    let(:academic_degree_term_courses_attributes) do
      agenda.courses.map do |course|
        {
          course_attributes: { code: course.code },
          id: course.academic_degree_term_course_id,
          groups: course.academic_degree_term_course.groups,
        }
      end
    end
    let(:courses_attributes) do
      agenda.courses.map do |course|
        {
          academic_degree_term_course_id: course.academic_degree_term_course_id,
          group_numbers: course.academic_degree_term_course.groups.map(&:number),
          mandatory: course.mandatory?,
        }
      end
    end
    let(:test_case_data) do
      {
        academic_degree_term_courses_attributes: academic_degree_term_courses_attributes,
        agenda_attributes: {
          courses_attributes: courses_attributes,
          courses_per_schedule: agenda.courses_per_schedule,
          leaves: agenda.leaves,
          token: agenda.token,
        },
        generated_course_groups: agenda.schedules.collect(&:course_groups)
      }
    end

    before { generator.write }

    it "writes to file everything needed for testing the schedule generator" do
      expect(test_case.slice(:agenda_attributes)).to eq(test_case_data.slice(:agenda_attributes))
    end
  end
end
