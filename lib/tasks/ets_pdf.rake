# frozen_string_literal: true
namespace :ets_pdf do
  task etl: :environment do
    EtsPdf::Etl.new(*ENV["PDF_FOLDER"]).execute
  end
end
