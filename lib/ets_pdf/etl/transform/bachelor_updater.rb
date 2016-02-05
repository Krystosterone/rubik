class EtsPdf::Etl::Transform::BachelorUpdater
  BACHELOR_HANDLES = {
    "seg" => "Enseignements généraux",
    "ctn" => "Génie de la construction",
    "ele" => "Génie électrique",
    "log" => "Génie logiciel",
    "mec" => "Génie mécanique",
    "gol" => "Génie des opérations et de la logistique",
    "gpa" => "Génie de la production automatisée",
    "gti" => "Génie des technologies de l'information",
  }

  def initialize(term, data)
    @term = term
    @data = data
  end

  def execute
    @data.each do |bachelor_handle, lines|
      bachelor_name = BACHELOR_HANDLES[bachelor_handle] || fail("Invalid bachelor handle \"#{bachelor_handle}\"")
      academic_degree = AcademicDegree.where(code: bachelor_handle).first_or_create!(name: bachelor_name)

      academic_degree_term = @term.academic_degree_terms.where(academic_degree: academic_degree).first_or_create!
      EtsPdf::Etl::Transform::AcademicDegreeUpdater.new(academic_degree_term, lines).execute
    end
  end
end
