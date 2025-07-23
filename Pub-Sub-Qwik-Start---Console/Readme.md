---
### ⚠️📚 Disclaimer

Skrip ini hanya untuk tujuan pembelajaran 🧑‍🎓 dan automasi dasar dalam lab Google Cloud.  
Pastikan kamu memahami setiap langkah dan perintah 🔍 agar kamu bisa benar-benar belajar dan memahami prosesnya secara menyeluruh.

```bash
gcloud services enable pubsub.googleapis.com
```
Create a topic
```
gcloud pubsub topics create MyTopic
```
Add a subscription
```
gcloud pubsub subscriptions create MySub --topic=MyTopic
