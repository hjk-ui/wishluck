import urllib.request
import json
import re

# 1. Fetch products
with open('scratch_products.json', 'r', encoding='utf-8-sig') as f:
    data = json.load(f)

products = data.get('products', [])
print(f"Total products in best-seller: {len(products)}")
for i, p in enumerate(products):
    variants = p.get('variants', [])
    v = variants[0] if variants else {}
    img = p['images'][0]['src'] if p.get('images') else ''
    print(f"{i+1}. {p.get('title')}")
    print(f"   Price: Rs {v.get('price')} (Compare: Rs {v.get('compare_at_price')})")
    print(f"   Image: {img}")
    print(f"   Variants count: {len(variants)}")
    print(f"   Images count: {len(p.get('images', []))}")

# 2. Fetch HTML of collection page and home page
req = urllib.request.Request(
    'https://www.wishluck.in/collections/best-seller',
    headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'}
)
try:
    with urllib.request.urlopen(req) as resp:
        html = resp.read().decode('utf-8', errors='ignore')
    with open('scratch_bestseller.html', 'w', encoding='utf-8') as f:
        f.write(html)
    print("Saved scratch_bestseller.html, length:", len(html))

    # Look for announcement bar
    announcements = re.findall(r'announcement[^>]*>(.*?)<', html, re.IGNORECASE)
    print("Announcements found:", announcements[:5])
    
    # Look for banners / hero images
    images = re.findall(r'<img[^>]+src="([^">]+)"', html)
    print("Sample images in HTML:", images[:10])

except Exception as e:
    print("Error fetching HTML:", e)
