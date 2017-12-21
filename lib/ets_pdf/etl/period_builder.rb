# frozen_string_literal: true

class EtsPdf::Etl::PeriodBuilder < SimpleClosure
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

  def initialize(group, parsed_lines)
    @group = group
    @parsed_lines = parsed_lines
  end

  def call
    @parsed_lines
      .map(&method(:normalize_data))
      .map(&method(:build))
      .map(&method(:normalize_weekday_index))
      .map(&method(:normalize_ends_at))
      .map(&method(:normalize_starts_at))
      .map(&method(:normalize_type))
      .each(&method(:build_period))
  end

  private

  def normalize_data(parsed_line)
    parsed_line.type?(:group) ? parsed_line.group : parsed_line.period
  end

  def build(data)
    {
      end_time: data.end_time,
      start_time: data.start_time,
      type: data.type,
      weekday: data.weekday,
    }
  end

  def normalize_weekday_index(attributes)
    weekday_index = I18n.t("date.abbr_day_names").index { |abbr| abbr.casecmp(attributes[:weekday].downcase).zero? } ||
                    raise("Invalid weekday '#{attributes[:weekday]}'")
    attributes.except(:weekday).merge(weekday_index: weekday_index)
  end

  def normalize_ends_at(attributes)
    normalize_time(attributes, :end_time, :ends_at)
  end

  def normalize_starts_at(attributes)
    normalize_time(attributes, :start_time, :starts_at)
  end

  def normalize_type(attributes)
    type = TYPES[attributes[:type]] || raise(ArgumentError, "Invalid type '#{attributes[:type]}'")
    attributes.merge(type: type)
  end

  def build_period(attributes)
    @group.find_or_initialize_period_by(attributes.except(:weekday_index))
  end

  def normalize_time(attributes, from_attribute, to_attribute)
    value = int_value_of(attributes[:weekday_index], attributes[from_attribute])
    attributes.except(from_attribute).merge(to_attribute => value)
  end

  def int_value_of(weekday_index, time)
    hours, minutes = time.split(":").map(&:to_i)
    weekday_index * MINUTES_IN_DAY + hours * 60 + minutes
  end
end
