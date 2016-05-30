class RemoveAgendasMandatoryCourseCodes < ActiveRecord::Migration[5.0]
  def change
    remove_column :agendas, :mandatory_course_codes, :text
  end
end
