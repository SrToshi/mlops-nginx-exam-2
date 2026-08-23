## Exam Development Notes

- **Fixed Docker network subnet**: The `/nginx_status` endpoint restricts access via the `allow` directive in `nginx.conf`, which requires knowing the Docker network's subnet. Since subnet assignment is dynamic by default (and would differ across machines), the subnet was pinned explicitly in `docker-compose.yml` via `networks.default.ipam.config`, ensuring the same `allow 172.28.0.0/16` rule works reproducibly regardless of the host running the project.

- **`SSL_VERIFY: "false"` on `nginx_exporter`**: Since Nginx serves `/nginx_status` exclusively over HTTPS with a self-signed certificate, `nginx_exporter` cannot validate the certificate chain by default. Rather than exposing `/nginx_status` over plain HTTP (which would weaken the all-HTTPS design), the exporter's own SSL verification was disabled via its `SSL_VERIFY` environment variable — the connection remains encrypted end-to-end, only certificate authority validation is skipped, consistent with how `--cacert` is used for the same self-signed certificate in `tests/run_tests.sh`.

- **`src/api/requirements.txt` was empty**: populated with the same dependency set used for the FastAPI + scikit-learn stack in earlier coursework (`fastapi`, `uvicorn`, `joblib`, `numpy`, `scikit-learn`), since neither `main.py` version imports `uvicorn` directly — it's only invoked via the Dockerfile's `CMD`.

- **Self-signed certificates are committed to this repo** (`deployments/nginx/certs/`), including the private key. This is acceptable only for this test nginx exercise so `make start-project` works out of the box for grading; in a real production repository, private keys should never be committed and would instead be managed via a secrets manager or generated at deploy time.

- **Build context for `api-v1`/`api-v2`/`nginx` is the repository root** (not their respective subfolders), since each Dockerfile needs to reach files outside its own directory (`model/model.joblib`, shared `src/api/requirements.txt`, or `deployments/nginx/.htpasswd` and `certs/`) — Docker's build context cannot traverse upward with `../`.

## Bonus: Monitoring in Action

Prometheus datasource connected in Grafana and dashboard (ID `12708`) imported, showing real Nginx metrics collected via `nginx_exporter` after generating test traffic through `/predict`.

![Grafana dashboard with Nginx metrics](docs/screenshots/grafana_screenshot.png)
