"""Load the CSVs into northline_recon.db (SQLite, standard library only)."""
import csv, sqlite3, os
if os.path.exists("northline_recon.db"): os.remove("northline_recon.db")
con = sqlite3.connect("northline_recon.db")
con.executescript(open("sql/00_schema.sql").read())
for t, fn in [("bank_transactions", "data/bank_transactions.csv"), ("gl_entries", "data/gl_entries.csv")]:
    rows = list(csv.reader(open(fn)))
    con.executemany(f"INSERT INTO {t} VALUES ({','.join('?'*len(rows[0]))})", rows[1:])
con.commit(); print("Loaded northline_recon.db")
