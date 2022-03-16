"""
A simple unit test, run through pytest, that tests the functionality of app/main.py
"""
import re

from fastapi.testclient import TestClient
from app.main import app


client = TestClient(app)


def test_get_message():
    """
    A simple function to test the get_message api response through fastapi
    The function tests the following:
        - tests that the response status code is 200 (success)
        - tests that the data loaded via response.json() is a dictionary
        - tests that the message and timestamp keys are in the data dictionary
        - tests that the value of the messsage key is an identical string
        - tests that the value of the timestamp key matches the timestamp regex
    """
    response: object = client.get("/message")
    assert response.status_code == 200
    data: dict = response.json()
    assert isinstance(data, dict)
    assert "message" in data
    assert "timestamp" in data
    assert data["message"] == "Automate all the things!"

    # Regex to validate the timestamp based on the base datetime.now() format
    # 2022-03-15T13:07:06.699656
    reg: str = r"^\d{4}-\d{2}-\d{2}T\d{1,2}:\d{1,2}:\d{1,3}.\d+$"
    assert re.fullmatch(reg, data["timestamp"])


def test_get_readiness():
    """
    A simple function to test the get_message api response through fastapi
    The function tests the following:
        - tests that the response status code is 200 (success)
        - tests that the data loaded via response.json() is a dictionary
        - tests that the message response for "ready" is true
    """
    response: object = client.get("/readiness")
    assert response.status_code == 200
    data: dict = response.json()
    assert isinstance(data, dict)
    assert "ready" in data
    assert data["ready"]
