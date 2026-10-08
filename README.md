# Mini E-Commerce App (Flutter)

Aplikasi mobile Flutter untuk **Katalog Produk & Payment Gateway** berbasis **GetX** dan model immutable **Freezed**, terhubung dengan backend ASP.NET Core dan **Midtrans Payment Gateway**.

---

## 🚀 Fitur Utama

### 1. Katalog Produk
* **Pencarian & Filter Cepat**: Cari nama produk dan filter berdasarkan stok tersedia, stok menipis, atau urutan harga.
* **Detail Produk**: Modal rincian produk dengan status stok real-time, garansi, dan kontrol jumlah beli.
* **Tambah Produk**: Form pendaftaran produk baru dengan *Live Preview*.

### 2. Keranjang & Checkout
* Tambah/kurang kuantitas barang dengan proteksi batas stok gudang.
* Ringkasan total belanja dan checkout otomatis membuat pesanan.

### 3. Payment Gateway (Midtrans Snap)
* **Multi-Metode Pembayaran**: Mendukung QRIS, GoPay, ShopeePay, Virtual Account (BCA, Mandiri, BNI, BRI), dan Kartu Kredit.
* **Fitur Ganti Metode Pembayaran**: Pelanggan dapat mengganti metode pembayaran kapan saja pada pesanan yang belum dibayar (dari Detail Pesanan atau langsung dari dalam WebView Midtrans) tanpa perlu membatalkan pesanan.
* **Simulasi Bayar**: Opsi verifikasi pelunasan instan untuk pengujian.

### 4. Pesanan & Profil
* Riwayat pesanan dengan status real-time (*Pending, Lunas, Dibatalkan*).
* Profil pelanggan dan alamat pengiriman.

---

## 🛠️ Tech Stack

* **Framework**: Flutter (Dart)
* **State Management & Routing**: GetX
* **Data Modeling**: Freezed v4+ & JSON Serializable
* **Networking**: Dio (`ApiClient` dengan interceptor)
* **Payment**: Midtrans Snap WebView (`webview_flutter`)

---


   