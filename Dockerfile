FROM php:8.2-apache

# Install PDO MySQL extension (pdo and pdo_sqlite are already built into php:8.2-apache)
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html/

# Set full read/write permissions for Apache web server (needed for SQLite)
RUN chown -R www-data:www-data /var/www/html && chmod -R 777 /var/www/html

# Default port
EXPOSE 80

# Configure Apache port dynamically at runtime using PORT environment variable (default 80) and run Apache
CMD ["sh", "-c", "sed -i \"s/Listen [0-9]*/Listen ${PORT:-80}/\" /etc/apache2/ports.conf && sed -i \"s/<VirtualHost \\*:[0-9]*>/<VirtualHost \\*:${PORT:-80}>/\" /etc/apache2/sites-available/000-default.conf && exec apache2-foreground"]

