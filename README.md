# Compilateur de MiSession

Compilateur de Mi-Session (CMS) est un script qui transforme chaque entrée
du CSV du formulaire d'évaluation de mi-session en un PDF formaté.

## Guide d'utilisation

### Logiciels à installer

Voici la liste des logiciels requis pour l'exécution du script :

* [Typst >= 0.15](https://typst.app/)
* [Python >= 3.13](https://www.python.org/)

Il est possible que le script fonctionne avec des versions antérieures. Elles n'ont pas été testées.

### Exécution du script

Dans `compilateurmisession.py`, changez les valeurs des variables suivantes :

* `column_sigle` doit être l'id de la question associée au sigle du cours. (Cette valeur se retrouve sur la deuxième ligne du CSV)
* `csv_path` doit être le nom du fichier CSV contenant les résultats de l'évaluation de mi-session.

Puis, exécuter la commande suivante.

```sh
python compilateurmisession.py
```

Un répertoire `output` devrait contenir toutes les évaluations sous format PDF.

## À noter

Toute modification à la structure du CSV engendre une modification à
`rapport.typ` ou à `compilateurmisession.py`.

Dans `rapport.typ`, il faut changer le tableau `columns` si les questions sont
modifiées (énoncé, ordre, etc.).
