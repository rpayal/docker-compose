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

### You can run it by;
```
docker-compose up
```

### You can run these in detached mode by;
```
docker-compose up -d
```

### You can check all running containers by;
```
docker ps

CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                  NAMES
aa0c3cbf5a93        php:apache                       "docker-php-entrypoi…"   3 hours ago         Up 5 seconds        0.0.0.0:5000->80/tcp   docker-compose_website_1
50faad0e9040        docker-compose_product-service   "python api.py"          3 hours ago         Up 6 seconds        0.0.0.0:5001->80/tcp   docker-compose_product-service_1
```

### You can stop all containers by;
```
docker-compose stop
```

# Integrating EFK to collect docker logs. Explains how to collect logs from various services.
Changes made to collect Docker logs to EFK (Elasticsearch + Fluentd + Kibana) stack. 

Elasticsearch is an open source search engine known for its ease of use. Kibana is an open source Web UI that makes Elasticsearch user friendly for marketers, engineers and data scientists alike.

By combining these three tools EFK (Elasticsearch + Fluentd + Kibana) we get a scalable, flexible, easy to use log collection and analytics pipeline.

All of services's logs will be ingested into Elasticsearch + Kibana, via Fluentd.

### Prepare Fluentd image
Create fluentd/Dockerfile with the following content;
fluentd/Dockerfile
```
FROM fluent/fluentd:v1.6-debian-1
USER root
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "3.5.2"]
USER fluent
```

Create Fluentd's configuration file fluentd/conf/fluent.conf. in_forward plugin is used for receive logs from Docker logging driver, and out_elasticsearch is for forwarding logs to Elasticsearch.
fluentd/conf/fluent.conf
```
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>
<match *.**>
  @type copy
  <store>
    @type elasticsearch
    host elasticsearch
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
  </store>
  <store>
    @type stdout
  </store>
</match>
```

### You can run it by;
```
docker-compose up
```

### You can run these in detached mode by;
```
docker-compose up -d
```

### You can check all running containers by;
```
docker ps

ONTAINER ID        IMAGE                                                 COMMAND                  CREATED             STATUS              PORTS                                                          NAMES
1a10736c6830        php:apache                                            "docker-php-entrypoi…"   34 minutes ago      Up 34 minutes       0.0.0.0:5000->80/tcp                                           docker-compose_website_1
1dc7592e6388        docker-compose_product-service                        "python api.py"          34 minutes ago      Up 34 minutes       0.0.0.0:5001->80/tcp                                           docker-compose_product-service_1
f30289d6cb98        kibana:7.2.0                                          "/usr/local/bin/kiba…"   34 minutes ago      Up 34 minutes       0.0.0.0:5601->5601/tcp                                         docker-compose_kibana_1
f6ee6345c2e7        docker-compose_fluentd                                "tini -- /bin/entryp…"   34 minutes ago      Up 34 minutes       5140/tcp, 0.0.0.0:24224->24224/tcp, 0.0.0.0:24224->24224/udp   docker-compose_fluentd_1
54d9a5d79f25        docker.elastic.co/elasticsearch/elasticsearch:7.2.0   "/usr/local/bin/dock…"   34 minutes ago      Up 34 minutes       0.0.0.0:9200->9200/tcp, 9300/tcp                               docker-compose_elasticsearch_1
```

### Generate httpd Access Logs
curl http://localhost:5000/?[1-10]

> If you have other query strings in your URL, assign the sequence to a throwaway variable:
curl http://localhost:5000/?myVar=111&fakeVar=[1-10]

### Confirm Logs from Kibana
Go to http://localhost:5601/ with your browser. Then, you need to set up the index name pattern for Kibana. Please specify fluentd-* to Index name or pattern and press Create button.

Then, go to Discover tab to seek for the logs. As you can see, logs are properly collected into Elasticsearch + Kibana, via Fluentd.

![Image of Kibana Logs](https://github.com/rpayal/docker-compose/images/kibana-logs.png)

### You can stop all containers by;
```
docker-compose stop
```
