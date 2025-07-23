---
### ⚠️📚 Disclaimer

Skrip ini hanya untuk tujuan pembelajaran 🧑‍🎓 dan automasi dasar dalam lab Google Cloud.  
Pastikan kamu memahami setiap langkah dan perintah 🔍 agar kamu bisa benar-benar belajar dan memahami prosesnya secara menyeluruh.

# Automasi Lab Google Cloud Dataproc Base Camp July 2025 (GSP103)

Skrip ini mengotomasi langkah-langkah dalam lab **Google Cloud Dataproc Base Camp July 2025**, yaitu:

- Mengaktifkan Cloud Dataproc API  
- Memberikan izin Storage Admin pada akun layanan compute  
- Membuat cluster Dataproc dengan konfigurasi yang tepat  
- Mengirim job SparkPi untuk menghitung nilai Pi  
- Mengubah jumlah worker node di cluster  
- Mengirim ulang job SparkPi pada cluster yang diperbarui

---

## Cara menggunakan skrip

1. Pastikan kamu sudah login di Cloud Shell dan punya akses ke project Google Cloud lab kamu.  

2. Jalankan skrip berikut

```bash
curl -LO raw.githubusercontent.com/Haeratunnisa/GCA/Dataproc%3A%20Qwik%20Start%20-%20Console/main/setup.sh
chmod +x setup.sh
./setup.sh
