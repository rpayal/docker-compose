# Product service

from flask import Flask
from flask_restful import Resource, Api
from redis import Redis

import os

app = Flask(__name__)
api = Api(app)
redis = Redis(host=os.environ.get('REDIS_HOST', 'redis'), port=6379)

class Product(Resource):
    def get(self):
        return {
            'products':['Ice cream',
                'Chocolate',
                'Bread',
                'Fruit',
                'Eggs']
        }

class Hello(Resource):
    def get(self):
        redis.incr('hits')
        return 'This service been hit %s times.\n' % redis.get('hits').decode('utf-8')

api.add_resource(Product, '/')
api.add_resource(Hello, '/hello')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)

