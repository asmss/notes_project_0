from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()

MONGO_URI = os.getenv("MONGO_URI")
DB_Name = os.getenv("DB_NAME")

client = MongoClient(MONGO_URI)

db = client[DB_Name]
