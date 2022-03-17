# Python FastAPI Simple Microservice Application
This directory (`api-svc`) hosts the files needed to build a simple
[FastAPI](https://fastapi.tiangolo.com) microservice. Emphasis on the **simple**.

The directory structure is as follows:
```
├── Dockerfile # Contains commands to build the container image
├── README.md # This file containing information about the api-svc
├── app # This directory gets built into the image and hosts the api-svc code
│   ├── __init__.py # Empty python __init__ file for the app
│   └── main.py # The main program for the super simple API
├── build.sh # A super basic build script that builds container image
├── run_container.sh # A super basic run script to run the built image as a container locally
├── run_dev_venv.sh # A super basic script that creates a Python venv and installs the requirements for local development
├── src # This directory contains src files related to the app, but not applicaiton code
│   └── requirements.txt # Standard Python requirements file containing modules to install in the venv
└── test # This directory contains test files for pytest unit testing
    └──  test_main.py # This unit test uses the fastAPI test client to confirm the response
```

## Instructions for local development
### Prereqs
* Ensure you have Python 3.9+ installed locally.
    * If running on MacOS you can use `brew install python@39`
    * If running on Linux you can use `{dnf,apt-get} install python3.9` or something to that effect
    * If running on Windows, choose a different OS. Just kidding, check out [Python Getting Started](https://wiki.python.org/moin/BeginnersGuide/Download)
        > When in doubt, see the [Python Getting Started](https://wiki.python.org/moin/BeginnersGuide/Download)
* Ensure you have [Docker](https://www.docker.com/get-started) installed or another OCI compliant build tool like [Buildah](https://buildah.io)
* Ensure you have a text editor and a terminal.

### Run Locally (not in a container)
* Navigate to the root of the [api-svc](./) directory.
* run `source run_dev_venv.sh` script to create a virtual environment and install the development python packages
* run `uvicorn app.main:app --reload` to spin the app up locally in your terminal
* Navigate to `localhost:8000/docs` to see what available endpoints there are

### Run Locally as a container
* Navigate to the root of the [api-svc](./) directory.
* run the `build.sh` script to build the container image
* run the `run_container.sh` script to run the image as a container locally
* Navigate to `localhost:8080/docs` to see what available endpoints there are

### Running Unit Tests
* Navigate to the root of the [api-svc](./) directory.
* Ensure your tests are in the [tests](./tests) directory.
* Ensure your tests match the conventions set by [pytest](https://docs.pytest.org/en/7.1.x/index.html)
* Run `python -m pytest`
    * You can also run the `source venv/bin/activate; ./run_tests_lint_format.sh`
    > Note here that we're using `python -m pytest` instead of just `pytest`
    > This is because we're operating in a virtual environment which causes some issues
    > with module loading when running the tests.

### Run Linting and Formatting
It's a good practice to lint and format your code. I use [autopep8](https://pypi.org/project/autopep8/) and [pylint](https://pylint.org)
* Navigate to the root of the [api-svc](./) directory.
* To automatically format your code using `autopep8`
    * Run `autopep8 --in-place --aggressive --aggressive --recursive <files/dirs>`
* To automatically lint your code using `pylint`
    * Run `pylint <path/to/file>`
    * You can also run the `source venv/bin/activate; ./run_tests_lint_format.sh`

## How does this meet RESTful architecture?
This is a very simple API made very easy by FastAPI. The question then becomes,
how does this meet RESTful architecture?

The answer is `yes`, albeit loosely.

The following are the architerctural constraints that this API server loosely meets:
1. Client-server architecture
    As a client, I interact with the API endpoint, which is hosted inside of a kubernetes cluster, where the POD is acting as the API server
2. Statelessness
    The API server retains no session information when it receives the API request.
    Additionally, the API server run in kubernetes can automatically be scaled to have multiple replicas which are load balanced.
3. Layered system
    The client cannot tell what they're connected directly to when the API server is deployed in "production."
    The client simply hits the API endpoint, but has no understanding if it's hitting the server directly or if it's hitting a load balancer.
4. Uniform interface
    The interface is conceptually separate from what a client understands. Of course, there's nothing really
    for the client to understand under than the URI endpoint.
