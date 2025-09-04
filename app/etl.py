import json
import pandas as pd


def load_events(path):
    """Load raw JSONL events into a DataFrame"""
    rows = []
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            if not line.strip():
                continue
            rows.append(json.loads(line))
    return pd.DataFrame(rows)


def filter_consented(df):
    # Bug: consent sometimes arrives as strings "true"/"false"; we should
    # normalize. Also: function should drop records with missing consent
    return df[df["consent"] == True]  # noqa: E712


def aggregate_by_campaign(df):
    """Return clicks & conversions per campaign"""
    g = df.groupby("campaign").agg(
        clicks=("click", "sum"),
        conversions=("conversion", "sum")
    ).reset_index()
    return g


def build_activation_payload(df):
    """Prepare minimal payload for activation platforms"""
    # Expect columns: campaign, clicks, conversions
    payload = []
    for _, r in df.iterrows():
        payload.append({
            "campaign": r["campaign"],
            "metrics": {
                "clicks": int(r["clicks"]),
                "conversions": int(r["conversions"])
            }
        })
    return payload
