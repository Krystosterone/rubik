# frozen_string_literal: true

EtsPdf::Etl.call
Term.update_all(enabled_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
