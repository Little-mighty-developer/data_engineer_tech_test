import json
from app.etl import (
    load_events,
    filter_consented,
    aggregate_by_campaign,
    build_activation_payload
)


def test_filter_consented_normalizes_and_drops_missing(tmp_path):
    p = tmp_path / "events.jsonl"
    p.write_text(
        '\n'.join([
            json.dumps({"campaign":"A", "consent": True, "click":1, "conversion":0}),
            json.dumps({"campaign":"B", "consent": "true", "click":1, "conversion":1}),
            json.dumps({"campaign":"C", "consent": "false", "click":1, "conversion":0}),
            json.dumps({"campaign":"D", "click":1, "conversion":0}),  # missing consent
        ]),
        encoding="utf-8"
    )
    df = load_events(str(p))
    df2 = filter_consented(df)
    # Should keep A and B only
    assert set(df2["campaign"]) == {"A", "B"}


def test_aggregate_and_payload(tmp_path):
    p = tmp_path / "events.jsonl"
    p.write_text(
        '\n'.join([
            json.dumps({
                "campaign": "X", "consent": True, "click": 1, "conversion": 0
            }),
            json.dumps({
                "campaign": "X", "consent": True, "click": 1, "conversion": 1
            }),
            json.dumps({
                "campaign": "Y", "consent": True, "click": 0, "conversion": 1
            }),
        ]),
        encoding="utf-8"
    )
    df = load_events(str(p))
    df = filter_consented(df)
    agg = aggregate_by_campaign(df)
    assert agg.to_dict(orient="records") == [
        {"campaign": "X", "clicks": 2, "conversions": 1},
        {"campaign": "Y", "clicks": 0, "conversions": 1},
    ]
    payload = build_activation_payload(agg)
    assert payload == [
        {"campaign": "X", "metrics": {"clicks": 2, "conversions": 1}},
        {"campaign": "Y", "metrics": {"clicks": 0, "conversions": 1}},
    ]
