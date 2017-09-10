# frozen_string_literal: true
module AgendasHelper
  def agenda_term_tags(academic_degree_terms)
    term_tags =
      academic_degree_terms
        .map(&:term)
        .each_with_object([], &method(:agenda_term_reducer))
        .map(&method(:agenda_term_decorator))
        .uniq

    academic_degree_term_tags =
      academic_degree_terms
        .map(&:academic_degree)
        .map(&method(:agenda_academic_degree_decorator))
        .uniq

    term_tags + academic_degree_term_tags
  end

  def agenda_term_tag(agenda, term_tag)
    academic_degree_term = agenda.academic_degree_term
    return nil if academic_degree_term.nil?

    normalized_id =
      if term_tag.scope == "term"
        agenda_term_tag_id(scope: "term", value: academic_degree_term.term.tags)
      elsif term_tag.scope == "academic_degree"
        agenda_term_tag_id(scope: "academic_degree", value: academic_degree_term.academic_degree.code)
      end

    normalized_id == term_tag.id ? term_tag : nil
  end

  def agenda_term_name(agenda)
    params[:term_name] || agenda.academic_degree_term&.term&.name
  end

  def agenda_term_year(agenda)
    params[:term_year] || agenda.academic_degree_term&.term&.year
  end

  private

  def agenda_term_tag_id(attributes)
    Base64.encode64(attributes.map { |key, value| [key, value].join(":") }.join(";"))
  end

  def agenda_term_decorator(term)
    OpenStruct.new(
      id: agenda_term_tag_id(scope: "term", value: term.tags),
      label: term.tags,
      scope: "term",
    )
  end

  def agenda_term_reducer(term, memo)
    memo << term if term.tags.present?
  end

  def agenda_academic_degree_decorator(academic_degree)
    OpenStruct.new(
      id: agenda_term_tag_id(scope: "academic_degree", value: academic_degree.code),
      label: academic_degree.name,
      scope: "academic_degree"
    )
  end
end
