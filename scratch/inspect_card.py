import re
import sys
sys.stdout.reconfigure(encoding='utf-8')

with open('scratch_bestseller.html', 'r', encoding='utf-8') as f:
    html = f.read()

# Find product card section
idx = html.find('card-wrapper')
if idx != -1:
    snippet = html[idx:idx+2500]
    print("CARD SNIPPET:")
    print(snippet)

# Search for price formatting
prices = re.findall(r'price__sale.*?</span>', html, re.DOTALL)
print("\nPRICE SNIPPETS FOUND:", len(prices))
if prices:
    print(prices[0][:500])

