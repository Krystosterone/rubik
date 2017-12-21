# frozen_string_literal: true

class AdminConstraint
  def matches?(request)
    request.session[AdminSession::NAME]
  end
end
