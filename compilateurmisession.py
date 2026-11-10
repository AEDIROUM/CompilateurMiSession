import csv
import os


csv_path = "resultsA26.csv"
column_sigle = "question-id-30"
output_dir = "output"

with open(csv_path, newline='', encoding='utf-8-sig') as f:
    reader = csv.DictReader(f)
    reader.fieldnames = [h.strip() for h in reader.fieldnames]

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
