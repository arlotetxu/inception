# inception

To check REDIS is working:
docker compose exec wordpress wp redis status --path=/var/www/html --allow-root
docker compose exec redis sh -c 'REDISCLI_AUTH="$(cat /run/secrets/redis_password)" redis-cli dbsize'
docker compose exec redis sh -c 'REDISCLI_AUTH="$(cat /run/secrets/redis_password)" redis-cli --scan | head'

Check dbsize before and after an new worpress entry


===============================================================
