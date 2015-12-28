# encoding: utf-8

Alors /^je vois le trimestre "(.+)" d'affiché$/ do |term|
  expect(page).to have_field('Trimestre', with: term)
end

Alors /^je vois le baccalauréat "(.+)" d'affiché$/ do |academic_degree|
  expect(page).to have_field('Baccalauréat', with: academic_degree)
end
