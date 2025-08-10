FROM php:8.2-apache

# התקנת PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# הפעלת mod_rewrite (לא חובה פה, אבל שימושי)
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY src/ /var/www/html/

EXPOSE 80
