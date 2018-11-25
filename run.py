#!/usr/bin/python3
"""
"""

import argparse
import json
import csv
import psycopg2
import subprocess
import tempfile

# ----------------------------------------------------------------
# Command line parser
parser = argparse.ArgumentParser(description='Running benchmarks.')
parser.add_argument('-n', dest='N', type=int, default=1,
                    help='Number of time to run benchmark')
parser.add_argument('--comment', type=str, default=None,
                    help='')
parser.add_argument('package',
                    help='Package for which we want to run benchmarks')
parser.add_argument('rev',
                    help='Git revision')
args = parser.parse_args()

# ----------------------------------------------------------------
# Packages config
with open('config.json') as f :
    cfg = json.load(f)

# ----------------------------------------------------------------
# Extract paramers
pkg = args.package
url = cfg[pkg]['url']
exe = cfg[pkg]['exe']
if len(args.rev) == 40 :
    rev = args.rev
else:
    rev = cfg[args.package]['commits'][args.rev]

# ----------------------------------------------------------------
# Build benchmark
with open('db.conf') as f :
    db_cfg = json.load(f)
with psycopg2.connect( **db_cfg ) as conn :
    with conn.cursor() as cur :
        # Get SHA256 hash of repo
        cur.execute('SELECT sha256 FROM sha256 WHERE url=%s AND rev=%s', (url, rev))
        sha256 = cur.fetchone()[0]
        if sha256 is None :
            r      = subprocess.run(['nix-prefetch-git','--quiet',url,rev], stdout=subprocess.PIPE)
            sha256 = json.loads(r.stdout)['sha256']
            cur.execute('INSERT INTO sha256 VALUES (%s,%s,%s)', (url,rev,sha256))
        # Execute shell with executable
        for _ in range(args.N) :
            with tempfile.NamedTemporaryFile() as tmp :
                subprocess.run(
                    ['nix-shell',
                     '--expr',
                     'import ./nix/%s {url = "%s"; rev="%s"; sha256="%s";}' % (pkg, url, rev, sha256),
                     '--run',
                     '%s --csv %s' % (exe, tmp.name)
                    ])
                with open(tmp.name) as f :
                    cur.execute('BEGIN')
                    cur.execute('INSERT INTO benchmarks VALUES (DEFAULT, now(), %s, %s, %s, %s) RETURNING id',
                                (pkg, rev, None if args.rev == rev else args.rev, args.comment))
                    i, = cur.fetchone()
                    for row in list(csv.reader(f))[1:] :
                        cur.execute('INSERT INTO measurements VALUES (%s,%s,%s,%s,%s,%s,%s,%s)', [i]+row)
                    cur.execute('COMMIT')
