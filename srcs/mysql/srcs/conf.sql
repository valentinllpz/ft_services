CREATE DATABASE wordpress;
CREATE USER 'wp_vlugand-'@'%' IDENTIFIED BY 'd3BAZnRfNTNydjFjMzUK';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_vlugand-'@'%';
CREATE USER 'pma_vlugand-'@'%' IDENTIFIED BY 'cG1hQGZ0XzUzcnYxYzM1Cg==';
GRANT ALL PRIVILEGES ON wordpress.* TO 'pma_vlugand-'@'%';
FLUSH PRIVILEGES;