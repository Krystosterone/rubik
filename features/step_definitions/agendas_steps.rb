# encoding: utf-8

Lorsque /^que je sélectionne les cours (.+)$/ do |courses_list|
  courses = courses_list.split(/, | et /)
  courses.each { |course| find('label', text: course).click }
end

Lorsque /^que je sélectionne (\d) cours par horaire$/ do |courses_per_schedule|
  within('.courses-per-schedule-group') do
    find('label', text: courses_per_schedule).click
  end
end

Alors /^je vois un nouvel agenda pour (\w+) étudiants de la session d'(.+)$/ do |tag, academic_degree|
  expect(page).to have_field('Trimestre', with: "#{academic_degree} - #{tag.titleize} Étudiants")
end

Alors /^je vois un nouvel agenda avec comme trimestre "(.+)"$/ do |academic_degree|
  expect(page).to have_field('Baccalauréat', with: academic_degree)
end

Alors /^je vois un nouvel agenda avec comme cours:$/ do |courses_table|
  courses = courses_table.hashes.collect(&:values).reduce(:concat)
  courses.each { |code| expect(page).to have_selector(:checkbox, code, visible: false) }
end

Lorsque /^je soumets l'agenda$/ do
  click_button 'Soumettre'
end
