CREATE DATABASE wordpress;
CREATE USER 'wp_vlugand-'@'%' IDENTIFIED BY 'wp@ft_53rv1c35';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_vlugand-'@'%';
CREATE USER 'pma_vlugand-'@'%' IDENTIFIED BY 'pma@ft_53rv1c35';
GRANT ALL PRIVILEGES ON wordpress.* TO 'pma_vlugand-'@'%';
FLUSH PRIVILEGES;