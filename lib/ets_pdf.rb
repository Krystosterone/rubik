# frozen_string_literal: true

module EtsPdf
  TERM_NAMES = {
    "automne" => "Automne",
    "eté" => "Été",
    "été" => "Été",
    "hiver" => "Hiver",
  }.freeze
  BACHELOR_HANDLES = {
    "Enseignements généraux" => "seg",
    "Génie de la construction" => "ctn",
    "Génie électrique" => "ele",
    "Génie logiciel" => "log",
    "Génie mécanique" => "mec",
    "Génie des opérations et de la logistique" => "gol",
    "Génie de la production automatisée" => "gpa",
    "Génie des technologies de l'information" => "gti"
  }.freeze
end
