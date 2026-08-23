start-project:
	docker compose -p nginx-examp up --build -d
stop-project:
	docker compose -p nginx-examp down

test:
	bash tests/run_tests.sh

links:
	@echo "Prometheus: http://localhost:9090"
	@echo "Grafana: http://localhost:3000"
