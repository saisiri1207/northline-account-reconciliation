-- Remaining exceptions after the rules, by type and age at quarter end (31 Mar 2026).
.mode column
.headers on
WITH ex AS (
  SELECT b.*, CASE
     WHEN NOT EXISTS (SELECT 1 FROM gl_entries g WHERE g.reference = b.reference) THEN 'Missing GL posting'
     ELSE 'Amount difference' END AS exception_type
  FROM bank_transactions b
  WHERE NOT EXISTS (SELECT 1 FROM gl_entries g WHERE g.reference = b.reference
     AND ABS(g.amount - b.amount) <= 0.05
     AND julianday(g.post_date) - julianday(b.txn_date) BETWEEN 0 AND 3))
SELECT exception_type,
  SUM(julianday('2026-03-31') - julianday(txn_date) <= 30) AS age_0_30,
  SUM(julianday('2026-03-31') - julianday(txn_date) BETWEEN 31 AND 60) AS age_31_60,
  SUM(julianday('2026-03-31') - julianday(txn_date) > 60) AS age_over_60,
  COUNT(*) AS total, ROUND(SUM(amount), 2) AS amount
FROM ex GROUP BY exception_type;
