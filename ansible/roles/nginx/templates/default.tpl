server {
    listen  80;
    server_name {{ nginx.servername }};
    root /{{ nginx.docroot }}/cueball-prototype1/web/;

    #location / {
     #   index index.php index.html index.htm;
      #  try_files $uri /app.php$is_args$args;
    #}

    #error_page 404 /404.html;

    #error_page 500 502 503 504 /50x.html;
     #   location = /50x.html {
      #  root /usr/share/nginx/www;
    #}

    #location ~ ^/(app_dev|config)\.php(/|$) {
    #    try_files $uri =404;
    #    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    #    fastcgi_index index.php;
    #    fastcgi_pass unix:/var/run/php/php5.6-fpm.sock;
    #    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    #    include fastcgi_params;
    #}

    #location ~ \.php$ {
    #    return 404;
    #}

    rewrite ^/app\.php/?(.*)$ /$1 permanent;

    try_files $uri @rewriteapp;

    location @rewriteapp {
        rewrite ^(.*)$ /app.php/$1 last;
    }

    # Deny all . files
    location ~ /\. {
        deny all;
    }

    location ~ ^/(app|app_dev)\.php(/|$) {
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_index app.php;
        send_timeout 1800;
        fastcgi_read_timeout 1800;
        fastcgi_pass unix:/var/run/php/php5.6-fpm.sock;
    }

    # Statics
    location /(bundles|media) {
        access_log off;
        expires 30d;

    # Font files
    #if ($filename ~* ^.*?\.(eot)|(ttf)|(woff)$){
    #       add_header Access-Control-Allow-Origin *;
    #}

        try_files $uri @rewriteapp;
    }

    error_log /var/log/nginx/{{ nginx.docroot }}_error.log;
    access_log /var/log/nginx/{{ nginx.docroot }}_access.log;
}



server {
    listen  80;
    server_name vm6-front.dev;
    root /{{ nginx.docroot }}/cueball-frontend/web/;

    rewrite ^/frontend\.php/?(.*)$ /$1 permanent;

    try_files $uri @rewriteapp;

    location @rewriteapp {
        rewrite ^(.*)$ /frontend.php/$1 last;
    }

    # Deny all . files
        location ~ /\. {
        deny all;
    }

    location ~ ^/(frontend|frontend_dev)\.php(/|$) {
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_index app.php;
        send_timeout 1800;
        fastcgi_read_timeout 1800;
        fastcgi_pass unix:/var/run/php/php5.6-fpm.sock;
    }

    # Statics
    location /(bundles|media) {
        access_log off;
        expires 30d;
        try_files $uri @rewriteapp;
    }

    error_log /var/log/nginx/{{ nginx.docroot }}_error.log;
    access_log /var/log/nginx/{{ nginx.docroot }}_access.log;
}
