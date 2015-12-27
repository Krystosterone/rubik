class EtsPdf::Etl::Transform::TermUpdater
  TERM_HANDLES = {
    'automne' => 'Automne',
    'ete' => 'Été',
    'hiver' => 'Hiver',
  }
  TERM_TAGS = {
    'anciens' => 'Anciens Étudiants',
    'nouveaux' => 'Nouveaux Étudiants',
  }

  def initialize(year, term)
    @year = year
    @term = term
  end

  def execute
    @term.each do |term_handle, bachelor_types|
      term_name = TERM_HANDLES[term_handle] || fail("Invalid term handle \"#{term_handle}\"")
      for_each_bachelor_type(term_name, bachelor_types)
    end
  end

  private

  def for_each_bachelor_type(term_name, bachelor_types)
    bachelor_types.each do |bachelor_type, bachelors_data|
      term_tags = TERM_TAGS[bachelor_type] || fail("Invalid bachelor type \"#{bachelor_type}\"")
      term = Term.where(year: @year, name: term_name, tags: term_tags).first_or_create!

      EtsPdf::Etl::Transform::BachelorUpdater.new(term, bachelors_data).execute
    end
  end
end
