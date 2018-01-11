import requests


def test_http():
    response = requests.get("http://linkerdtcp:7400")
    response.raise_for_status()
    assert "MongoDB" in response.text
