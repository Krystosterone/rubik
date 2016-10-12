# frozen_string_literal: true
module AgendaEagerLoading
  extend ActiveSupport::Concern

  private

  def find_agenda
    @agenda = Agenda.left_joins(:courses).find_by!(token: agenda_token)
  end

  def eager_load_courses
    @agenda.courses = @agenda.courses.includes(:academic_degree_term_course).all
  end
end
