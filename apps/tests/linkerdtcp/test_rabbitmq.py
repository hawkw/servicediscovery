import random
import string

import pika
import pytest
import timeout_decorator


@timeout_decorator.timeout(5)
@pytest.mark.parametrize("host,port", [
    ("rabbitmqdb", 5672), # Test direct connection
    ("linkerdtcp", 7401) # Test via linkerd-tcp
])
def test_connection(host, port):
    queue = "".join(random.choices(string.ascii_lowercase, k=5))

    connection = pika.BlockingConnection(pika.ConnectionParameters(host, port))
    channel = connection.channel()
    channel.queue_declare(queue=queue)
    channel.basic_publish(
        exchange="",
        routing_key="hello",
        body="Hello World!"
    )
    connection.close()
