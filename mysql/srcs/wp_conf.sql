CREATE DATABASE Wordpress;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'wp_user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON WordPress.* TO 'wp_user'@'localhost';
GRANT ALL PRIVILEGES ON WordPress.* TO 'wp_user'@'%';
FLUSH PRIVILEGES;