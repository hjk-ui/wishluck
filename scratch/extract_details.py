import re
import sys
sys.stdout.reconfigure(encoding='utf-8')

with open('scratch_bestseller.html', 'r', encoding='utf-8') as f:
    html = f.read()

# 1. Look for badges (Sale, Bestseller, %, etc.)
badges = re.findall(r'<span[^>]*class="[^"]*badge[^"]*"[^>]*>(.*?)</span>', html, re.IGNORECASE)
print("Badges:", list(set([re.sub(r'<[^>]+>', '', b).strip() for b in badges])))

# 2. Look for quick buy / add to cart buttons in grid
buttons = re.findall(r'<button[^>]*>(.*?)</button>', html, re.DOTALL | re.IGNORECASE)
print("Buttons:", list(set([re.sub(r'<[^>]+>', '', b).strip() for b in buttons if len(b) < 100])))

# 3. Look for logo image
logos = re.findall(r'<img[^>]+(?:class="[^"]*header__heading-logo[^"]*"|alt="WishLuck")[^>]*src="([^"]+)"', html)
if not logos:
    logos = re.findall(r'src="([^"]+WISH_LUCK[^"]+)"', html)
print("Logos:", logos)

# 4. Look for collection banner image
banners = re.findall(r'src="([^"]+Best_Sellers[^"]+)"', html)
print("Best Seller Banner:", banners)
if not banners:
    og_img = re.findall(r'<meta property="og:image" content="([^"]+)"', html)
    print("OG Image:", og_img)

# 5. Look for ratings / review stars
reviews = re.findall(r'rating|star|review', html, re.IGNORECASE)
print("Review keywords count:", len(reviews))

# 6. Look for Gokwik button or buy now
gokwik = re.findall(r'gokwik[^\n"]*', html, re.IGNORECASE)
print("Gokwik instances:", len(gokwik))

# 7. Check bottom bar / footer / sticky bar
footer = re.findall(r'<footer[^>]*>(.*?)</footer>', html, re.DOTALL | re.IGNORECASE)
print("Footer found:", len(footer))
if footer:
    footer_text = re.sub(r'<[^>]+>', ' ', footer[0])
    footer_text = re.sub(r'\s+', ' ', footer_text).strip()
    print("Footer text sample:", footer_text[:400])

