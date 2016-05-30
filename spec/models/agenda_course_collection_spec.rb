require "rails_helper"

describe AgendaCourseCollection do
  let(:courses) do
    [
      AgendaCourse.new(
        id: 1,
        code: "COURSE_1",
        groups: [
          Group.new(periods: [
            Period.new(starts_at: 0, ends_at: 100),
            Period.new(starts_at: 1000, ends_at: 1500),
          ]),
          Group.new(periods: [
            Period.new(starts_at: 500, ends_at: 600),
          ]),
        ]
      ),
      AgendaCourse.new(
        id: 2,
        code: "COURSE_2",
        groups: [
          Group.new(periods: [
            Period.new(starts_at: 1600, ends_at: 1700),
            Period.new(starts_at: 1900, ends_at: 2000),
          ]),
        ]
      ),
    ]
  end
  let(:mandatory_course_ids) { [1] }
  let(:leaves) do
    [
      Leave.new(starts_at: 0, ends_at: 50),
      Leave.new(starts_at: 1850, ends_at: 1901),
    ]
  end

  subject { described_class.new(courses, mandatory_course_ids, leaves) }

  its(:mandatory) { is_expected.to eq([courses[0]]) }
  its(:remainder) { is_expected.to eq([courses[1]]) }
  its(:pruned) do
    is_expected.to eq([
      AgendaCourse.new(
        id: 1,
        code: "COURSE_1",
        groups: [
          Group.new(periods: [
            Period.new(starts_at: 500, ends_at: 600),
          ]),
        ]
      )
    ])
  end
end
