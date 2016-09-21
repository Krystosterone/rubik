# frozen_string_literal: true

EtsPdf::Etl.new.execute
Term.update_all(enabled_at: Time.zone.now)
