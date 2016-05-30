class MigrateAgendasMandatoryCourseCodes < ActiveRecord::Migration[5.0]
  def up
    Agenda.all.each do |agenda|
      mandatory_course_codes = JSON.parse(agenda.mandatory_course_codes || "[]")
      agenda.mandatory_course_ids = mandatory_course_codes.collect do |mandatory_course_code|
        agenda.courses.find { |course| course.code.casecmp(mandatory_course_code).zero? }.id
      end
      agenda.save!
    end
  end
end
