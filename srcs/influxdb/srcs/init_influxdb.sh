rc-service influxdb start
echo "CREATE DATABASE metrics" | influx
echo "CREATE USER 'metrics_vlugand-' WITH PASSWORD 'metrics@ft_53rv1c35' WITH ALL PRIVILEGES" | influx
telegraf &
sleep infinity