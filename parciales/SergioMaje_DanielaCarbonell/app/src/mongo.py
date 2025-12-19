from pymongo import MongoClient


db_mongo = None

def init_mongo():
    global db_mongo

    if not db_mongo:
        client = MongoClient(host='localhost', port=27017)
        db_mongo = client.personas


def init_mongo_migration():
    client = MongoClient(host='localhost', port=27017)
    return client.migracion
