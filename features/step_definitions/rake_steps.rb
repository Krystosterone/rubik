# encoding: utf-8
# frozen_string_literal: true

Étantdonnéqu /^il existe des cours pour (\w+) étudiants de la session d'(\w+) (\d+)$/ do |tag, term, year|
  `rake ets_pdf:etl PDF_FOLDER=db/raw/ets/#{year}/#{term.downcase}/#{tag}/**/*`
  Term.update_all(enabled_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
end
