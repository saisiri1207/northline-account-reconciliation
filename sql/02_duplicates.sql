-- Duplicate GL postings: same reference, amount and date posted more than once.
.mode column
.headers on
SELECT reference, post_date, amount, COUNT(*) AS times_posted, ROUND(amount * (COUNT(*) - 1), 2) AS overstated
FROM gl_entries GROUP BY reference, post_date, amount HAVING COUNT(*) > 1 ORDER BY overstated DESC;
SELECT COUNT(*) AS duplicate_groups, ROUND(SUM(overstated), 2) AS total_overstated FROM (
  SELECT amount * (COUNT(*) - 1) AS overstated FROM gl_entries GROUP BY reference, post_date, amount HAVING COUNT(*) > 1);
