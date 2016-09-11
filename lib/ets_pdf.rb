# frozen_string_literal: true
module EtsPdf
  require "ets_pdf/parser"
  require "ets_pdf/parser/parsed_line"
  require "ets_pdf/parser/parsed_line/base"
  require "ets_pdf/parser/parsed_line/course"
  require "ets_pdf/parser/parsed_line/group"
  require "ets_pdf/parser/parsed_line/period"

  require "ets_pdf/etl"
  require "ets_pdf/etl/extract"
  require "ets_pdf/etl/transform"
  require "ets_pdf/etl/transform/academic_degree_updater"
  require "ets_pdf/etl/transform/bachelor_updater"
  require "ets_pdf/etl/transform/term_updater"
end
