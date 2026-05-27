#!/usr/bin/env python3
"""Strip CONCURRENTLY from all Alembic migration files to work around
Alembic's transaction wrapping."""
import os
import re
import sys

versions_dir = sys.argv[1]
for fname in os.listdir(versions_dir):
    if not fname.endswith('.py'):
        continue
    path = os.path.join(versions_dir, fname)
    with open(path) as f:
        content = f.read()
    orig = content
    content = content.replace('CREATE INDEX CONCURRENTLY', 'CREATE INDEX /* CONCURRENTLY-removed */')
    content = content.replace('DROP INDEX CONCURRENTLY', 'DROP INDEX /* CONCURRENTLY-removed */')
    # Remove bare op.execute("COMMIT") lines that were workarounds for CONCURRENTLY
    # (may be indented with 4 or 8 spaces)
    content = re.sub(r'^[ ]*op\.execute\("COMMIT"\)\n?', '', content, flags=re.MULTILINE)
    if content != orig:
        with open(path, 'w') as f:
            f.write(content)
        print(f'Patched: {fname}')
