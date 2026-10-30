# Northline Account Reconciliation (SQL)

Reconcile bank activity against the general ledger, flag duplicates, missing postings and unmatched items, and show how better matching rules cut the exception list.

> Northline Consumer Products is a fictional company. Every row in `data/` is generated sample data, not from any real employer.

## Problem

Northline's cash team matched 1,200 bank transactions (Jan to Mar 2026) to the GL by hand with a strict rule: same reference, same amount, same date. Timing lags and small keying differences landed in the exception list next to real problems, so the real problems were hard to find.

## What I built

| File | Purpose |
|---|---|
| `generate_data.py` | Creates `data/bank_transactions.csv` (1,200 rows) and `data/gl_entries.csv` (1,212 rows) |
| `build_db.py` | Loads the CSVs into SQLite (`northline_recon.db`) |
| `sql/01_before_exact_match.sql` | Baseline exception count with the strict rule |
| `sql/02_duplicates.sql` | GL entries posted more than once |
| `sql/03_missing_postings.sql` | Bank items with no GL posting, and GL entries with no bank item |
| `sql/04_after_rules.sql` | Improved rule: reference match, amount within 0.05, posting within 3 days |
| `sql/05_exception_aging.sql` | Remaining exceptions by type and age at 31 Mar 2026 |
| `run_queries.py` | Runs every query and prints results (no sqlite3 CLI needed) |

## How to run

```
python3 generate_data.py
python3 build_db.py
python3 run_queries.py northline_recon.db
```

Or run any file with `sqlite3 northline_recon.db < sql/04_after_rules.sql`.

## Key results (from the query output)

| Metric | Before | After |
|---|---|---|
| Bank transactions | 1,200 | 1,200 |
| Matched | 1,016 | 1,141 |
| Exceptions | 184 (15.3%) | 59 (4.9%) |

**Exceptions fell 67.9%** (184 to 59) once timing and rounding were handled by rule instead of by hand.

What the queries flagged for follow up:

* **27 duplicate GL postings** overstating cash by **$310,916**
* **40 bank items missing from the GL** totaling **$504,671**
* **25 GL entries with no bank activity** totaling **$70,213** (manual entries to support)
* Of the 59 open exceptions, **15 are over 60 days old** and go first on the review list

## Conclusion

Rule based matching moves the routine noise out of the queue so the team spends its time on duplicates and missing postings, which carry the real balance sheet risk. The same approach supports a faster month end close and a cleaner audit trail.

## Stack

SQL (SQLite), Python standard library.
