-- AFTER: match on reference, amount within 0.05, posting date within 3 days. Duplicates counted once.
.mode column
.headers on
WITH matched AS (
  SELECT DISTINCT b.bank_id FROM bank_transactions b
  JOIN gl_entries g ON g.reference = b.reference
   AND ABS(g.amount - b.amount) <= 0.05
   AND julianday(g.post_date) - julianday(b.txn_date) BETWEEN 0 AND 3)
SELECT (SELECT COUNT(*) FROM bank_transactions) AS bank_rows,
       COUNT(*) AS matched,
       (SELECT COUNT(*) FROM bank_transactions) - COUNT(*) AS exceptions,
       ROUND(100.0 * ((SELECT COUNT(*) FROM bank_transactions) - COUNT(*)) / (SELECT COUNT(*) FROM bank_transactions), 1) AS exception_pct
FROM matched;
