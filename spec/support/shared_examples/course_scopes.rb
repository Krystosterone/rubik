# frozen_string_literal: true
shared_examples "CourseScopes" do |described_class:|
  subject { described_class.new(courses: courses, leaves: leaves, mandatory_course_ids: mandatory_course_ids) }
  let(:courses) { [] }
  let(:leaves) { [] }
  let(:mandatory_course_ids) { [] }

  let(:courses_collection) { instance_double(AgendaCourseCollection) }
  let(:mandatory_courses_collection) { instance_double(AgendaCourseCollection) }
  let(:remainder_courses_collection) { instance_double(AgendaCourseCollection) }
  let(:pruned_courses_collection) { instance_double(AgendaCourseCollection) }
  let(:pruned_mandatory_courses_collection) { instance_double(AgendaCourseCollection) }
  let(:pruned_remainder_courses_collection) { instance_double(AgendaCourseCollection) }

  before do
    allow(AgendaCourseCollection)
      .to receive(:new).with(courses, mandatory_course_ids, leaves).and_return(courses_collection)

    allow(courses_collection).to receive(:mandatory).and_return(mandatory_courses_collection)
    allow(courses_collection).to receive(:remainder).and_return(remainder_courses_collection)
    allow(courses_collection).to receive(:pruned).and_return(pruned_courses_collection)

    allow(pruned_courses_collection).to receive(:mandatory).and_return(pruned_mandatory_courses_collection)
    allow(pruned_courses_collection).to receive(:remainder).and_return(pruned_remainder_courses_collection)
  end

  its(:courses) { is_expected.to eq(courses_collection) }
  its(:mandatory_courses) { is_expected.to eq(mandatory_courses_collection) }
  its(:remainder_courses) { is_expected.to eq(remainder_courses_collection) }
  its(:pruned_courses) { is_expected.to eq(pruned_courses_collection) }
  its(:pruned_mandatory_courses) { is_expected.to eq(pruned_mandatory_courses_collection) }
  its(:pruned_remainder_courses) { is_expected.to eq(pruned_remainder_courses_collection) }
end
