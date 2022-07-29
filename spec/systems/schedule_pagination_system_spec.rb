# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Schedule Pagination", type: :system do
  before do
    driven_by(:rack_test)

    EtsPdf::Etl.call(
      Dir.glob("db/raw/ets/2022-automne-log.pdf")
    )
    Term.first.update!(enabled_at: Time.zone.now)
  end

  around { |block| Sidekiq::Testing.inline!(&block) }

  # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
  it "pagines schedules correctly" do
    visit "/"
    click_on "Génie logiciel"

    expect(page).to have_text("Choix de cours")

    find("label", text: "CHM131").click
    find("label", text: "LOG121").click
    within(".courses-per-schedule-group") { find("label", text: "2").click }
    click_button("Soumettre")

    expect(page).to have_text("Horaires")
    expect(page).to have_field("Nombre d'horaires générés", with: "36", disabled: true)
    within(".pager") do
      expect(page).to have_text("1")
      expect(page).to have_text("2")
      expect(page).to have_text("Suivant ›")
      expect(page).to have_text("Dernier »")

      click_on "Suivant ›"
    end

    within(".pager") do
      expect(page).to have_text("« Premier")
      expect(page).to have_text("‹ Précédent")
      expect(page).to have_text("1")
      expect(page).to have_text("2")
    end
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
end
