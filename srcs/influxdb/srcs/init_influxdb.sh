rc-service influxdb start
echo "CREATE DATABASE metrics" | influx
echo "CREATE USER 'metrics_vlugand-' WITH PASSWORD 'bWV0cmljc0BmdF81M3J2MWMzNQo=' WITH ALL PRIVILEGES" | influx
telegraf &
sleep infinity