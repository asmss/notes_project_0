from flask import Flask
from config.db import db 
from flask_cors import CORS
from controllers.notes import create_note,getNotes,delete_note,change_completed,update_note

app = Flask(__name__)
CORS(app)

@app.route("/")

def main():
    if db is None:
        return {"status":"404","message":"veri tabanı bağlantısı sağlanamadı"}
    return {"status:":"200","messsage":"veri tabanı bağlantısı sağlandı","db":str(db.name)} 

@app.route("/add",methods=["POST"])
def create():
    return create_note()

@app.route("/get_notes",methods=["GET"])
def getnotes():
    return getNotes()

@app.route("/delete/<note_id>",methods=["DELETE"])
def deleteNote(note_id):
    return delete_note(note_id)

@app.route("/change/<note_id>",methods=["PUT"])
def changeButton(note_id):
    return change_completed(note_id)

@app.route("/update/<note_id>",methods=["PUT"])
def updateNote(note_id):
    return update_note(note_id)
if __name__ == "__main__":
    app.run(debug = True,port=5000, host="0.0.0.0")
