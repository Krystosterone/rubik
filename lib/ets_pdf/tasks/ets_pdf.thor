# frozen_string_literal: true

require "thor"

module EtsPdf
  class Tasks < Thor
    namespace :ets_pdf

    desc "etl", "Extracts ETS' PDF content to Database"
    method_option :data, aliases: "-d", type: :array
    def etl
      if options["data"].nil?
        EtsPdf::Etl.call
      else
        EtsPdf::Etl.call(options["data"])
      end
    end
  end
end

