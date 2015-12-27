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
  end

  factory :agenda do
    academic_degree_term
    courses { build_list(:academic_degree_term_course, 4) }
    courses_per_schedule 4

    factory :combined_agenda do
      combined_at { Time.zone.now }
      schedules { build_list(:schedule, 4) }
    end
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

  factory :schedule do
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
    year { generate(:year) }
    name { generate(:name) }
  end

  sequence(:code) { |n| "Code #{n}" }
  sequence(:name) { |n| "Name #{n}" }
  sequence(:number) { |n| n }
  sequence(:type) { |n| "Type #{n}" }
  sequence(:year) { |n| n }
end
