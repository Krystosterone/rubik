# frozen_string_literal: true
require_dependency "agenda/course"

class MigrateSerializedDataToAgendaCourses < ActiveRecord::Migration[5.0]
  def up
    Agenda.find_each do |agenda|
      agenda.courses.each do |course|
        unless agenda.academic_degree_term_courses.exists?(course.id)
          Rails.logger.info("[MigrateSerializedDataToAgendaCourses] Unable to migrate #{agenda.id}")
          agenda.destroy!
          break
        end

        create(course, agenda)
      end
    end
  end

  private

  def create(course, agenda)
    ::Agenda::Course.create!(
      academic_degree_term_course_id: course.id,
      agenda_id: agenda.id,
      mandatory: course.id.in?(agenda.mandatory_course_ids)
    )
  end
end
