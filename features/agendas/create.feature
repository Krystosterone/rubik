# language: fr

Fonctionnalité: Création d'un agenda
  En tant qu’étudiant,
  Je veux être en mesure de créer un agenda,
  Afin de générer toutes les possibilités d'horaires possible.

  Contexte:
    Étant donné qu'il existe des cours pour nouveaux étudiants de la session d'Hiver 2016
    Et que je suis sur la page des trimestres

  Scénario: Une simple combinaison d'horaire
    Lorsque je sélectionne le trimestre "Hiver"
    Alors je me retrouve sur la page "Choix des filtres"
    Lorsque je sélectionne l'option "Nouveaux Étudiants"
    Et je sélectionne l'option "Génie logiciel"
    Et je soumets l'agenda
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
    Lorsque je sélectionne les cours FRA150, INFTEST, MATEST et PHYEST
    Et je sélectionne 4 comme étant le nombre de cours par horaire
    Et je soumets l'agenda
    Alors je me retrouve sur la page "Horaires"
    Et je vois le trimestre "Hiver 2016 - Nouveaux Étudiants" d'affiché
    Et je vois le baccalauréat "Génie logiciel" d'affiché
    Et je vois 4 comme étant le nombre de cours par horaire affiché
    Et je vois les cours sélectionnés:
      | Obligatoire | Cours   | Groupes |
      | non         | FRA150  | 1       |
      | non         | INFTEST | 1       |
      | non         | MATEST  | 1, 3    |
      | non         | PHYEST  | 1, 2    |
    Et je vois 2 possibilités d'horaires
    Et je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours     | Type   |
      | 1                | Lundi    | 9:00 - 12:30  | PHYEST-1  | C      |
      | 1                | Lundi    | 18:00 - 21:30 | FRA150-1  | C      |
      | 1                | Mardi    | 9:00 - 12:30  | MATEST-1  | C      |
      | 1                | Mercredi | 9:00 - 12:00  | PHYEST-1  | TP     |
      | 1                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 1                | Mercredi | 18:00 - 20:00 | FRA150-1  | TP     |
      | 1                | Jeudi    | 9:00 - 12:00  | MATEST-1  | TP     |
      | 1                | Vendredi | 9:00 - 12:00  | INFTEST-1 | Labo   |
      | 2                | Lundi    | 18:00 - 21:30 | FRA150-1  | C      |
      | 2                | Mardi    | 9:00 - 12:30  | MATEST-1  | C      |
      | 2                | Mardi    | 18:00 - 21:30 | PHYEST-2  | C      |
      | 2                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 2                | Mercredi | 18:00 - 20:00 | FRA150-1  | TP     |
      | 2                | Jeudi    | 9:00 - 12:00  | MATEST-1  | TP     |
      | 2                | Jeudi    | 18:00 - 21:00 | PHYEST-2  | TP     |
      | 2                | Vendredi | 9:00 - 12:00  | INFTEST-1 | Labo   |

  Scénario: Une combinaison d'horaire avec des groupes cours
    Lorsque je sélectionne le trimestre "Hiver"
    Et je sélectionne l'option "Nouveaux Étudiants"
    Et je sélectionne l'option "Génie logiciel"
    Et je soumets l'agenda
    Et je sélectionne les cours FRA150, INFTEST, MATEST et PHYEST
    Et je sélectionne 4 comme étant le nombre de cours par horaire
    Et je décide de vouloir filtrer les groupes des cours possibles
    Lorsque je soumets l'agenda
    Alors je me retrouve sur la page "Choix de groupes"
    Lorsque je dé-sélectionne les groupes:
      | Cours  | Groupe |
      | MATEST | 3      |
      | PHYEST | 2      |
    Et je soumets l'agenda
    Alors je me retrouve sur la page "Horaires"
    Et je vois les cours sélectionnés:
      | Obligatoire | Cours   | Groupes |
      | non         | FRA150  | 1       |
      | non         | INFTEST | 1       |
      | non         | MATEST  | 1       |
      | non         | PHYEST  | 1       |
    Et je vois 1 possibilité d'horaire
    Et je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours     | Type   |
      | 1                | Lundi    | 9:00 - 12:30  | PHYEST-1  | C      |
      | 1                | Lundi    | 18:00 - 21:30 | FRA150-1  | C      |
      | 1                | Mardi    | 9:00 - 12:30  | MATEST-1  | C      |
      | 1                | Mercredi | 9:00 - 12:00  | PHYEST-1  | TP     |
      | 1                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 1                | Mercredi | 18:00 - 20:00 | FRA150-1  | TP     |
      | 1                | Jeudi    | 9:00 - 12:00  | MATEST-1  | TP     |
      | 1                | Vendredi | 9:00 - 12:00  | INFTEST-1 | Labo   |

Scénario: Une combinaison d'horaire avec des cours obligatoires
  Lorsque je sélectionne le trimestre "Hiver"
  Et je sélectionne l'option "Nouveaux Étudiants"
  Et je sélectionne l'option "Génie logiciel"
  Et je soumets l'agenda
  Et je sélectionne les cours MAT144, INFTEST, MATEST et LOG100
  Et je sélectionne INFTEST et MATEST comme étant obligatoires
  Et je sélectionne 3 comme étant le nombre de cours par horaire
  Lorsque je soumets l'agenda
  Alors je me retrouve sur la page "Horaires"
  Et je vois les cours sélectionnés:
    | Obligatoire | Cours   | Groupes |
    | non         | MAT144  | 1, 3    |
    | oui         | INFTEST | 1       |
    | oui         | MATEST  | 1, 3    |
    | non         | LOG100  | 1, 2    |
  Et je vois 2 possibilités d'horaires
  Et je vois les horaires:
    | Numéro d'horaire | Jour     | Période       | Cours     | Type   |
    | 1                | Lundi    | 18:00 - 21:30 | MAT144-3  | C      |
    | 1                | Mardi    | 9:00 - 12:30  | MATEST-1  | C      |
    | 1                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
    | 1                | Mercredi | 18:00 - 21:00 | MAT144-3  | TP     |
    | 1                | Jeudi    | 9:00 - 12:00  | MATEST-1  | TP     |
    | 1                | Vendredi | 9:00 - 12:00  | INFTEST-1 | Labo   |
    | 2                | Lundi    | 18:00 - 21:30 | MATEST-3  | C      |
    | 2                | Mardi    | 9:00 - 12:30  | MAT144-1  | C      |
    | 2                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
    | 2                | Mercredi | 18:00 - 21:00 | MATEST-3  | TP     |
    | 2                | Jeudi    | 9:00 - 12:00  | MAT144-1  | TP     |
    | 2                | Vendredi | 9:00 - 12:00  | INFTEST-1 | Labo   |
