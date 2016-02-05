namespace :ets_pdf do
  task etl: :environment do
    etl = EtsPdf::Etl.new(ENV.fetch("PDF_FOLDER", "db/raw/ets/**/*"))
    etl.execute
  end
end
