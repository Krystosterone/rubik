# frozen_string_literal: true

Étantdonnéqu /^je suis sur la page (.*)/ do |page_name|
  visit path_to(page_name)
end

Lorsque /^je sélectionne le trimestre "(.+)"$/ do |academic_degree|
  click_link academic_degree
end
