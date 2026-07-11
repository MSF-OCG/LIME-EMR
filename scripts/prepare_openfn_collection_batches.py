#!/usr/bin/env python3
"""Split GitHub metadata JSON into OpenFn collection upload batches.

Mirrors the chunking strategy used in msf-lime-metadata wf0-sync-metadata
so each `openfn collections set --items` stays under API size limits.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

# Conservative limit for a single `openfn collections set --items` payload.
DEFAULT_MAX_BATCH_CHARS = 350_000

# Metadata arrays consumed by Mosul workflows as `<key>-value-<index>`.
ARRAY_KEY_PREFIXES = ("optsMap", "identifiers", "optionSetMap")


def _serialized_size(value: object) -> int:
    return len(json.dumps(value, separators=(",", ":"), ensure_ascii=False))


def _expand_source(data: dict) -> dict[str, object]:
    """Flatten top-level metadata into collection key/value items."""
    items: dict[str, object] = {}

    for key, value in data.items():
        if isinstance(value, list) and (
            key in ARRAY_KEY_PREFIXES
            or (value and isinstance(value[0], (dict, list)))
        ):
            for index, entry in enumerate(value):
                items[f"{key}-value-{index}"] = entry
        else:
            items[key] = value

    return items


def _chunk_dict_items(items: dict[str, object], max_chars: int) -> list[dict[str, object]]:
    """Group items into batches that fit under max_chars when serialized."""
    batches: list[dict[str, object]] = []
    current: dict[str, object] = {}
    current_size = 2  # {}

    for key, value in items.items():
        entry = {key: value}
        entry_size = _serialized_size(entry)

        if entry_size > max_chars:
            if isinstance(value, dict):
                sub_batches = _chunk_dict_items(dict(value.items()), max_chars)
                for index, sub_batch in enumerate(sub_batches):
                    batches.append({f"{key}-chunk-{index}": sub_batch})
            else:
                batches.append(entry)
            continue

        if current and current_size + entry_size > max_chars:
            batches.append(current)
            current = {}
            current_size = 2

        current[key] = value
        current_size += entry_size

    if current:
        batches.append(current)

    return batches


def prepare_batches(source: dict, max_chars: int) -> list[dict[str, object]]:
    expanded = _expand_source(source)
    return _chunk_dict_items(expanded, max_chars)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_json", type=Path, help="Path to collections metadata JSON")
    parser.add_argument(
        "output_dir",
        type=Path,
        help="Directory to write batch-NNN.json files",
    )
    parser.add_argument(
        "--max-chars",
        type=int,
        default=DEFAULT_MAX_BATCH_CHARS,
        help="Maximum serialized size per batch file",
    )
    args = parser.parse_args()

    data = json.loads(args.source_json.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise SystemExit("Source JSON must be an object of key/value metadata pairs")

    batches = prepare_batches(data, args.max_chars)
    args.output_dir.mkdir(parents=True, exist_ok=True)

    for index, batch in enumerate(batches, start=1):
        out_path = args.output_dir / f"batch-{index:03d}.json"
        out_path.write_text(
            json.dumps(batch, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )

    print(f"Wrote {len(batches)} batch file(s) to {args.output_dir}")


if __name__ == "__main__":
    main()
