"""Generate sample Northline bank and GL transactions (fictional data)."""
import csv, random, datetime as dt
random.seed(42)
start = dt.date(2026, 1, 1)
bank, gl = [], []
gid = 1
for i in range(1, 1201):
    d = start + dt.timedelta(days=random.randint(0, 89))
    amt = round(random.uniform(150, 25000), 2)
    ref = f"NL{i:05d}"
    bank.append([f"B{i:05d}", d.isoformat(), ref, amt])
    r = random.random()
    if r < 0.04:      # missing GL posting
        continue
    gd = d
    if r < 0.12:      # timing lag 1 to 3 days
        gd = d + dt.timedelta(days=random.randint(1, 3))
    gamt = amt
    if 0.12 <= r < 0.15:  # rounding or keying difference
        gamt = round(amt + random.choice([-0.01, 0.01, -9.0, 10.0]), 2)
    gl.append([f"G{gid:05d}", gd.isoformat(), ref, gamt, random.choice(["1010", "1020"])]); gid += 1
    if 0.15 <= r < 0.18:  # duplicate posting
        gl.append([f"G{gid:05d}", gd.isoformat(), ref, gamt, "1010"]); gid += 1
for j in range(25):  # GL entries with no bank activity
    d = start + dt.timedelta(days=random.randint(0, 89))
    gl.append([f"G{gid:05d}", d.isoformat(), f"MAN{j:03d}", round(random.uniform(100, 5000), 2), "1010"]); gid += 1
with open("data/bank_transactions.csv", "w", newline="") as f:
    w = csv.writer(f); w.writerow(["bank_id", "txn_date", "reference", "amount"]); w.writerows(bank)
with open("data/gl_entries.csv", "w", newline="") as f:
    w = csv.writer(f); w.writerow(["gl_id", "post_date", "reference", "amount", "account"]); w.writerows(gl)
print(len(bank), "bank rows,", len(gl), "GL rows")
