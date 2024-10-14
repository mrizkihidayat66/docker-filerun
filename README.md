## FileRun
This version of FileRun (20220519) is derived from the official Docker image at the time and is explicitly tagged with this release. Unlike the usual practice of using the "latest" tag, this image is version-specific to avoid potential issues with automatic updates.

### No Updates or Maintenance
This image will **NOT** receive any updates, as newer versions of FileRun now require a paid license. Since this version predates that requirement, it remains free to use. However, be mindful that official support and documentation may become outdated, and assistance may be limited if you encounter any issues.

### docker-compose.yml ###
```yaml
version: '3.8'

services:
  db:
    image: mariadb:10.5
    container_name: filerun_mariadb
    environment:
      MYSQL_ROOT_PASSWORD: YOUR_DATABASE_ROOT_PASSWORD
      MYSQL_USER: filerun-user
      MYSQL_PASSWORD: YOUR_DATABASE_USER_PASSWORD
      MYSQL_DATABASE: filerun-db
    volumes:
      - ./db:/var/lib/mysql

  web:
    image: mrizkihidayat66/docker-filerun
    container_name: filerun_web
    environment:
      FR_DB_HOST: db
      FR_DB_PORT: 3306
      FR_DB_NAME: filerun-db
      FR_DB_USER: filerun-user
      FR_DB_PASS: YOUR_DATABASE_USER_PASSWORD
      APACHE_RUN_USER: www-data
      APACHE_RUN_USER_ID: 33
      APACHE_RUN_GROUP: www-data
      APACHE_RUN_GROUP_ID: 33
    depends_on:
      - db
    links:
      - db
      - tika
      - elasticsearch
    ports:
      - "5002:80"
    volumes:
      - ./html:/var/www/html
      - ./user-files:/user-files

  tika:
    image: apache/tika
    container_name: filerun_tika

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:6.8.23
    container_name: filerun_search
    environment:
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65535
        hard: 65535
    mem_limit: 1g
    command: >
      sh -c "mkdir -p esearch &&
             mkdir -p /usr/share/elasticsearch/data/nodes &&
             chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data &&
             /usr/local/bin/docker-entrypoint.sh"
    volumes:
      - ./esearch:/usr/share/elasticsearch/data
```

### Gratitude and Support

We extend our sincere gratitude to the FileRun, LDA for their hard work and dedication in developing such a useful platform. If you find FileRun beneficial, we highly recommend supporting them by purchasing a license for the latest version. For pricing details, please visit the [FileRun Pricing Page](https://filerun.com/pricing).
