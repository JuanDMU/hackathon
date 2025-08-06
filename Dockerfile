# Usamos imagen oficial PHP 8.2 con Apache
FROM php:8.2-apache

# Instalar extensiones necesarias, incluyendo pgsql para PostgreSQL
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Habilitar mod_rewrite (para rutas amigables de Laravel)
RUN a2enmod rewrite

# Cambiar DocumentRoot a /var/www/html/public (carpeta pública de Laravel)
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Agregar ServerName para quitar warning de Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar todo el código al contenedor
COPY . .

# Dar permisos correctos para storage y cache (Laravel)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Instalar dependencias PHP con Composer (sin dependencias de desarrollo)
RUN composer install --no-dev --optimize-autoloader

# Generar clave de la app si no está definida (ignorar error si ya está)
RUN php artisan key:generate || true

# Cachear configuración y rutas para producción
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache || true

# Exponer puerto 80 para HTTP
EXPOSE 80

# Comando para arrancar Apache en primer plano
CMD ["apache2-foreground"]