# encoding: utf-8

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

Lorsque /^je sélectionne (\d) comme étant le nombre de cours par horaire$/ do |courses_per_schedule|
  within(".courses-per-schedule-group") { find("label", text: courses_per_schedule).click }
end

Lorsque /^je soumets l'agenda$/ do
  click_button "Soumettre"
end
