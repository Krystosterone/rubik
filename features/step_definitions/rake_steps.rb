# frozen_string_literal: true

# rubocop:disable Naming/AsciiIdentifiers
Étantdonnéqu /^il existe des cours pour (\w+) étudiants de la session d'(\w+) (\d+)$/ do |tag, term, year|
  `rake ets_pdf:etl PDF_FOLDER=db/raw/ets/#{year}/#{term.downcase}/#{tag}/**/*`
  Term.update_all(enabled_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
end
# rubocop:enable Naming/AsciiIdentifiers
