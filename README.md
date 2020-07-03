# docker-compose 
Explaining basic use of docker compose.

### Example contains two services running in different containers;
* website
* product-service

### Create a product service using python to return products json. Create a dockerfile 

dockerfile
```
#to load the base python image
FROM python:3-onbuild
#copy source code into the image
COPY . /usr/src/app

#Command to run when it starts
CMD ["python", "api.py"] 
```

We can run this using (docker build) to build the image and then run it using (docker run) with other arguments.

As we have multiple services running individually will be tedious and painful, so will use docker compose and configure all our services in one config.

docker-compose.yml
```
version: '3'

services: 
  product-service:
    build: ./product
    volumes: 
      - ./product:/usr/src/app
    ports:
      - '5001:80'
```

You can verify or test your docker compose file by;
```
docker-compose config
```

You can run it by;
```
docker-compose up
```

This will download our dependencies and run our container for service (product-service), can test in browser at http://localhost:5001

Now create a 2nd service, our website with basic php to display all our products from product-service. Add this service in =to our docker-compose file;
```
  website:
    image: php:apache
    volumes: 
      - ./website:/var/www/html
    ports:
      - 5000:80
    depends_on: 
      - product-service
```

You can run it by;
```
docker-compose up
```

You can run these in detached mode by;
```
docker-compose up -d
```

You can check all running containers by;
```
docker ps

CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                  NAMES
aa0c3cbf5a93        php:apache                       "docker-php-entrypoi…"   3 hours ago         Up 5 seconds        0.0.0.0:5000->80/tcp   docker-compose_website_1
50faad0e9040        docker-compose_product-service   "python api.py"          3 hours ago         Up 6 seconds        0.0.0.0:5001->80/tcp   docker-compose_product-service_1
```

You can stop all containers by;
```
docker-compose stop
```
