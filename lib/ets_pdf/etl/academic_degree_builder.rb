# frozen_string_literal: true

class EtsPdf::Etl::AcademicDegreeBuilder < SimpleClosure
  def initialize(term, document)
    super()
    @term = term
    @document = document
  end

  def call
    @document
      .then(&method(:extract_attributes))
      .then(&method(:create_academic_degree))
  end

  private

  def extract_attributes(document)
    bachelor_line = document.bachelor_line
    name, code = EtsPdf::BACHELOR_HANDLES.find { |name, _| name.downcase == bachelor_line.name.downcase }

    { code: code, name: name }
  end

  def create_academic_degree(attributes)
    academic_degree = AcademicDegree.where(attributes).first_or_create!
    academic_degree_term = create_academic_degree_term(academic_degree)

    EtsPdf::Etl::AcademicDegreeTermCourseBuilder.call(
      academic_degree_term,
      @document.except(:bachelor).parsed_lines
    )
  end

  def create_academic_degree_term(academic_degree)
    @term.academic_degree_terms.create!(academic_degree: academic_degree)
  rescue ActiveRecord::RecordNotUnique => e
    raise <<-MESSAGE.chomp.strip_heredoc
    #{e}
      Unable to create "AcademicDegreeTerm"
        in #{self.class}
        on "Term" = "#{@term.year}, #{@term.name}
        with "AcademicDegree" = "#{academic_degree.code}"
    MESSAGE
  end
end
