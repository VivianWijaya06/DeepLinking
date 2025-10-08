# Reflection Questions

### Concept Check
1. Perbedaan antara route di dalam Flutter dan deep link di Android adalah kalau route itu digunakan untuk navigasi di dalam sebuah aplikasi, sedangkan kalau deep link itu digunakan untuk membuka aplikasi langsung ke halaman tertentu dari luar aplikasi tersebut melalui sebuah URL khusus.
2. Android memerlukan intent filter agar sistem tau aplikasi mana yang bisa menangani link dengan skema tertentu (seperti contohnya myapp://) dan bisa membuka aplikasi tersebut saat link dijalankan.

### Technical Understanding
1. Package uni_links berfungsi untuk mendeteksi dan membaca link yang masuk ke aplikasi, baik saat aplikasi baru dibuka maupun ketika sudah berjalan.
2. Jika deep link dibuka saat aplikasi masih berjalan, maka listener uriLinkStream akan menangkap link baru tersebut dan langsung menavigasi ke halaman yang sesuai tanpa perlu me-restart aplikasi.

### Debugging Insight
Jika perintah adb berhasil membuka aplikasi tapi tidak berpindah ke halaman detail, hal pertama yang saya cek adalah fungsi _handleIncomingLink() untuk memastikan pengecekan uri.host dan uri.pathSegments sudah benar. Jika sudah benar, saya akan memeriksa bagian intent-filter di AndroidManifest.xml untuk memastikan skema dan host-nya sesuai dengan link yang digunakan.

# Wrap up summary
Menurut pemahaman saya, jadi deep linking itu menghubungkan navigasi flutter dengan sistem intent filter di android. Intent filter membuat android dapat mengenali skema URL khusus seperti myapp://, lalu flutter akan membaca data link tersebut menggunakan package uni_links dan menavigasi ke halaman yang sesuai di dalam aplikasi.

Dalam praktiknya, deep link berguna untuk membuka halaman tertentu dari notifikasi, pesan, atau tautan yang dibagikan pengguna lain. Misalnya, link promo, halaman profil, atau detail produk bisa langsung membuka aplikasi ke bagian tersebut.

Hal yang paling menantang adalah mengatur intent filter dan memastikan link terbaca dengan benar di flutter. Saya mengatasinya dengan memeriksa skema dan host di AndroidManifest.xml serta memastikan fungsi _handleIncomingLink() sudah memproses URI dengan benar.
