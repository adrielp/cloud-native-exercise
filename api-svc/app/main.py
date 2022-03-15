"""
Create an app using FastAPI that has a singular endpoint which returns
a json message.
"""
from datetime import datetime
from fastapi import FastAPI


app = FastAPI()

"""
Setup a put request for the FastAPI application to get the collection stats
"""


@app.get("/message")
async def get_message() -> dict:
    """
    This function takes in absolutely nothing and returns a simple message response
    to the call.
    """
    message: dict = {
        "message": "Automate all the things!",
        "timestamp": datetime.now()
    }
    return message
