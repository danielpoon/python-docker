import requests
import numpy as np
import pandas as pd
import psycopg2

print("Hello from Python 3 in a container. This script is to test all the libraries that has been included in the container build.")
print(f"Requests version: {requests.__version__}")
print(f"NumPy version: {np.__version__}")
print(f"Pandas version: {pd.__version__}")
print(f"Psycopg2 version: {psycopg2.__version__}")


