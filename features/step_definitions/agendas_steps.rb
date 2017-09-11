# encoding: utf-8
# frozen_string_literal: true

Alors /^je sélectionne l'option "(.+)"$/ do |option|
  choose option
end

Alors /^je vois les cours:$/ do |courses_table|
  courses = courses_table.hashes.collect(&:values).reduce(:concat)
  courses.each { |code| expect(page).to have_selector(:checkbox, code, visible: false) }
end

Alors /^je vois les cours (.+) déjà sélectionnés$/ do |courses_list|
  courses = courses_list.split(/, | et /)
  courses.each { |code| expect(page).to have_selector(:checkbox, code, visible: false, checked: true) }
end

Alors /^je vois (\d+) comme étant le nombre de cours par horaire sélectionné$/ do |courses_per_schedule|
  within ".courses-per-schedule-group" do
    radio_button = find_field("", visible: false, checked: true)
    expect(radio_button.value).to eq(courses_per_schedule)
  end
end

Lorsque /^je (?:dé-)?sélectionne les cours (.+)$/ do |courses_list|
  courses = courses_list.split(/, | et /)
  courses.each { |course| find("label", text: course).click }
end

Lorsque /^je (?:dé-)?sélectionne (.+) comme étant obligatoires$/ do |courses_list|
  course_codes = courses_list.split(/, | et /)
  courses = all(".course-checkbox-button")

  course_codes.each do |course_code|
    actual_course = courses.find { |course| course.text == course_code }
    raise "Unable to find course for #{row}" if actual_course.nil?

    actual_course.find("label:nth-of-type(2)").click
  end
end

Lorsque /^je dé-sélectionne les groupes:$/ do |groups|
  table_headers = all(".group-selection-table thead th").map(&:text)
  groups.hashes.each do |group|
    index = table_headers.index { |header| header == "#{group['Cours']} |" }
    find(".group-selection-table:nth-of-type(#{index + 1}) tbody th label", text: group["Groupe"]).click
  end
end

Lorsque /^je sélectionne (\d) comme étant le nombre de cours par horaire$/ do |courses_per_schedule|
  within(".courses-per-schedule-group") { find("label", text: courses_per_schedule).click }
end

Lorsque /^je décide de vouloir filtrer les groupes des cours possibles$/ do
  check "Filtrer les groupes comme prochaine étape"
end

Lorsque /^je décide de ne pas vouloir filtrer les groupes des cours possibles$/ do
  uncheck "Filtrer les groupes comme prochaine étape"
end

Lorsque /^je soumets l'agenda$/ do
  click_button "Soumettre"
end
