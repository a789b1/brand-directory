"""Read the accessory catalog and its model-year relationships from SQLite."""
from pathlib import Path
import sqlite3

db = sqlite3.connect(':memory:')
db.executescript(Path(__file__).with_name('catalog.sql').read_text(encoding='utf-8'))
if db.execute('PRAGMA foreign_key_check').fetchall():
    raise ValueError('Catalog contains a broken reference')
invalid_years = db.execute("""
    SELECT f.part, f.model FROM fitment f JOIN model m ON m.id=f.model
    WHERE f.first_year < m.first_year OR f.last_year > m.last_year
""").fetchall()
if invalid_years:
    raise ValueError(f'Fitment exceeds the model coverage: {invalid_years}')

ID_LINKS = dict(db.execute('SELECT name, identification_url FROM make ORDER BY rowid'))
MODELS = {key: tuple(fields) for key, *fields in db.execute(
    'SELECT id, make, name, first_year, last_year FROM model ORDER BY rowid'
)}
CATEGORIES = [name for name, in db.execute('SELECT name FROM category ORDER BY rowid')]

db.row_factory = sqlite3.Row
PRODUCTS = []
for row in db.execute("""
    SELECT slug, name, brand, part_number AS number, category, price_cents,
           retailer, retailer_url AS buy, reference_url AS source, summary,
           description AS detail, fitment_note AS condition, mount, image_alt AS alt,
           COALESCE(h.check_note, '') AS fit_check, COALESCE(h.by_mount, 0) AS by_mount
    FROM part LEFT JOIN fitment_hint h ON h.part = part.slug ORDER BY part.rowid
"""):
    product = dict(row)
    product['price'] = product.pop('price_cents') / 100
    key = (product['slug'],)
    product['fit'] = [tuple(r) for r in db.execute(
        'SELECT model, first_year, last_year FROM fitment WHERE part=? ORDER BY rowid', key)]
    product['aliases'] = [r[0] for r in db.execute(
        'SELECT number FROM alternate_number WHERE part=? ORDER BY rowid', key)]
    product['specs'] = [tuple(r) for r in db.execute(
        'SELECT label, value FROM specification WHERE part=? ORDER BY rowid', key)]
    product['steps'] = [r[0] for r in db.execute(
        'SELECT instruction FROM installation_step WHERE part=? ORDER BY step', key)]
    if not product['fit'] or not product['steps']:
        raise ValueError(f"Missing fitment or installation instructions for {product['slug']}")
    PRODUCTS.append(product)
db.close()
