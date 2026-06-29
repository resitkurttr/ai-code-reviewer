# AI Code Reviewer

[![Build](https://github.com/resitkurttr/ai-code-reviewer/actions/workflows/build.yml/badge.svg)](https://github.com/resitkurttr/ai-code-reviewer/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.24-blue.svg)](https://flutter.dev)

Yapay zeka destekli kod inceleme araci. Mobil gelistiriciler icin tasarlandi.

## Ozellikler

- Kod Tarama - Kamera ile kod fotografi cek
- AI Analiz - Hata tespiti, optimizasyon onerileri
- Dil Desteği - Python, JavaScript, TypeScript, Swift, Kotlin, Dart ve daha fazlasi
- Gecmis - Incelenen kodlari kaydet
- Paylasim - Sonuclari paylas

## Kurulum

### APK Indir

En guncel APK icin [Releases](https://github.com/resitkurttr/ai-code-reviewer/releases) sayfasina gidin.

### Kaynaktan Derleme

```bash
git clone https://github.com/resitkurttr/ai-code-reviewer.git
cd ai-code-reviewer
flutter pub get
flutter run
```

## API Ayarlari

Uygulama acildiktan sonra Ayarlar bolumunden Groq API anahtarinizi girin.

1. https://console.groq.com adresine gidin
2. Hesap olusturun veya giris yapin
3. API Keys bolumunden anahtar olusturun
4. Uygulamada Ayarlar > API Anahtari bolumune yapistirin

## Proje Yapisi

```
lib/
  main.dart                     - Uygulama giris noktasi
  theme/app_theme.dart          - Tema ve renkler
  models/code_review.dart       - Veri modelleri
  services/
    ai_service.dart             - Groq API entegrasyonu
    review_service.dart         - Inceleme yonetimi
    secure_storage_service.dart - Guvenli depolama
  screens/
    home_screen.dart            - Ana ekran
    review_detail_screen.dart   - Detay ekrani
    history_screen.dart         - Gecmis ekrani
    settings_screen.dart        - Ayarlar ekrani
  components/
    code_input_field.dart       - Kod giris alani
    language_selector.dart      - Dil secici
    review_result_card.dart     - Sonuc karti
  utils/
    constants.dart              - Sabit degerler
    helpers.dart                - Yardimci fonksiyonlar
```

## Teknolojiler

- Flutter - Cross-platform mobil gelistirme
- Groq API - Yapay zeka analizi
- Provider - State management

## Katkida Bulunma

1. Fork yapin
2. Branch olusturun
3. Commit yapin
4. Push yapin
5. Pull Request acin

## Lisans

MIT License - LICENSE dosyasina bakin

## Gelistirici

Reşit Kurt - @resitkurttr
