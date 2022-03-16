#!/usr/bin/env python3
"""
This helper script acts as a readiness check for the api-svc.
It makes a request to the url passed as an argument ending in the /messages
context path, and checks the output. This is used for the helm test container.
"""
import argparse
import logging
import re
import requests
import sys


def main():
    """
    Main function that:
        - Gets the arguments from the command line using argparse
        - Makes a request to the URL
        - Gets the response from the request
        - Verifies the response is correct.
            - Mirrors the functionality of the app unit test in app/tests/test_main.py
    """
    parser = argparse.ArgumentParser(description="""This script makes a request
                                     to a given api-svc URL and ensures the
                                     returned value is correct.""")
    parser.add_argument("url_endpoint", help="The URL endpoint to check the response.")
    args = parser.parse_args()
    logger.info(f"Parsed args:\n{args}")

    response: object = requests.get(args.url_endpoint)
    if response.raise_for_status():
        logger.info("Response successful..")
    data: dict = response.json()

    # Regex to validate the timestamp based on the base datetime.now() format
    # 2022-03-15T13:07:06.699656
    reg: str = r"^\d{4}-\d{2}-\d{2}T\d{1,2}:\d{1,2}:\d{1,3}.\d+$"
    if "message" and "timestamp" in data.keys():
        logger.info("Correct values are in the response.")
    else:
        logger.error("Response dictionary missing one or more of the expected keys.")
        sys.exit(1)
    if data["message"] == "Automate all the things!":
        logger.info(f"The response message values is correctly set to: \"{data['message']}\"")
    else:
        logger.error("The message key does not contain the expected value.")
        sys.exit(1)
    if re.fullmatch(reg, data["timestamp"]):
        logger.info(f"The timestamp: \"{data['timestamp']}\" returns matches the regex.")
    else:
        logger.error("The timestamp does not match the regex.")
        sys.exit(1)


if __name__ == "__main__":
    """
    Global logger configuration for logging to StreamHandler
    """
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    main()
