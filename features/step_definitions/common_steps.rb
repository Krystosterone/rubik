# frozen_string_literal: true

Alors(/^je me retrouve sur la page "(.+)"$/) do |title|
  expect(page).to have_css("h1", text: title)
end
