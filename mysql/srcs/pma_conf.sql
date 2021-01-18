CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';
CREATE USER 'pma'@'%' IDENTIFIED BY 'pmapass';
GRANT ALL PRIVILEGES ON WordPress.* TO 'pma'@'localhost';
GRANT ALL PRIVILEGES ON WordPress.* TO 'pma'@'%';

FLUSH PRIVILEGES;