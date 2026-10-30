-- Bank activity with no GL posting under the same reference.
.mode column
.headers on
SELECT COUNT(*) AS missing_in_gl, ROUND(SUM(b.amount), 2) AS amount
FROM bank_transactions b LEFT JOIN gl_entries g ON g.reference = b.reference WHERE g.gl_id IS NULL;
-- GL entries with no bank activity (manual entries to review).
SELECT COUNT(*) AS gl_without_bank, ROUND(SUM(g.amount), 2) AS amount
FROM gl_entries g LEFT JOIN bank_transactions b ON b.reference = g.reference WHERE b.bank_id IS NULL;
