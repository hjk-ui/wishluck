import json
import re

with open('scratch_products.json', 'r', encoding='utf-8-sig') as f:
    raw = json.load(f)

products_out = []

age_categories = [
    "0-1 Years", "1-3 Years", "3-4 Years", "4-5 Years", "5-6 Years", "6+ Years"
]

default_ratings = [4.8, 4.9, 5.0, 4.7, 4.9, 4.8, 5.0]
default_reviews = [128, 254, 89, 412, 175, 320, 94]

for i, p in enumerate(raw.get('products', [])):
    title = p.get('title', '').strip()
    handle = p.get('handle', '')
    body_html = p.get('body_html', '')
    # extract bullets
    bullets = re.findall(r'<li[^>]*>(.*?)</li>', body_html)
    clean_bullets = [re.sub(r'<[^>]+>', '', b).strip() for b in bullets if b.strip()]
    if not clean_bullets:
        clean_bullets = [
            "Teaches cause-and-effect thinking and boosts cognitive skills.",
            "Built with 100% child-safe, non-toxic premium materials.",
            "Develops fine motor skills, hand-eye coordination & curiosity."
        ]

    # variants
    variants = []
    for v in p.get('variants', []):
        variants.append({
            'id': str(v.get('id', '')),
            'title': v.get('title', 'Default'),
            'price': float(v.get('price', 0) or 0),
            'compare_at_price': float(v.get('compare_at_price', 0) or v.get('price', 0) or 0),
            'sku': v.get('sku', ''),
            'available': v.get('available', True)
        })

    # images
    images = [img.get('src', '') for img in p.get('images', []) if img.get('src')]
    if not images and p.get('image'):
        images = [p.get('image', {}).get('src', '')]

    # assign age category and badge
    age = age_categories[i % len(age_categories)]
    if "baby" in title.lower() or "pillow" in title.lower() or "guard" in title.lower():
        age = "0-1 Years"
    elif "sound book" in title.lower() or "talking" in title.lower() or "phonics" in title.lower():
        age = "1-3 Years"
    elif "drum" in title.lower() or "monkey" in title.lower() or "torch" in title.lower() or "shinchan" in title.lower():
        age = "3-4 Years"
    elif "math" in title.lower() or "copybook" in title.lower() or "learning" in title.lower():
        age = "4-5 Years"
    elif "bundle" in title.lower() or "kit" in title.lower() or "starter" in title.lower():
        age = "Bundles"

    badge = "BESTSELLER"
    v0 = variants[0] if variants else {'price': 499, 'compare_at_price': 999}
    disc_pct = int(round((1 - (v0['price'] / v0['compare_at_price'])) * 100)) if v0['compare_at_price'] > v0['price'] else 0
    if disc_pct >= 50:
        badge = f"{disc_pct}% OFF"
    elif i % 3 == 0:
        badge = "HOT SELLER"
    elif i % 5 == 0:
        badge = "OFF ON FIRST ORDER"

    products_out.append({
        'id': str(p.get('id', i+1)),
        'title': title,
        'handle': handle,
        'age_category': age,
        'badge': badge,
        'rating': default_ratings[i % len(default_ratings)],
        'reviews_count': default_reviews[i % len(default_reviews)],
        'variants': variants,
        'images': images,
        'bullets': clean_bullets[:4]
    })

import os
os.makedirs('assets', exist_ok=True)
with open('assets/products.json', 'w', encoding='utf-8') as f:
    json.dump({'products': products_out}, f, indent=2, ensure_ascii=False)

print(f"Successfully wrote {len(products_out)} products to assets/products.json")
