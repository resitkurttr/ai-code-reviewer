# 🤖 AI Code Reviewer

Yapay zeka destekli kod inceleme aracı. Mobil geliştiriciler için tasarlandı.

## 📱 Özellikler

- **Kod Tarama** - Kamera ile kod fotoğrafı çek
- **AI Analiz** - Hata tespiti, optimizasyon önerileri
- **Dil Desteği** - Python, JavaScript, TypeScript, Swift, Kotlin, Dart ve daha fazlası
- **Geçmiş** - İncelenen kodları kaydet
- **Paylaşım** - Sonuçları paylaş

## 🛠️ Teknolojiler

- **Flutter** - Cross-platform mobil geliştirme
- **Groq API** - Yapay zeka analizi
- **Provider** - State management
- **Shared Preferences** - Yerel depolama

## 🚀 Kurulum

### 1. Gereksinimler

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- iOS 12.0+ / Android API 21+

### 2. Projeyi Klonlayın

```bash
git clone https://github.com/resitkurttr/ai-code-reviewer.git
cd ai-code-reviewer
```

### 3. Bağımlılıkları Yükleyin

```bash
flutter pub get
```

### 4. API Anahtarı Ayarlayın

1. [Groq Console](https://console.groq.com) adresine gidin
2. Hesap oluşturun veya giriş yapın
3. **API Keys** bölümünden yeni anahtar oluşturun
4. Uygulamada **Ayarlar** > **API Anahtarı** bölümüne yapıştırın

### 5. Uygulamayı Çalıştırın

```bash
flutter run
```

## 📁 Proje Yapısı

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── theme/
│   └── app_theme.dart          # Tema ve renkler
├── models/
│   └── code_review.dart        # Veri modelleri
├── services/
│   ├── ai_service.dart         # Groq API entegrasyonu
│   ├── review_service.dart     # İnceleme yönetimi
│   └── secure_storage_service.dart  # Güvenli depolama
├── screens/
│   ├── home_screen.dart        # Ana ekran
│   ├── review_detail_screen.dart  # Detay ekranı
│   ├── history_screen.dart     # Geçmiş ekranı
│   └── settings_screen.dart    # Ayarlar ekranı
├── components/
│   ├── code_input_field.dart   # Kod giriş alanı
│   ├── language_selector.dart  # Dil seçici
│   └── review_result_card.dart  # Sonuç kartı
└── utils/
    ├── constants.dart          # Sabit değerler
    └── helpers.dart            # Yardımcı fonksiyonlar
```

## 🎯 Kullanım

### Kod İnceleme

1. Ana sayfada dil seçin
2. Kodunuzu yapıştırın
3. "Analiz Et" butonuna tıklayın
4. Sonuçları inceleyin

### Ayarlar

- **API Anahtarı** - Groq API anahtarınızı girin
- **Model Seçimi** - Kullanılacak AI modelini seçin
- **Tema** - Karanlık/aydınlık mod
- **Bildirimler** - Analiz bildirimleri

## 🔒 Güvenlik

- API anahtarları güvenli şekilde saklanır
- Hiçbir veri sunucuya kaydedilmez
- Yerel depolama kullanılır

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında dağıtılıyor - [LICENSE](LICENSE) dosyasına bakın

## 👨‍💻 Geliştirici

**Reşit Kurt**
- GitHub: [@resitkurttr](https://github.com/resitkurttr)

## 🙏 Teşekkürler

- [Groq](https://groq.com) - AI API
- [Flutter](https://flutter.dev) - UI Framework
- [Material Design](https://material.io) - Tasarım sistemi

---

⭐ Bu projeyi beğendiyseniz, yıldız eklemeyi unutmayın!
