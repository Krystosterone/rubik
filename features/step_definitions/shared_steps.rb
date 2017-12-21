# frozen_string_literal: true

Alors /^je vois le trimestre "(.+)" d'affiché$/ do |term|
  expect(page).to have_field("Trimestre", with: term, disabled: true)
end

Alors /^je vois le baccalauréat "(.+)" d'affiché$/ do |academic_degree|
  expect(page).to have_field("Baccalauréat", with: academic_degree, disabled: true)
end
