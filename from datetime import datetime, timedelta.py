from datetime import datetime, timedelta

# Helper to generate valid national IDs
def generate_valid_national_ids(count):
    ids = []
    base = 1000000000
    i = 0
    while len(ids) < count:
        id_str = str(base + i)
        digits = [int(d) for d in id_str[:9]]
        b = sum([(10 - j) * digits[j] for j in range(9)]) % 11
        ctrl = b if b < 2 else 11 - b
        full_id = id_str[:9] + str(ctrl)
        if full_id not in ids:
            ids.append(full_id)
        i += 1
    return ids

# Generate 10 valid IDs
valid_ids = generate_valid_national_ids(40)
print(valid_ids)