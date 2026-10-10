"""Generate deterministic synthetic ITSM / asset data (Bronze-layer raw seeds).

All data is synthetic. Intentional data-quality issues are injected so the
Silver layer has real work to do: duplicate incident versions, inconsistent
casing / whitespace, mixed boolean encodings and open records without
resolution timestamps.
"""
import csv, os, random
from datetime import datetime, timedelta, date

random.seed(42)
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "seeds")
os.makedirs(OUT, exist_ok=True)
FMT = "%Y-%m-%d %H:%M:%S"


def write(name, header, rows):
    with open(os.path.join(OUT, f"{name}.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(header)
        w.writerows(rows)
    print(f"{name}: {len(rows)} rows")


def noisy(value, p=0.15):
    r = random.random()
    if r < p / 3:
        return value.upper()
    if r < 2 * p / 3:
        return value.lower()
    if r < p:
        return f" {value} "
    return value


departments = ["IT Services", "Finance", "HR", "Telecom", "Sales", "Operations",
               "Legal", "Marketing", "Procurement", "Engineering"]
write("raw_departments", ["dept_id", "dept_name", "cost_center"],
      [[i + 1, noisy(d, 0.1), f"CC{1000 + i * 10}"] for i, d in enumerate(departments)])

locs = [("Paris", "FR", "EMEA"), ("Lyon", "FR", "EMEA"), ("Madrid", "ES", "EMEA"),
        ("Berlin", "DE", "EMEA"), ("London", "GB", "EMEA"), ("Milan", "IT", "EMEA"),
        ("Warsaw", "PL", "EMEA"), ("Dublin", "IE", "EMEA"), ("Lisbon", "PT", "EMEA"),
        ("Brussels", "BE", "EMEA"), ("Amsterdam", "NL", "EMEA"), ("Pune", "IN", "APAC"),
        ("Chandigarh", "IN", "APAC"), ("Casablanca", "MA", "EMEA"), ("Tunis", "TN", "EMEA")]
write("raw_locations", ["location_id", "city", "country", "region"],
      [[i + 1, noisy(c, 0.1), cc.lower() if random.random() < 0.2 else cc, r]
       for i, (c, cc, r) in enumerate(locs)])

groups = ["Service Desk", "Network Ops", "Infrastructure", "Applications", "Security Ops",
          "Database Admin", "Cloud Platform", "Field Services", "Telecom Support",
          "ERP Support", "Data Platform", "Change Advisory Board"]
gtypes = ["support", "support", "support", "support", "security", "support",
          "support", "field", "support", "support", "support", "governance"]
write("raw_groups", ["group_id", "group_name", "group_type", "manager_id"],
      [[i + 1, g, noisy(gtypes[i].capitalize(), 0.2), random.randint(1, 200)]
       for i, g in enumerate(groups)])

write("raw_sla_definitions", ["sla_id", "priority", "response_hours", "resolution_hours"],
      [[1, "1 - Critical", 1, 4], [2, "2 - High", 2, 8], [3, "3 - Moderate", 8, 24], [4, "4 - Low", 24, 72]])

first = ["Anna", "Luc", "Maria", "Thomas", "Sofia", "Karim", "Elena", "Paul", "Priya", "Marc",
         "Julia", "Omar", "Nina", "Hugo", "Leila", "Ravi", "Clara", "Yann", "Sara", "Ivan"]
last = ["Martin", "Bernard", "Dubois", "Garcia", "Rossi", "Schmidt", "Nowak", "Singh",
        "Moreau", "Lopez", "Costa", "Khan", "Petit", "Fabre", "Meyer", "Haddad"]
N_USERS = 200
users = []
for uid in range(1, N_USERS + 1):
    fn, ln = random.choice(first), random.choice(last)
    email = f"{fn}.{ln}{uid}@example.com".lower()
    if random.random() < .1:
        email = email.upper()
    users.append([uid, fn, ln, email, random.randint(1, 10), random.randint(1, 15),
                  random.randint(1, N_USERS) if uid > 10 else "",
                  random.choice(["Analyst", "Engineer", "Manager", "Consultant", "Director", "Technician"]),
                  random.choices(["true", "TRUE", "Y", "1", "false", "N"], [40, 20, 15, 10, 10, 5])[0],
                  (datetime(2019, 1, 1) + timedelta(days=random.randint(0, 1800))).strftime(FMT)])
write("raw_users", ["user_id", "first_name", "last_name", "email", "dept_id", "location_id",
                    "manager_id", "role_title", "is_active", "created_at"], users)

N_CI = 150
write("raw_cmdb_ci", ["ci_id", "ci_name", "ci_class", "environment", "owner_group_id", "criticality"],
      [[i, f"ci-{i:04d}", noisy(random.choice(["Server", "Database", "Application", "Network", "Storage"]), .2),
        noisy(random.choice(["prod", "prod", "test", "dev"]), .2), random.randint(1, 12), random.randint(1, 4)]
       for i in range(1, N_CI + 1)])

assets = []
for aid in range(1, 401):
    status = random.choices(["In use", "In stock", "Retired", "Repair"], [65, 15, 12, 8])[0]
    assets.append([aid, f"AT-{aid:05d}", noisy(random.choice(["Laptop", "Desktop", "Monitor", "Phone", "Tablet"]), .2),
                   random.choice(["Dell 7440", "HP 840", "Lenovo T14", "Apple MBP14", "Samsung S24", "iPad 10"]),
                   noisy(status, .2), random.randint(1, N_USERS) if status == "In use" else "",
                   random.randint(1, 15), (date(2020, 1, 1) + timedelta(days=random.randint(0, 2000))).isoformat(),
                   f"{random.uniform(180, 2400):.2f}"])
write("raw_assets", ["asset_id", "asset_tag", "asset_type", "model", "status", "assigned_user_id",
                     "location_id", "purchase_date", "cost_eur"], assets)

START, END, CUTOFF = datetime(2023, 1, 1), datetime(2025, 6, 30), datetime(2025, 7, 1)
PRIO = ["1 - Critical", "2 - High", "3 - Moderate", "4 - Low"]
MEAN_H = [3, 8, 20, 55]
CATS = ["Hardware", "Software", "Network", "Access", "Email", "Database", "Security"]
incidents, dup_rows = [], []
for n in range(1, 3001):
    opened = START + timedelta(seconds=random.randint(0, int((END - START).total_seconds())))
    opened = opened.replace(hour=random.randint(7, 18), minute=random.randint(0, 59), second=random.randint(0, 59))
    p = random.choices([0, 1, 2, 3], [5, 15, 50, 30])[0]
    recent = opened > datetime(2025, 6, 10)
    r = random.random()
    resolved = closed = None
    if r < (0.5 if recent else 0.03):
        state = random.choice(["New", "In Progress", "On Hold"])
        updated = opened + timedelta(hours=random.randint(1, 48))
    elif r < (0.52 if recent else 0.05):
        state = "Cancelled"
        updated = opened + timedelta(hours=random.randint(1, 24))
    else:
        resolved = opened + timedelta(hours=MEAN_H[p] * random.lognormvariate(0, 0.6))
        resolved = min(resolved, CUTOFF - timedelta(hours=2))
        if random.random() < .8:
            state, closed = "Closed", min(resolved + timedelta(days=random.randint(1, 5)), CUTOFF)
            updated = closed
        else:
            state, updated = "Resolved", resolved
    updated = min(updated, CUTOFF)
    iid = f"INC{1000000 + n}"
    row = [iid, opened.strftime(FMT), resolved.strftime(FMT) if resolved else "",
           closed.strftime(FMT) if closed else "", random.randint(1, N_USERS), random.randint(1, 12),
           noisy(PRIO[p], .25), state, noisy(random.choice(CATS), .2), random.randint(1, N_CI),
           f"Issue {n}: {random.choice(CATS).lower()} problem",
           random.choices([0, 1, 2], [92, 6, 2])[0], updated.strftime(FMT)]
    incidents.append(row)
    if random.random() < 0.027:
        old = list(row)
        old[2], old[3], old[7] = "", "", "In Progress"
        old[12] = (opened + timedelta(hours=1)).strftime(FMT)
        dup_rows.append(old)
incidents += dup_rows
random.shuffle(incidents)
write("raw_incidents", ["incident_id", "opened_at", "resolved_at", "closed_at", "caller_id",
                        "assignment_group_id", "priority", "state", "category", "ci_id",
                        "short_description", "reopen_count", "updated_at"], incidents)

ITEMS = ["New laptop", "VPN access", "Software install", "Account creation", "Mailbox increase",
         "Mobile phone", "Badge access"]
requests = []
for n in range(1, 1501):
    opened = START + timedelta(seconds=random.randint(0, int((END - START).total_seconds())))
    state = random.choices(["Closed", "Fulfilled", "In Progress", "Cancelled"], [60, 25, 10, 5])[0]
    fulfilled = None
    if state in ("Closed", "Fulfilled"):
        fulfilled = min(opened + timedelta(hours=40 * random.lognormvariate(0, .7)), CUTOFF - timedelta(hours=1))
    updated = fulfilled or opened + timedelta(hours=random.randint(1, 30))
    requests.append([f"REQ{2000000 + n}", opened.strftime(FMT), fulfilled.strftime(FMT) if fulfilled else "",
                     random.randint(1, N_USERS), random.randint(1, 12), noisy(random.choice(ITEMS), .15), state,
                     noisy(random.choice(PRIO), .2), f"{random.uniform(0, 1800):.2f}", updated.strftime(FMT)])
write("raw_requests", ["request_id", "opened_at", "fulfilled_at", "requested_for_id", "assignment_group_id",
                       "catalog_item", "state", "priority", "cost_eur", "updated_at"], requests)

changes = []
for n in range(1, 601):
    opened = START + timedelta(seconds=random.randint(0, int((END - START).total_seconds())))
    ctype = random.choices(["Standard", "Normal", "Emergency"], [60, 30, 10])[0]
    state = random.choices(["Implemented", "Closed", "Scheduled", "Cancelled"], [45, 40, 10, 5])[0]
    impl, flag = None, ""
    if state in ("Implemented", "Closed"):
        impl = min(opened + timedelta(days=random.randint(1, 20), hours=random.randint(0, 20)), CUTOFF - timedelta(hours=1))
        flag = random.choices(["true", "Y", "TRUE", "false", "N"], [40, 30, 20, 6, 4])[0]
    updated = impl or opened + timedelta(hours=random.randint(1, 72))
    changes.append([f"CHG{3000000 + n}", opened.strftime(FMT), impl.strftime(FMT) if impl else "",
                    noisy(ctype, .2), noisy(random.choice(["Low", "Moderate", "High"]), .2), state,
                    random.randint(1, N_CI), random.randint(1, 12), flag, updated.strftime(FMT)])
write("raw_changes", ["change_id", "opened_at", "implemented_at", "change_type", "risk", "state",
                      "ci_id", "assignment_group_id", "success_flag", "updated_at"], changes)

d, cal = date(2022, 1, 1), []
while d <= date(2025, 12, 31):
    cal.append([d.isoformat()])
    d += timedelta(days=1)
write("raw_calendar", ["date_day"], cal)
