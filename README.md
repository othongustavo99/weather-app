# HzClima

<p align="center">
  <img src="assets/icon/icon.jpeg" alt="HzClima Logo" width="120" style="border-radius: 24px;" />
</p>

<p align="center">
  <strong>App de clima moderno, rápido e com widget na tela inicial</strong><br/>
  Desenvolvido em Flutter com Material Design 3
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Provider-State%20Management-green" alt="Provider" />
  <img src="https://img.shields.io/badge/API-Open--Meteo-blue" alt="Open-Meteo" />
  <img src="https://img.shields.io/badge/Widget-home__widget-orange" alt="Home Widget" />
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License" />
</p>

---

## 📱 Screenshots

<p align="center">
  <img src="assets/screenshots/screenshot9.png" alt="Tela principal atualizada" width="220" />
  <img src="assets/screenshots/screenshot10.png" alt="Busca e favoritos" width="220" />
  <img src="assets/screenshots/screenshot11.png" alt="Widget e dark mode" width="220" />
</p>

<p align="center">
  <em>Home, busca/favoritos e experiência com widget e tema escuro.</em>
</p>

<p align="center">
  <img src="assets/screenshots/screenshot1.jpeg" alt="Screenshot 1" width="140" />
  <img src="assets/screenshots/screenshot2.jpg" alt="Screenshot 2" width="140" />
  <img src="assets/screenshots/screenshot3.jpg" alt="Screenshot 3" width="140" />
  <img src="assets/screenshots/screenshot4.jpg" alt="Screenshot 4" width="140" />
</p>

<p align="center">
  <img src="assets/screenshots/screenshot5.jpg" alt="Screenshot 5" width="140" />
  <img src="assets/screenshots/screenshot6.jpg" alt="Screenshot 6" width="140" />
  <img src="assets/screenshots/screenshot7.jpg" alt="Screenshot 7" width="140" />
  <img src="assets/screenshots/screenshot8.jpg" alt="Screenshot 8" width="140" />
</p>

---

## ✨ Funcionalidades

* **Clima em tempo real** via [Open-Meteo](https://open-meteo.com/) — sem API key.
* **Busca por cidade** com autocomplete e debounce.
* **Localização atual** utilizando GPS e reverse geocoding.
* **Previsão de 5 dias**.
* **Métricas meteorológicas** como:

  * Umidade
  * Sensação térmica
  * Precipitação
  * Velocidade do vento
* **Alternância entre °C e °F** com persistência local.
* **Favoritos de cidades** utilizando SharedPreferences.
* **Widget na tela inicial do Android** através do `home_widget`.
* **Pin do widget pelo aplicativo**, quando permitido pelo sistema.
* **Tema claro e escuro**, incluindo suporte ao tema do sistema.
* **Splash screen animada** com branding.
* **Pull-to-refresh** para atualização manual.
* **Mensagens de erro amigáveis** para:

  * Falta de internet
  * Timeout
  * Cidade não encontrada
  * Permissões de localização
* **Botão voltar inteligente**:

  * Fecha o teclado/sugestões primeiro.
  * Requer dois toques para sair do aplicativo.
* **Animações** de loading, transições de conteúdo e splash.
* **Build release Android estável**, com configuração de R8/ProGuard e regras necessárias para o WorkManager.

---

## 🛠️ Stack & Competências

### Linguagens e frameworks

| Tecnologia            | Uso no projeto                               |
| --------------------- | -------------------------------------------- |
| **Dart 3**            | Linguagem principal                          |
| **Flutter**           | Desenvolvimento da interface multiplataforma |
| **Material Design 3** | Design system, temas e componentes modernos  |

### Arquitetura e organização

| Competência                        | Aplicação                                                       |
| ---------------------------------- | --------------------------------------------------------------- |
| **Arquitetura em camadas**         | `models`, `services`, `providers`, `pages`, `widgets` e `utils` |
| **State Management**               | Provider + ChangeNotifier                                       |
| **Separação de responsabilidades** | Interface desacoplada da lógica de negócio e acesso à API       |
| **Helpers reutilizáveis**          | `WeatherCodeHelper` para ícones, textos e gradientes            |

### Dados e rede

| Competência              | Aplicação                                                                 |
| ------------------------ | ------------------------------------------------------------------------- |
| **API REST**             | Requisições HTTP e processamento de JSON                                  |
| **Open-Meteo Forecast**  | Clima atual, temperatura, vento, umidade, sensação térmica e precipitação |
| **Open-Meteo Geocoding** | Busca de cidades e autocomplete                                           |
| **Reverse geocoding**    | Conversão de latitude/longitude para nome da cidade                       |
| **Tratamento de erros**  | `SocketException`, `TimeoutException` e mensagens amigáveis               |
| **Timeouts**             | Limite de tempo nas requisições HTTP                                      |

### Dispositivo e persistência

| Competência             | Aplicação                                                    |
| ----------------------- | ------------------------------------------------------------ |
| **Geolocalização**      | `geolocator` + gerenciamento de permissões                   |
| **Armazenamento local** | `shared_preferences` para favoritos e unidade de temperatura |
| **Home screen widget**  | `home_widget` + `WeatherHomeWidgetProvider` em Kotlin        |
| **Datas/localização**   | `intl` com suporte a `pt_BR`                                 |

### UX / UI

| Competência                   | Aplicação                                          |
| ----------------------------- | -------------------------------------------------- |
| **Animações**                 | `AnimationController`, Fade, Slide e Scale         |
| **Estados de UI**             | Estados de loading, erro e conteúdo                |
| **Autocomplete com debounce** | Sugestões durante a digitação                      |
| **Favoritos**                 | Chips para acesso rápido às cidades salvas         |
| **Gradientes dinâmicos**      | Aparência do card baseada nas condições climáticas |
| **Navegação Android**         | `PopScope` + duplo toque para sair                 |
| **Splash screen**             | Branding e transição animada para a Home           |

### Qualidade e boas práticas

| Competência                        | Aplicação                                                     |
| ---------------------------------- | ------------------------------------------------------------- |
| **Null-safety**                    | Código utilizando null-safety do Dart                         |
| **Widgets reutilizáveis**          | `WeatherCard`, `ForecastList`, `ErrorViewer` e outros         |
| **Testabilidade**                  | Serviços com `http.Client` injetável para utilização de mocks |
| **Release Android**                | Minificação, R8 e regras ProGuard                             |
| **Gerenciamento de ciclo de vida** | `mounted` checks e `dispose`                                  |
| **Material Design 3**              | Componentes e temas modernos                                  |

---

## 📁 Estrutura do projeto

```text
lib/
├── main.dart
│
├── models/
│   └── weather_model.dart
│       ├── WeatherModel
│       ├── DailyForecast
│       └── CitySuggestion
│
├── services/
│   ├── weather_service.dart
│   │   └── API, geocoding e localização
│   │
│   └── widget_service.dart
│       └── Atualização e pin do widget
│
├── providers/
│   └── weather_provider.dart
│       └── Estado global utilizando Provider
│
├── pages/
│   ├── splash_page.dart
│   └── home_page.dart
│
├── widgets/
│   ├── weather_card.dart
│   ├── forecast_list.dart
│   └── error_viewer.dart
│
└── utils/
    └── weather_code_helper.dart
        └── Ícones, textos e gradientes do clima

android/
└── app/
    └── src/
        └── main/
            └── kotlin/
                └── .../
                    ├── MainActivity.kt
                    └── WeatherHomeWidgetProvider.kt
                        └── Provider nativo do widget
```

---

## 🚀 Como rodar

### Pré-requisitos

* Flutter SDK **3.13 ou superior**
* Dart SDK compatível com a versão do Flutter
* Android Studio e/ou Xcode, conforme a plataforma
* Emulador ou dispositivo físico
* Git

### Clonar o projeto

```bash
git clone https://github.com/othongustavo99/weather-app.git
cd weather-app
```

### Instalar dependências

```bash
flutter pub get
```

### Executar

```bash
flutter run
```

---

## 📦 Build Release

### Android — APK

Para gerar uma versão release:

```bash
flutter build apk --release
```

O APK será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Também é possível executar diretamente em modo release:

```bash
flutter run --release
```

> A configuração de release Android inclui R8/ProGuard e regras específicas para manter componentes necessários ao funcionamento do aplicativo e do widget.

---

## 🔐 Permissões

### Android

As principais permissões utilizadas pelo aplicativo estão relacionadas à internet e localização.

Arquivo:

```text
android/app/src/main/AndroidManifest.xml
```

Exemplo:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### iOS

Para utilização da localização, é necessário configurar a descrição correspondente no:

```text
ios/Runner/Info.plist
```

Exemplo:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Precisamos da sua localização para mostrar o clima local.</string>
```

> Configurações específicas para publicação nas lojas serão tratadas separadamente.

---

## 🔌 APIs utilizadas

| API                                                                  | Função                                                        | Autenticação       |
| -------------------------------------------------------------------- | ------------------------------------------------------------- | ------------------ |
| [Open-Meteo Forecast](https://open-meteo.com/)                       | Clima atual e previsão de 5 dias                              | Não requer API key |
| [Open-Meteo Geocoding](https://open-meteo.com/en/docs/geocoding-api) | Busca e autocomplete de cidades                               | Não requer API key |
| BigDataCloud                                                         | Reverse geocoding e identificação da cidade pelas coordenadas | Não requer API key |

---

## 📦 Principais dependências

```yaml
dependencies:
  flutter:
    sdk: flutter

  http: ^1.6.0
  geolocator: ^13.0.2
  intl: ^0.19.0
  shared_preferences: ^2.5.3
  provider: ^6.1.5
  home_widget: ^0.7.0
  cupertino_icons: ^1.0.8
```

> As versões acima representam as principais dependências utilizadas no projeto. A versão efetivamente instalada pode ser determinada pelo `pubspec.lock`.

---

## 🧪 Testes

Para executar a suíte de testes:

```bash
flutter test
```

O projeto possui testes voltados para diferentes camadas da aplicação, incluindo:

* **Models**
* **Services**
* Requisições HTTP utilizando `MockClient`
* **Widgets**
* Provider
* Persistência com SharedPreferences mock

---

## 🎯 Objetivos de aprendizado

O HzClima foi desenvolvido como um projeto de estudo e portfólio, com foco na aplicação prática de conceitos de desenvolvimento mobile com Flutter.

O projeto demonstra:

1. Desenvolvimento de um aplicativo Flutter completo.
2. Integração com APIs REST públicas.
3. Consumo e tratamento de dados JSON.
4. Gerenciamento de estado com **Provider**.
5. Persistência local com **SharedPreferences**.
6. Geolocalização e gerenciamento de permissões.
7. Integração entre Flutter e código nativo Android.
8. Desenvolvimento de **Home Screen Widget**.
9. Interface utilizando **Material Design 3**.
10. Suporte a tema claro, escuro e sistema.
11. Desenvolvimento de animações e transições.
12. Tratamento de erros de rede.
13. Gerenciamento de estados de loading, erro e conteúdo.
14. Testes unitários e de widgets.
15. Configuração de **build release Android**.
16. Utilização de R8/ProGuard.
17. Organização de código utilizando separação de responsabilidades.

---

## 💼 Projeto de portfólio

O HzClima foi desenvolvido com o objetivo de demonstrar conhecimentos práticos em **desenvolvimento Flutter/mobile**, indo além de uma aplicação simples de consumo de API.

O projeto reúne:

* Consumo de APIs reais
* Arquitetura organizada
* Gerenciamento de estado
* Persistência local
* Geolocalização
* Widgets nativos
* Material Design 3
* Dark mode
* Animações
* Tratamento de erros
* Testes
* Build de produção

A proposta é demonstrar o processo completo de desenvolvimento de uma aplicação mobile funcional, desde a interface até a integração com recursos nativos do dispositivo.

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License**.

Você pode utilizar, estudar, modificar e adaptar o código de acordo com os termos da licença.

---

<p align="center">
  Feito com Flutter 💙
</p>
