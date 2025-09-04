# Section 2 — Hands‑on Repo (AdTech Principal Data Engineer)

Welcome! This repo simulates a realistic take‑home used in live interviews.

Your goal in **~20–30 minutes** is to:
1) Pull the repo and make the CI go green.
2) Fix Terraform/security/formatting issues.
3) Make the Python ETL work and tests pass.
4) Commit with clear messages and a short technical note (see below).

---

## What to do

### 0) Prereqs
- Python 3.11+
- `pip install -r app/requirements.txt`
- Terraform v1.5+
- `tflint` installed
- `pre-commit` installed (`pip install pre-commit`)

### 1) Install Git hooks
```bash
pre-commit install
pre-commit run --all-files
```

### 2) Make CI Green
Open `.github/workflows/ci.yml` to see what runs:
- Python: linting (flake8), formatting (black/isort), tests (pytest)
- Terraform: fmt (check), validate, tflint

Fix whatever fails. Common issues to look for:
- Python bugs & PEP8 violations in `app/etl.py`
- Test failure(s) in `app/tests/test_etl.py`
- Terraform security issues in `infra/terraform/*.tf`
- Provider credentials & public S3 settings
- Missing/mis-typed variables; encryption/versioning
- Misconfigured GitHub Actions caching step

### 3) Short Technical Note (commit as `TECH-NOTE.md`)
In 150–200 words, briefly explain:
- The root cause(s) you found
- What you changed and why
- Any trade‑offs or further improvements

### 4) Bonus (optional)
- Add a CI job that uploads a small test artifact (e.g., coverage.xml)
- Add server‑side encryption + block public access to the S3 bucket via Terraform
- Add a unit test covering a previously unseen edge case

---

## Run locally

```bash
# Python
pip install -r app/requirements.txt
pytest -q

# Terraform
cd infra/terraform
terraform init
terraform fmt -recursive
terraform validate
tflint
```

---

## Deliverables

- A PR showing your fixes
- Passing CI
- `TECH-NOTE.md` summarising your changes

Good luck!
