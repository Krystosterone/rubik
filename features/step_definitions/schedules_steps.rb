# frozen_string_literal: true

Alors /^je vois (\d+) comme étant le nombre de cours par horaire affiché$/ do |courses_per_schedule|
  expect(page).to have_field("Nombre de cours par horaire", with: courses_per_schedule, disabled: true)
end

Alors /^je vois les cours sélectionnés:$/ do |table|
  document = Nokogiri::HTML(html)
  courses = document.css(".courses-selected tbody tr")

  table.hashes.each do |row|
    actual_course = courses.find do |course|
      columns = course.css("td")

      columns[0].css("i").attr("class").value.include?(row["Obligatoire"] == "oui" ? "fa-lock" : "fa-unlock") &&
        columns[1].text.strip == row["Cours"] &&
        columns[2].text.strip.split("\n") == row["Groupes"].split(",").map(&:strip)
    end
    raise "Unable to find course #{row}" if actual_course.nil?
  end
end

Alors(/^je vois (\d+) possibilités? d'horaires?$/) do |count|
  expect(page).to have_selector(".schedules fieldset", count: count)
end

Alors /^je vois les horaires:$/ do |table|
  document = Nokogiri::HTML(html)
  schedules = document.css(".schedules .schedule")

  table.hashes.each do |row|
    weekday_index = I18n.t("date.day_names").index(row["Jour"].downcase)

    actual_schedule = schedules.find do |schedule|
      schedule.css("legend:contains('Horaire - #{row["Numéro d'horaire"]}')").present?
    end
    weekday = actual_schedule.at_css(".weekday-#{weekday_index}")

    actual_period = weekday.css(".period").find do |period|
      period.css("div:contains('#{row['Période']}')").present? &&
        period.css("div:contains('#{row['Cours']}')").present? &&
        period.css("div:contains('#{row['Type']}')").present?
    end
    raise "Unable to find period #{row}" if actual_period.nil?
  end
end

Lorsque /^j'édite l'agenda$/ do
  click_link "Éditer"
end
