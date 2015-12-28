# encoding: utf-8

Alors /^je vois les cours:$/ do |courses_table|
  courses = courses_table.hashes.collect(&:values).reduce(:concat)
  courses.each { |code| expect(page).to have_selector(:checkbox, code, visible: false) }
end

Lorsque /^je sélectionne les cours (.+)$/ do |courses_list|
  courses = courses_list.split(/, | et /)
  courses.each { |course| find('label', text: course).click }
end

Lorsque /^je sélectionne (\d) comme étant le nombre de cours par horaire$/ do |courses_per_schedule|
  within('.courses-per-schedule-group') do
    find('label', text: courses_per_schedule).click
  end
end

Lorsque /^je soumets l'agenda$/ do
  click_button 'Soumettre'
end
