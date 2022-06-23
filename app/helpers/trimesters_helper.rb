# frozen_string_literal: true

module TrimestersHelper
  def trimesters_list(trimesters)
    if trimesters.size == 1
      "  - #{trimesters.first}"
    else
      trimesters.map.with_index { |trimester, index| "  #{index + 1}. #{trimester}" }.join("\n")
    end
  end

  def trimester_name(term)
    name = "#{term.name} #{term.year}"
    return name if term.tags.blank?

    "#{name} - #{term.tags}"
  end
end
