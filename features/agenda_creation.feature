# language: fr

Fonctionnalité: Génération d'horaire
  En tant qu’étudiant,
  Je veux être en mesure de créer un agenda,
  Afin de générer toutes les possibilités d'horaires possible.

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
    Et que je sélectionne les cours CHM131, COM110, FRA151 et LOG100
    Et que je sélectionne 4 cours par horaire
    Lorsque je soumets l'agenda
    Alors je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours    | Type   |
      | 1                | Lundi    | 9:00 - 12:30  | CHM131-1 | C      |
      | 1                | Lundi    | 18:00 - 21:30 | FRA151-1 | C      |
      | 1                | Mardi    | 8:30 - 12:30  | COM110-1 | TP A+B |
      | 1                | Mercredi | 9:00 - 12:00  | CHM131-1 | TP     |
      | 1                | Mercredi | 13:30 - 17:00 | LOG100-1 | C      |
      | 1                | Mercredi | 18:00 - 22:00 | FRA151-1 | TP     |
      | 1                | Jeudi    | 9:00 - 12:30  | COM110-1 | C      |
      | 1                | Vendredi | 8:45 - 11:45  | LOG100-1 | Labo   |
      | 2                | Lundi    | 9:00 - 12:30  | CHM131-1 | C      |
      | 2                | Lundi    | 18:00 - 21:30 | FRA151-1 | C      |
      | 2                | Mardi    | 8:30 - 12:30  | COM110-1 | TP A+B |
      | 2                | Mercredi | 9:00 - 12:00  | CHM131-1 | TP     |
      | 2                | Mercredi | 13:30 - 16:30 | LOG100-2 | Labo   |
      | 2                | Mercredi | 18:00 - 22:00 | FRA151-1 | TP     |
      | 2                | Jeudi    | 9:00 - 12:30  | COM110-1 | C      |
      | 2                | Vendredi | 8:45 - 12:15  | LOG100-2 | C      |
