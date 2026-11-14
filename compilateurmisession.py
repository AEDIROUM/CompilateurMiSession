import csv
import os


csv_path = "resultsA26.csv"  # TODO: mettre en sys.argsv
column_sigle = "question-id-30"  # TODO: voir si ça s'améliore sur NextCloud
output_dir = "output"  # TODO: mettre en sys.argsv


with open(csv_path, newline='', encoding='utf-8-sig') as f:
    reader = csv.DictReader(f)
    # Les clés des questions sont la valeur de la première entrée.
    # C'est une restriction de NextCloud.
    keys = reader.__next__().values()
    reader.fieldnames = [h.strip() for h in reader.__next__().values()]

    if not os.path.isdir(output_dir):
        os.makedirs(output_dir)

    for row in reader:
        sigle = row[column_sigle]
        result = os.system(
            f"typst compile --input sigle=\"{sigle}\" rapport.typ "
            f'"output/{sigle}.pdf"'
        )
        if result != 0:
            exit(result)
