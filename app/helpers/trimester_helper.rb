# frozen_string_literal: true
module TrimesterHelper
  def trimesters_list
    if @trimesters.size == 1
      "  - #{@trimesters.first}"
    else
      @trimesters.map.with_index { |trimester, index| "  #{index + 1}. #{trimester}" }.join("\n")
    end
  end
end
