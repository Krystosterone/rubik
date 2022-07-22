# frozen_string_literal: true

# rubocop:disable Naming/AsciiIdentifiers
Étantdonnéqu(/^il existe des cours pour (\w+) étudiants de la session d'(\w+) (\d+)$/) do |tag, term, year|
  `thor ets_pdf:etl -d #{Dir.glob("db/raw/ets/#{year}/#{term.downcase}/#{tag}/**/*.pdf").join(" ")}`
  Term.update_all(enabled_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
end
# rubocop:enable Naming/AsciiIdentifiers
