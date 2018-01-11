import random
import string

import pytest
import requests
from pymongo import MongoClient


def test_http():
    response = requests.get("http://linkerdtcp:7400")
    response.raise_for_status()
    assert "MongoDB" in response.text


@pytest.mark.parametrize("host,port", [
    ("linkerdtcp", 7400), # Test via linkerd-tcp
    ("mongodb", 27017) # Test direct connection
])
def test_connection(host, port):
    client = MongoClient(host, port)
    db = client.test_database

    collection_name = "".join(random.choices(string.ascii_lowercase, k=5))
    collection = db[collection_name]

    post = {
        "author": "Mike",
        "text": "My first blog post!",
        "tags": ["mongodb", "python", "pymongo", random.randint(1, 100)]
    }

    assert collection.insert_one(post).inserted_id
    assert collection.find_one() == post
