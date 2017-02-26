# language: fr

Fonctionnalité: Édition d'un agenda
  En tant qu’étudiant,
  Je veux être en mesure d'éditer un agenda,
  Afin de parfaire les possibilités d'horaires possible.

  Scénario: Éditer un horaire existant
    Étant donné qu'il existe des cours pour nouveaux étudiants de la session d'Hiver 2016
    Et que je suis sur la page des trimestres
    Lorsque je sélectionne le trimestre "Génie logiciel"
    Lorsque je sélectionne les cours FRA150, INFTEST, MATEST et PHYEST
    Et je sélectionne 4 comme étant le nombre de cours par horaire
    Et je soumets l'agenda
    Et que j'édite l'agenda
    Alors je me retrouve sur la page "Choix de cours"
    Et je vois le trimestre "Hiver 2016 - Nouveaux Étudiants" d'affiché
    Et je vois le baccalauréat "Génie logiciel" d'affiché
    Et je vois les cours:
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
    Et je vois les cours FRA150, INFTEST, MATEST et PHYEST déjà sélectionnés
    Et je vois 4 comme étant le nombre de cours par horaire sélectionné
    Lorsque je dé-sélectionne les cours FRA150
    Et je sélectionne les cours FRA151
    Lorsque je soumets l'agenda
    Alors je me retrouve sur la page "Horaires"
    Et je vois le trimestre "Hiver 2016 - Nouveaux Étudiants" d'affiché
    Et je vois le baccalauréat "Génie logiciel" d'affiché
    Et je vois 4 comme étant le nombre de cours par horaire affiché
    Et je vois les cours sélectionnés:
      | Obligatoire | Cours   | Groupes |
      | non         | FRA151  | 1       |
      | non         | MATEST  | 1, 3    |
      | non         | PHYEST  | 1, 2    |
      | non         | FRA151  | 1       |
    Et je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours     | Type   |
      | 1                | Lundi    | 9:00 - 12:30  | PHYEST-1  | C      |
      | 1                | Lundi    | 18:00 - 21:30 | FRA151-1  | C      |
      | 1                | Mardi    | 9:00 - 12:30  | MATEST-1  | C      |
      | 1                | Mercredi | 9:00 - 12:00  | PHYEST-1  | TP     |
      | 1                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 1                | Mercredi | 18:00 - 22:00 | FRA151-1  | TP     |
      | 1                | Jeudi    | 9:00 - 12:00  | MATEST-1  | TP     |
      | 1                | Vendredi | 9:00 - 12:00  | INFTEST-1 | Labo   |
      | 2                | Lundi    | 18:00 - 21:30 | FRA151-1  | C      |
      | 2                | Mardi    | 9:00 - 12:30  | MATEST-1  | C      |
      | 2                | Mardi    | 18:00 - 21:30 | PHYEST-2  | C      |
      | 2                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 2                | Mercredi | 18:00 - 22:00 | FRA151-1  | TP     |
      | 2                | Jeudi    | 9:00 - 12:00  | MATEST-1  | TP     |
      | 2                | Jeudi    | 18:00 - 21:00 | PHYEST-2  | TP     |
      | 2                | Vendredi | 9:00 - 12:00  | INFTEST-1 | Labo   |

# TODO: Add test when editing back and forth with groups
