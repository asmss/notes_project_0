from flask import request, jsonify
from config.db import db 
from bson.objectid import ObjectId
from datetime import datetime

def create_note():
    res = request.json
    user_id = request.headers.get('user-id')
    
    if not res or "title" not in res or "content" not in res:
        return jsonify({"status":"error","message":"Başlık ve içerik boş olamaz"}), 400
    
    note = {
        "userId": user_id,  
        "title": res["title"],
        "content": res["content"],
        "isCompleted": res.get("isCompleted", False),
        "createdAt": datetime.now()
    }
    result = db.notes.insert_one(note)
    return jsonify({
        "status": "ok",
        "message": "Not başarıyla oluşturuldu",
        "id": str(result.inserted_id)
    }), 201

def getNotes():
    user_id = request.headers.get('user-id')
    notes_temp = db.notes.find({"userId": user_id})
    
    notes = []
    for note in notes_temp:
        date = note.get("createdAt")
        notes.append({
            "id": str(note["_id"]),
            "title": note.get("title"),
            "content": note.get("content"),
            "isCompleted": note.get("isCompleted", False),
            "createdAt": date.isoformat() if hasattr(date, 'isoformat') else str(date)
        })

    return jsonify({
        "status": "ok",
        "notes": notes
    }), 200    

def delete_note(note_id):
    user_id = request.headers.get('user-id')
    res = db.notes.delete_one({"_id": ObjectId(note_id), "userId": user_id})

    if res.deleted_count == 0:
        return jsonify({"status": "error", "message": "Not bulunamadı veya yetkiniz yok"}), 404
    
    return jsonify({"status": "ok", "message": "Not başarıyla silindi"}), 200
    
def change_completed(note_id):
    user_id = request.headers.get('user-id')
    res = db.notes.find_one({"_id": ObjectId(note_id), "userId": user_id})
    if not res:
        return jsonify({"status": "error", "message": "Not bulunamadı"}), 404
    
    new_status = not res.get("isCompleted", False)
    db.notes.update_one(
        {"_id": ObjectId(note_id), "userId": user_id},
        {"$set": {"isCompleted": new_status}}
    )
    return jsonify({"status": "ok", "message": "Durum değiştirildi"}), 200        

def update_note(note_id):
    try:
        user_id = request.headers.get('user-id')
        data = request.get_json()
        
        update_data = {
            "title": data.get("title"),
            "content": data.get("content"),
            "isCompleted": data.get("isCompleted"),
            "updatedAt": datetime.utcnow()
        }

        result = db.notes.update_one(
            {"_id": ObjectId(note_id), "userId": user_id}, 
            {"$set": update_data}
        )

        if result.matched_count > 0:
            return jsonify({"message": "Not başarıyla güncellendi", "status": 200}), 200
        else:
            return jsonify({"message": "Not bulunamadı veya yetkisiz işlem", "status": 404}), 404

    except Exception as e:
        return jsonify({"error": str(e), "status": 500}), 500