## Vintage Note

Vintage Note, Flutter ile geliştirilmiş, yüksek performanslı ve bulut senkronizasyonlu bir not alma uygulamasıdır. Kullanıcıların internet olmasa dahi notlarını yönetebilmesini sağlayan Offline-First mimarisi ile tasarlanmıştır.

## Teknik Mimari
Uygulama, verimlilik ve veri tutarlılığını sağlamak için hibrit bir veritabanı yapısı ve asenkron senkronizasyon algoritmaları kullanır:

- **Frontend:** Flutter & Dart

- **State Management:** Provider

- **Local Database:** Isar NoSQL 

- **Backend:** Flask (Python)

- **Cloud Database:** MongoDB Atlas

- **Notifications:** Awesome Notifications (Hatırlatıcı sistemleri)

- **API Client:** http.Client

## Uygulama Görselleri

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; padding: 10px;">
  <img src="./notes/assets/icons/ekran.jpeg" alt="Bildirim" style="width: 200px; height: auto; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
  <img src="./notes/assets/icons/ekran2.jpeg" alt="Ana sayfa" style="width: 200px; height: auto; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
  <img src="./notes/assets/icons/ekran3.jpeg" alt="not ekleme" style="width:  200px; height: auto; object-fit: cover; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">

</div>


## Kurulum ve Çalıştırma

1. **Repoyu klonlayın:**
   ```bash
   git clone [https://github.com/asmss/notes_project_0.git](https://github.com/asmss/notes_project_0.git)
Proje dizinine gidin:
cd notes_project_0/notes

Bağımlılıkları yükleyin:
flutter pub get

Isar kod oluşturucuyu çalıştırın:
dart run build_runner build --delete-conflicting-outputs

Uygulamayı çalıştırın:
flutter run

---


