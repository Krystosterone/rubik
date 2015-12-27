# language: fr

Fonctionnalité: Génération d'horaire
  En tant qu’étudiant,
  Je veux être en mesure de créer un agenda,
  Afin de générer toutes les possibilités d'horaires possible.

  @save-screenshot
  Scénario: Une simple combinaison d'horaire
    Étant donné qu'il existe des cours pour nouveaux étudiants de la session d'Hiver 2016
    Et que je suis sur la page des trimestres
    Lorsque je sélectionne le trimestre de Génie logiciel
    Alors je vois un nouvel agenda pour nouveaux étudiants de la session d'Hiver 2016
    Et je vois un nouvel agenda avec comme trimestre "Génie logiciel"
    Et je vois un nouvel agenda avec comme cours:
      | Code    |
      | ATE050  |
      | CHM131  |
      | COM110  |
      | FRA150  |
      | FRA151  |
      | INF111  |
      | INFTEST |
      | ING150  |
      | LOG100  |
      | MAT144  |
      | MAT145  |
      | MATEST  |
      | PHY144  |
      | PHYEST  |
    Et que je sélectionne les cours CHM131, COM110, FRA151, LOG100 et MAT145
    Et que je sélectionne 4 cours par horaire
    Lorsque je soumets l'agenda
    Alors je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours  | Groupe | Type      |
      | 1                | Lundi    | 8:30 - 11:30  | LOG430 | 4      | TP        |
