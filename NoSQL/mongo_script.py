# Import MongoDB client
from pymongo import MongoClient

# Step 1: Connect to MongoDB
client = MongoClient("mongodb://localhost:27017/")

# Step 2: Access database
db = client["streaming_nosql_db"]

# Step 3: Access collection
collection = db["user_activity"]

# Step 4: Display all users
print("----- ALL USERS -----")
for user in collection.find():
    print(user)

# Step 5: Query 1 - Users who watched Breaking Bad
print("\n----- USERS WHO WATCHED BREAKING BAD -----")
query1 = {"watch_history.title": "Breaking Bad"}

for user in collection.find(query1):
    print(user)

# Step 6: Query 2 - Users who used Laptop
print("\n----- USERS WHO USED LAPTOP -----")
query2 = {"watch_history.device": "Laptop"}

for user in collection.find(query2):
    print(user)
    