# language: fr

Fonctionnalité: Édition d'un agenda
  En tant qu’étudiant,
  Je veux être en mesure d'éditer un agenda,
  Afin de parfaire les possibilités d'horaires possible.

  Scénario: Éditer un horaire existant
    Étant donné qu'il existe des cours pour nouveaux étudiants de la session d'Hiver 2016
    Et que je suis sur la page des trimestres
    Lorsque je sélectionne le trimestre "Génie logiciel"
    Lorsque je sélectionne les cours CHM131, COM110, FRA151 et LOG100
    Et je sélectionne 4 comme étant le nombre de cours par horaire
    Et je soumets l'agenda
    Et que j'édite l'agenda
    Alors je suis sur la page "Choix de cours"
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
    Et je vois les cours CHM131, COM110, FRA151 et LOG100 déjà sélectionnés
    Et je vois 4 comme étant le nombre de cours par horaire sélectionné
    Lorsque je dé-sélectionne les cours FRA151 et LOG100
    Et je sélectionne les cours ATE050 et INF111
    Lorsque je soumets l'agenda
    Alors je suis sur la page "Horaires"
    Et je vois le trimestre "Hiver 2016 - Nouveaux Étudiants" d'affiché
    Et je vois le baccalauréat "Génie logiciel" d'affiché
    Et je vois 4 comme étant le nombre de cours par horaire affiché
    Et je vois ATE050, CHM131, COM110 et INF111 comme étant les cours sélectionnés
    Et je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours    | Type    |
      | 1                | Lundi    | 9:00 - 12:30  | CHM131-1 | C       |
      | 1                | Mardi    | 8:30 - 12:30  | COM110-1 | TP A+B  |
      | 1                | Mardi    | 18:00 - 20:00 | ATE050-1 | Atelier |
      | 1                | Mercredi | 9:00 - 12:00  | CHM131-1 | TP      |
      | 1                | Mercredi | 13:30 - 17:00 | INF111-3 | C       |
      | 1                | Jeudi    | 9:00 - 12:30  | COM110-1 | C       |
      | 1                | Vendredi | 9:00 - 12:00  | INF111-3 | Labo    |
