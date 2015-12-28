# encoding: utf-8

Alors /^je suis sur la page "(.+)"$/ do |title|
  expect(page).to have_css('h1', text: title)
end
