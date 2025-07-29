1. Buat group dengan nama **DemoGroup** di halaman cloud monitoring
*note:
biarkan default kecuali di bagian (value) isi dengan **instance**

2. Masih di halaman moitoring di panel sebelah kiri pilih uptime check lalu create uptime check dengan:
- Protocol: TCP
- Resource Type: Instance
- Select **DemoGroup**
- Port: 22
- Check frequency: 1 minute
- Biarkan default hingga ke bagian Tittle, enter **DemoGroup uptime check**
  
3. Jalankan script berikut di Cloud Shell project_ID 2
```
curl -LO raw.githubusercontent.com/Haeratunnisa/GCA/main/Monitoring%20Multiple%20Projects%20with%20Cloud%20Monitoring/gsp090.sh
sudo chmod +x gsp090.sh
./gsp090.sh
