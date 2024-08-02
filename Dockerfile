FROM php:8.1-apache-bullseye

# Debian güvenlik güncellemeleri kaynağını düzelt
RUN sed -i 's/stable\/updates/stable-security\/updates/' /etc/apt/sources.list

# Paketleri yükle
RUN apt-get update && \
    apt-get install -y \
    libzip-dev \
    unzip \
    git && \
    docker-php-ext-install zip

# Composer'ı yükle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Çalışma dizinini ayarla
WORKDIR /var/www/html

# Apache belge kökünü ayarla
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# İzinleri ayarla
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
# RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Laravel uygulaması ve Composer bağımlılıklarını yükle
COPY . /var/www/html
RUN composer install --no-dev --optimize-autoloader

# Uygulama anahtarını oluştur
RUN php artisan key:generate

# Apache'yi başlat
CMD ["apache2-foreground"]

