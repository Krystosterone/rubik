# frozen_string_literal: true
class EtsPdf::Etl::Transform::PeriodUpdater
  MINUTES_IN_DAY = 24 * 60
  TYPES = {
    "Atelier" => "Atelier",
    "C" => "C",
    "Labo" => "Labo",
    "Labo/2" => "Labo/2",
    "Labo A" => "Labo",
    "Labo A+B" => "Labo A+B",
    "Labo B" => "Labo",
    "Labo C" => "Labo",
    "Projet" => "Projet",
    "Projets" => "Projets",
    "TP" => "TP",
    "TP/2" => "TP/2",
    "TP A" => "TP",
    "TP A + B" => "TP A+B",
    "TP A+B" => "TP A+B",
    "TP B" => "TP",
    "TP/Labo" => "TP/Labo",
    "TP-Labo A" => "TP-Labo",
    "TP-Labo B" => "TP-Labo",
    "TP-Labo/2" => "TP-Labo/2",
  }.freeze

  def initialize(group, period_data)
    @group = group
    @period_data = period_data
  end

  def execute
    period = @group.find_or_initialize_period_by(starts_at: starts_at, ends_at: ends_at)
    period.type = type
  end

  private

  def type
    TYPES[@period_data.type] || raise(ArgumentError, "Type #{@period_data.type} is not allowed")
  end

  def starts_at
    int_value_of(@period_data.start_time)
  end

  def ends_at
    int_value_of(@period_data.end_time)
  end

  def int_value_of(time)
    hours, minutes = time.split(":").map(&:to_i)
    weekday_index * MINUTES_IN_DAY + hours * 60 + minutes
  end

  def weekday_index
    I18n.t("date.abbr_day_names").index { |abbr| abbr.casecmp(@period_data.weekday.downcase).zero? }
  end
end
