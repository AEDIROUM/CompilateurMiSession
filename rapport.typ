// #let sigle = "IFT1015B"
// #let sigle = "IFT1065-A"
#let sigle = sys.inputs.at("sigle")

#set page(
  paper: "us-letter",
  margin: (x: 1.6in, y: 2in),
)

#set text(font: "Libertinus Serif", lang: "fr", region: "CA")
#set par(justify: true)

#show heading: it => block(
  above: 2em,
  below: 1em,
  text(features: ("smcp", "onum"), weight: "regular")[
    #lower[#it.body]
  ]
)

#let display-date(data) = {
  // Le format de NextCloud possède l'offset UTC : 2026-11-03T10:21:27-05:00)
  let m = data.match(regex("(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})"))

  if m == none [
    data
  ] else {
    let caps = m.at("captures")
    let year = int(caps.at(0))
    let month = int(caps.at(1))
    let day = int(caps.at(2))
    let hour = int(caps.at(3))
    let minute = int(caps.at(4))
    let second = int(caps.at(5))

    let date = datetime(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
    )

    [
      #date.display("[year]-[month]-[day]")
    ]
  }
}

#let columns = (
  "heure": 3,
  "évaluateur": 4,
  "sigle": 5,
  "cours": (
    "fermées": (
      "La matière enseignée dans le cours correspond à celle prévue dans la description annoncée": 6,
      "La charge de travail du cours correspond à celle prévue par le nombre de crédits": 7,
      "La matière est adéquatement répartie durant les 15 semaines du cours": 8,
      "Les ressources fournies (sur StudiUM, sur un site web, ou sur d’autres supports) sont satisfaisantes": 9,
      "Les travaux pratiques et laboratoires mettent en œuvre la matière présentée dans les cours théoriques": 10,
    ),
    "ouverte": 11,
  ),
  "évaluations": (
    "fermées": (
      "Les évaluations reflètent bien la matière présentée en classe": 12,
      "Les évaluations sont claires": 13,
      "Le temps alloué aux évaluations est suffisant pour pouvoir les compléter": 14,
      "La pondération des travaux, des examens, et des autres évaluations est juste": 15,
      "Les dates, la pondération et la matière des évaluations correspondent aux informations du plan de cours": 16,
    ),
    "ouverte": 17,
  ),
  "enseignant1": (
    "nom": 18,
    "fermées": (
      "La personne enseignante maîtrise bien la matière du cours": 19,
      "La personne enseignante explique bien la matière du cours": 21,
      "La personne enseignante communique bien en français": 22,
      "La personne enseignante a un débit et un ton de voix adéquats": 23,
      "La personne enseignante est disponible pour répondre aux questions": 24,
      "La personne enseignante est ponctuelle et donne des pauses": 25,
    ),
    "ouverte": 26,
  ),
  "enseignant2": (
    "existe": 27,
    "nom": 28,
    "fermées": (
      "La personne enseignante maîtrise bien la matière du cours": 29,
      "La personne enseignante explique bien la matière du cours": 30,
      "La personne enseignante communique bien en français": 31,
      "La personne enseignante a un débit et un ton de voix adéquats": 32,
      "La personne enseignante est disponible pour répondre aux questions": 33,
      "La personne enseignante est ponctuelle et donne des pauses": 34,
    ),
    "ouverte": 35,
  ),
)

#let all-results = csv("resultsA26.csv")
#let results = all-results.filter(row => row.at(columns.at("sigle")) == sigle)


#{
  if results.len() == 0 {
    panic("Aucun cours correspondant au sigle " + str(sigle))
  } else if results.len() > 1 {
    panic("Plusieurs cours correspondent au sigle '" + str(sigle) + "'. "
      + "Il est possible que les cours n'aient pas de blocs.\n"
    )
  }
}

#let results = results.at(0)

#let show-fermee-result(value) = {
  let color = {
    if value == "Majorité pour" {
      green.darken(15%)
    } else if value == "Mitigé" {
      yellow.darken(5%)
    } else if value == "Majorité contre" {
      red.darken(10%)
    } else {
      gray
    }
  }
  value
  h(.3em)
  box(baseline: 10%, circle(radius: .33em, fill: color))
}

#let show-fermees(key) = table(
  columns: (2.2fr, 1fr),
  align: (left + horizon, right + horizon),
  stroke: (x: 0pt, y: .33pt),
  inset: (x: 0em, y: .75em),
  ..{
    for (question, id) in columns.at(key).at("fermées") {
      (
        question,
        show-fermee-result(results.at(id)),
      )
    }
  },
)

#let show-ouverte(key) = [
  #block(sticky: true)[_Commentaires libres recueillis des personnes étudiantes:_]

  #block(stroke: .33pt, inset: 1em, {
    if results.at(columns.at(key).at("ouverte")).trim() != "" {
      results.at(columns.at(key).at("ouverte"))
    } else {
      [_(Sans objet.)_]
    }
  })
]

#grid(
  columns: (3.5cm, 1fr),
  column-gutter: 2em,
  align: horizon,
  image("aediroum.svg", width: 100%),
  [
    = Rapport d’évaluation de cours

    #table(
      columns: 2,
      stroke: none,
      inset: 0pt,
      row-gutter: .66em,
      column-gutter: 1em,
      [_Sigle du cours_], [#results.at(columns.at("sigle"))],
      [_Date du sondage_], [#display-date(results.at(columns.at("heure")))],
      [_Personne évaluatrice_], [#results.at(columns.at("évaluateur"))],
    )
  ]
)

#v(2em)

Ce rapport contient les résultats d’un sondage réalisé par l’AÉDIROUM auprès des personnes présentes dans la classe.
Son contenu n’est partagé qu’avec les personnes représentantes de l’association et la personne enseignante concernée.

#emph[
  Méthodologie:
  Avec l’accord de la personne enseignante et en l’absence de celle-ci, la personne évaluatrice s’est présentée en avant et a posé les questions suivantes aux personnes étudiantes.
  À main levée, si une majorité claire de la salle était pour ou contre une certaine affirmation, la mention «Majorité pour» ou «Majorité contre» apparaît.
  Sinon, la mention «Mitigé» apparaît.
  Les commentaires des personnes étudiantes ont été recueillis à la fin de chaque section, puis résumés pour en faire ressortir les aspects les plus importants.
]

== Concernant la matière

#show-fermees("cours")

#show-ouverte("cours")

== Concernant les évaluations

#show-fermees("évaluations")

#show-ouverte("évaluations")

== Concernant *#results.at(columns.at("enseignant1").at("nom"))*

#show-fermees("enseignant1")

#show-ouverte("enseignant1")

#{
  if (results.at(columns.at("enseignant2").at("existe")) == "Oui") [
    == Concernant *#results.at(columns.at("enseignant2").at("nom"))*

    #show-fermees("enseignant2")

    #show-ouverte("enseignant2")
  ]
}
