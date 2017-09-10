# frozen_string_literal: true
FactoryGirl.define do
  factory :academic_degree do
    code { generate(:code) }
    name { generate(:name) }
  end

  factory :academic_degree_term do
    academic_degree
    term
  end

  factory :academic_degree_term_course do
    academic_degree_term
    course
    groups { build_list(:group, 4) }
  end

  factory :agenda do
    academic_degree_term
    courses do
      build_list(:agenda_course, 4).map do |course|
        course.academic_degree_term_course =
          build(:academic_degree_term_course, academic_degree_term: academic_degree_term)
        course.reset_group_numbers
        course
      end
    end
    courses_per_schedule 4
    leaves { build_list(:leave, 4) }

    factory :processing_agenda do
      processing true
    end

    factory :combined_agenda do
      combined_at { Time.zone.now }
      processing false
      schedules { build_list(:schedule, 4) }
    end

    factory :combined_empty_agenda do
      combined_at { Time.zone.now }
    end
  end

  factory :agenda_course, class: "Agenda::Course" do
    after(:build, &:reset_group_numbers)

    academic_degree_term_course
    agenda { Agenda.new }

    factory :mandatory_agenda_course do
      mandatory true
    end
  end

  factory :comment do
    user_email { generate(:email) }
    body
  end

  factory :course do
    code { generate(:code) }
  end

  factory :course_group do
    skip_create

    code { generate(:code) }
    group
  end

  factory :group do
    skip_create

    number { generate(:number) }
  end

  factory :leave do
    skip_create

    starts_at 100
    ends_at 400
  end

  factory :newsletter_subscription do
    email { generate(:email) }
  end

  factory :schedule do
    course_groups { build_list(:course_group, 4) }
  end

  factory :schedule_weekday do
    skip_create

    periods { build_list(:period, 4) }
  end

  factory :period do
    skip_create

    type
  end

  factory :term do
    enabled_at { Time.zone.now }
    name { generate(:name) }
    tags { generate(:tags) }
    year { generate(:year) }
  end

  sequence(:body) { |n| "Body #{n}" }
  sequence(:code) { |n| "Code #{n}" }
  sequence(:email) { |n| "email#{n}@domain.com" }
  sequence(:name) { |n| "Name #{n}" }
  sequence(:number) { |n| n }
  sequence(:tags) { |n| n.to_s }
  sequence(:type) { |n| "Type #{n}" }
  sequence(:year) { |n| n }
end
