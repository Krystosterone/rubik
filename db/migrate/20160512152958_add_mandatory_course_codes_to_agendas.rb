class AddMandatoryCourseCodesToAgendas < ActiveRecord::Migration[5.0]
  def change
    add_column :agendas, :mandatory_course_codes, :text
  end
end
