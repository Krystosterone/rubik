# frozen_string_literal: true

FactoryBot.define do
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
    courses_per_schedule { 4 }
    leaves { build_list(:leave, 4) }

    factory :processing_agenda do
      processing { true }
    end

    factory :combined_agenda do
      combined_at { Time.zone.now }
      processing { false }
      schedules { build_list(:schedule, 4) }
    end

    factory :combined_empty_agenda do
      combined_at { Time.zone.now }
    end
  end

  factory :agenda_course, class: "Agenda::Course" do
    after(:build) { |agenda_course| agenda_course.reset_group_numbers } # rubocop:disable Style/SymbolProc

    academic_degree_term_course
    agenda { Agenda.new }

    factory :mandatory_agenda_course do
      mandatory { true }
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

  factory :leave do
    skip_create

    starts_at { 100 }
    ends_at { 400 }
  end

  factory :parsed_document, class: "EtsPdf::Parser::ParsedDocument" do
    skip_create

    transient do
      parsed_lines { build_list(:unparsed_line, 3) }
    end

    initialize_with { new(parsed_lines) }
  end

  factory :user do
    email { generate(:email) }
  end

  factory :unparsed_line, class: "EtsPdf::Parser::ParsedLine" do
    skip_create

    transient do
      line { "" }
    end

    factory :parsed_bachelor_line do
      transient do
        name { generate(:bachelor_line_name) }

        line { "#{['baccalauréat en', ' service des'].sample} #{name}" }
      end
    end

    factory :parsed_course_line do
      transient do
        code { generate(:course_code) }

        line { code }
      end
    end

    factory :parsed_group_line do
      transient do
        number { generate(:group_number) }
        weekday { generate(:short_weekday) }
        start_time { generate(:time) }
        end_time { generate(:time) }
        type { "C" }

        line { "#{number} #{weekday} #{start_time} - #{end_time} #{type}" }
      end
    end

    factory :parsed_period_line do
      transient do
        weekday { generate(:short_weekday) }
        start_time { generate(:time) }
        end_time { generate(:time) }
        type { "C" }

        line { "#{weekday} #{start_time} - #{end_time} #{type}" }
      end
    end

    factory :parsed_term_line do
      transient do
        name { generate(:term_line_name) }
        year { generate(:year) }

        line { "#{name} #{year}" }
      end
    end

    initialize_with { new(line) }
  end

  factory :schedule do
    skip_create

    agenda
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
    year { generate(:year) }
    name { generate(:name) }
    enabled_at { Time.zone.now }
  end

  sequence(:bachelor_line_name) { |n| EtsPdf::BACHELOR_HANDLES.keys[n % EtsPdf::TERM_NAMES.size] }
  sequence(:body) { |n| "Body #{n}" }
  sequence(:code) { |n| "Code #{n}" }
  sequence(:course_code) { |n| "COD#{n.to_s.rjust(3, '0')}" }
  sequence(:email) { |n| "email#{n}@domain.com" }
  sequence(:group_number) { |n| (n % 100).to_s[0..2].rjust(2, "0") }
  sequence(:name) { |n| "Name #{n}" }
  sequence(:number) { |n| n }
  sequence(:short_weekday) { |n| I18n.t("date.abbr_day_names")[n % 7].titleize }
  sequence(:term_line_name) { |n| EtsPdf::TERM_NAMES.keys[n % EtsPdf::TERM_NAMES.size] }
  sequence(:time) { |n| "#{(n / 60).to_s.rjust(2, '0')}:#{(n % 60).to_s.rjust(2, '0')}" }
  sequence(:type) { |n| "Type #{n}" }
  sequence(:year) { |n| 1000 + n }
end
