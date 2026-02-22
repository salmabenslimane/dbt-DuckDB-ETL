-- models/staging/src_playstore_reviews.sql
-- Purpose: expose the raw reviews.jsonl file as a dbt relation.
-- This is a source model only — no transformations, no business logic.
-- DuckDB's read_ndjson_auto() handles newline-delimited JSON (JSONL format).
-- Materialized as view: no cost, always reads fresh from disk.

select *
from read_ndjson_auto('data/raw/reviews.jsonl')