"""
Create an app using FastAPI that has a singular endpoint which returns
a json message.
"""
from datetime import datetime
from fastapi import FastAPI


app = FastAPI()

"""
Use FastAPI() to setup get requests that return information based on the context
path of the called URI.
"""


@app.get("/message")
async def get_message() -> dict:
    """
    This function takes in absolutely nothing and returns a simple message response
    to the caller.
    """
    message: dict = {
        "message": "Automate all the things!",
        "timestamp": datetime.now()
    }
    return message


@app.get("/readiness")
async def get_readiness() -> dict:
    """
    This function takes in absolutely nothing and returns a simple message.
    """
    message: dict = {
        "ready": True
    }
    return message
