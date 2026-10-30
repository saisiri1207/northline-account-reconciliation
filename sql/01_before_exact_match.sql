-- BEFORE: strict match on reference, amount and same date. Everything else is an exception.
.mode column
.headers on
WITH matched AS (
  SELECT DISTINCT b.bank_id FROM bank_transactions b
  JOIN gl_entries g ON g.reference = b.reference AND g.amount = b.amount AND g.post_date = b.txn_date)
SELECT (SELECT COUNT(*) FROM bank_transactions) AS bank_rows,
       COUNT(*) AS matched,
       (SELECT COUNT(*) FROM bank_transactions) - COUNT(*) AS exceptions,
       ROUND(100.0 * ((SELECT COUNT(*) FROM bank_transactions) - COUNT(*)) / (SELECT COUNT(*) FROM bank_transactions), 1) AS exception_pct
FROM matched;
