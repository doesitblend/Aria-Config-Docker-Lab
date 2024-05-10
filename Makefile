clean:
	docker compose down --rmi all -v
	rm -rf ./build/sse-installer ./build/raas/eapi_service \
		./build/salt-master/eapi_plugin .env compose.yaml \
		data/postgres/* data/raas/pki/ data/raas/raas.secconf \
		data/raas/initialized data/master/pki/ data/redis/redis.conf


