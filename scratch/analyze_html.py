import re

with open('scratch_bestseller.html', 'r', encoding='utf-8') as f:
    html = f.read()

# 1. Announcement bar
announcement_blocks = re.findall(r'<div[^>]*class="[^"]*announcement[^"]*"[^>]*>(.*?)</div>', html, re.DOTALL | re.IGNORECASE)
print("=== ANNOUNCEMENT BAR BLOCKS ===")
for b in announcement_blocks:
    clean = re.sub(r'<[^>]+>', ' ', b).strip()
    clean = re.sub(r'\s+', ' ', clean)
    if clean:
        print("->", clean)

# 2. Header and navigation links
print("\n=== HEADER / MENU LINKS ===")
nav_items = re.findall(r'<a[^>]+href="([^"]+)"[^>]*>(.*?)</a>', html, re.DOTALL)
filtered_nav = []
for href, text in nav_items:
    clean_text = re.sub(r'<[^>]+>', '', text).strip()
    if clean_text and len(clean_text) < 40 and not clean_text.startswith('{'):
        filtered_nav.append((clean_text, href))
for text, href in filtered_nav[:25]:
    print(f"[{text}] -> {href}")

# 3. Collection title and description
print("\n=== COLLECTION HEADER ===")
col_matches = re.findall(r'<h1[^>]*>(.*?)</h1>', html, re.DOTALL)
for h1 in col_matches:
    print("H1:", re.sub(r'<[^>]+>', '', h1).strip())

# 4. Filters & sorting
print("\n=== FILTERS / SORT OPTIONS ===")
options = re.findall(r'<option[^>]*value="([^"]*)"[^>]*>(.*?)</option>', html, re.DOTALL)
for val, text in options:
    print(f"Sort/Filter Option: {text.strip()} (value: {val})")

# 5. Product card structure
print("\n=== PRODUCT CARD SAMPLE ===")
card_match = re.search(r'<div[^>]*class="[^"]*card-wrapper[^"]*"[^>]*>(.*?)</div>\s*</div>\s*</div>', html, re.DOTALL)
if card_match:
    print(card_match.group(0)[:1000])

# 6. Quinn stories / video reels
print("\n=== QUINN STORIES / REELS ===")
quinn_stories = re.findall(r'hero_text["\']\s*:\s*["\']([^"\']+)["\']', html)
print("Quinn hero texts:", quinn_stories)

quinn_data = re.findall(r'QSVL\.settings\s*=\s*(\{.*?\});', html)
if quinn_data:
    print("Quinn settings:", quinn_data[0][:300])

