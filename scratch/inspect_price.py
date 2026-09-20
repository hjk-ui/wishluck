import re
import sys
sys.stdout.reconfigure(encoding='utf-8')

with open('scratch_bestseller.html', 'r', encoding='utf-8') as f:
    html = f.read()

idx = html.find('price-item--compare')
if idx != -1:
    print(html[idx-100:idx+600])
