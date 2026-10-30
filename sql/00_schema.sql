CREATE TABLE bank_transactions (bank_id TEXT PRIMARY KEY, txn_date DATE, reference TEXT, amount REAL);
CREATE TABLE gl_entries (gl_id TEXT PRIMARY KEY, post_date DATE, reference TEXT, amount REAL, account TEXT);
