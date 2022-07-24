# language: fr

Fonctionnalité: Création d'un agenda
  En tant qu’étudiant,
  Je veux être en mesure de créer un agenda,
  Afin de générer toutes les possibilités d'horaires possible.

  Contexte:
    Étant donné qu'il existe des cours pour la session d'Hiver 2019
    Et que je suis sur la page des trimestres

  Scénario: Une simple combinaison d'horaire
    Lorsque je sélectionne le trimestre "Enseignements généraux"
    Alors je me retrouve sur la page "Choix de cours"
    Et je vois le trimestre "Hiver 2019" d'affiché
    Et je vois le baccalauréat "Enseignements généraux" d'affiché
    Et je vois les cours:
      | Code    |
      | CHM131  |
      | COM110  |
      | COM115  |
      | COM129  |
      | ENT201  |
      | ENT202  |
      | GIA400  |
      | GIA410  |
      | GIA450  |
      | INF111  |
      | INF130  |
      | INF135  |
      | INF145  |
      | INF155  |
      | INFTEST |
      | ING150  |
      | ING160  |
      | ING500  |
      | MAT144  |
      | MAT145  |
      | MAT165  |
      | MAT210  |
      | MAT265  |
      | MAT321  |
      | MAT350  |
      | MAT415  |
      | MAT472  |
      | MATEST  |
      | PEP110  |
      | PHY144  |
      | PHY332  |
      | PHY335  |
      | PHYEST  |
      | PRE011  |
      | TIN503  |
    Lorsque je sélectionne les cours ENT202, INFTEST, MATEST et PHYEST
    Et je sélectionne 4 comme étant le nombre de cours par horaire
    Et je soumets l'agenda
    Alors je me retrouve sur la page "Horaires"
    Et je vois le trimestre "Hiver 2019" d'affiché
    Et je vois le baccalauréat "Enseignements généraux" d'affiché
    Et je vois 4 comme étant le nombre de cours par horaire affiché
    Et je vois les cours sélectionnés:
      | Obligatoire | Cours   | Groupes |
      | non         | ENT202  | 1, 2    |
      | non         | INFTEST | 1       |
      | non         | MATEST  | 1, 2, 3 |
      | non         | PHYEST  | 1, 2    |
    Et je vois 2 possibilités d'horaires
    Et je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours     | Type   |
      | 1                | Lundi    |  9:00 - 12:30 | PHYEST-1  | C      |
      | 1                | Mardi    |  9:00 - 12:30 | MATEST-1  | C      |
      | 1                | Mercredi |  9:00 - 12:00 | PHYEST-1  | TP     |
      | 1                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 1                | Mercredi | 18:00 - 21:30 | ENT202-2  | C      |
      | 1                | Jeudi    |  9:00 - 12:00 | MATEST-1  | TP     |
      | 1                | Jeudi    | 18:00 - 20:00 | ENT202-2  | TP     |
      | 1                | Vendredi |  9:00 - 12:00 | INFTEST-1 | Labo   |
      | 2                | Lundi    |  9:00 - 12:30 | PHYEST-1  | C      |
      | 2                | Lundi    | 13:30 - 17:00 | MATEST-2  | C      |
      | 2                | Mercredi |  9:00 - 12:00 | PHYEST-1  | TP     |
      | 2                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 2                | Mercredi | 18:00 - 21:30 | ENT202-2  | C      |
      | 2                | Jeudi    | 13:30 - 16:30 | MATEST-2  | TP     |
      | 2                | Jeudi    | 18:00 - 20:00 | ENT202-2  | TP     |
      | 2                | Vendredi |  9:00 - 12:00 | INFTEST-1 | Labo   |

  Scénario: Une combinaison d'horaire avec des groupes cours
    Lorsque je sélectionne le trimestre "Enseignements généraux"
    Et je sélectionne les cours ENT202, INFTEST, MATEST et PHYEST
    Et je sélectionne 4 comme étant le nombre de cours par horaire
    Et je décide de vouloir filtrer les groupes des cours possibles
    Lorsque je soumets l'agenda
    Alors je me retrouve sur la page "Choix de groupes"
    Lorsque je dé-sélectionne les groupes:
      | Cours  | Groupe |
      | MATEST | 2      |
    Et je soumets l'agenda
    Alors je me retrouve sur la page "Horaires"
    Et je vois les cours sélectionnés:
      | Obligatoire | Cours   | Groupes |
      | non         | ENT202  | 1, 2    |
      | non         | INFTEST | 1       |
      | non         | MATEST  | 1, 3    |
      | non         | PHYEST  | 1, 2    |
    Et je vois 1 possibilité d'horaire
    Et je vois les horaires:
      | Numéro d'horaire | Jour     | Période       | Cours     | Type   |
      | 1                | Lundi    |  9:00 - 12:30 | PHYEST-1  | C      |
      | 1                | Mardi    |  9:00 - 12:30 | MATEST-1  | C      |
      | 1                | Mercredi |  9:00 - 12:00 | PHYEST-1  | TP     |
      | 1                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
      | 1                | Mercredi | 18:00 - 21:30 | ENT202-2  | C      |
      | 1                | Jeudi    |  9:00 - 12:00 | MATEST-1  | TP     |
      | 1                | Jeudi    | 18:00 - 20:00 | ENT202-2  | TP     |
      | 1                | Vendredi |  9:00 - 12:00 | INFTEST-1 | Labo   |

Scénario: Une combinaison d'horaire avec des cours obligatoires
  Lorsque je sélectionne le trimestre "Génie logiciel"
  Et je sélectionne les cours ENT202, INFTEST, MATEST et PHYEST
  Et je sélectionne ENT202 et INFTEST comme étant obligatoires
  Et je sélectionne 3 comme étant le nombre de cours par horaire
  Lorsque je soumets l'agenda
  Alors je me retrouve sur la page "Horaires"
  Et je vois les cours sélectionnés:
    | Obligatoire | Cours   | Groupes |
    | oui         | ENT202  | 1, 2    |
    | oui         | INFTEST | 1       |
    | non         | MATEST  | 1, 2, 3 |
    | non         | PHYEST  | 1, 2    |
  Et je vois 3 possibilités d'horaires
  Et je vois les horaires:
    | Numéro d'horaire | Jour     | Période       | Cours     | Type   |
    | 1                | Mardi    |  9:00 - 12:30 | MATEST-1  | C      |
    | 1                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
    | 1                | Mercredi | 18:00 - 21:30 | ENT202-2  | C      |
    | 1                | Jeudi    |  9:00 - 12:00 | MATEST-1  | TP     |
    | 1                | Vendredi |  9:00 - 12:00 | INFTEST-1 | Labo   |
    | 2                | Lundi    | 13:30 - 17:00 | MATEST-2  | C      |
    | 2                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
    | 2                | Mercredi | 18:00 - 21:30 | ENT202-2  | C      |
    | 2                | Jeudi    | 13:30 - 16:30 | MATEST-2  | TP     |
    | 2                | Jeudi    | 18:00 - 20:00 | ENT202-2  | TP     |
    | 2                | Vendredi |  9:00 - 12:00 | INFTEST-1 | Labo   |
    | 3                | Lundi    |  9:00 - 12:30 | PHYEST-1  | C      |
    | 3                | Mercredi |  9:00 - 12:00 | PHYEST-1  | TP     |
    | 3                | Mercredi | 13:30 - 17:00 | INFTEST-1 | C      |
    | 3                | Mercredi | 18:00 - 21:30 | ENT202-2  | C      |
    | 3                | Jeudi    | 18:00 - 20:00 | ENT202-2  | TP     |
    | 3                | Vendredi |  9:00 - 12:00 | INFTEST-1 | Labo   |
