CREATE TABLE IF NOT EXISTS sha256 (
  url    TEXT NOT NULL,
  rev    TEXT NOT NULL,
  sha256 TEXT NOT NULL,
  UNIQUE(url,rev,sha256)
);

CREATE TABLE IF NOT EXISTS benchmarks (
  id      SERIAL PRIMARY KEY,
  t       TIMESTAMP,		-- Time of measurements
  package TEXT NOT NULL,	-- Package name
  rev     TEXT NOT NULL,	-- Git revision
  tag     TEXT,			-- Tag (optional)
  comment TEXT			-- Comment
);

CREATE TABLE IF NOT EXISTS measurements (
  bench    INTEGER NOT NULL REFERENCES benchmarks(id),
  label    TEXT NOT NULL,
  Mean     DOUBLE PRECISION NOT NULL, 
  MeanLB   DOUBLE PRECISION NOT NULL,
  MeanUB   DOUBLE PRECISION NOT NULL,
  Stddev   DOUBLE PRECISION NOT NULL,
  StddevLB DOUBLE PRECISION NOT NULL,
  StddevUB DOUBLE PRECISION NOT NULL
);

