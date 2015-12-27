json.array! terms do |term|
  json.(term, :name, :year, :tags)
  json.academic_degree_terms term.academic_degree_terms do |academic_degree_term|
    json.(academic_degree_term, :id, :name)
  end
end
