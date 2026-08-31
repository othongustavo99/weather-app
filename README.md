# 🌤️ HzClima

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
  <img src="https://img.shields.io/badge/WorkManager-Atualização%20horária-purple" alt="WorkManager" />
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License" />
</p>

---

## 📱 Screenshots

<p align="center">
  <img src="assets/screenshots/screenshot9.png" alt="Tela principal" width="220" />
  <img src="assets/screenshots/screenshot10.png" alt="Busca e favoritos" width="220" />
  <img src="assets/screenshots/screenshot11.png" alt="Widget e dark mode" width="220" />
</p>

<p align="center">
  <em>Home, busca/favoritos e experiência com widget e tema escuro.</em>
</p>

<p align="center">
  <img src="assets/screenshots/screenshot1.jpeg" alt="Screenshot 1" width="140" />
  <img src="assets/screenshots/screenshot2.jpg" alt="Screenshot 2" width="140" />
  <img src="assets/screenshots/screenshot3.png" alt="Screenshot 3" width="140" />
  <img src="assets/screenshots/screenshot4.jpg" alt="Screenshot 4" width="140" />
</p>

<p align="center">
  <img src="assets/screenshots/screenshot5.jpg" alt="Screenshot 5" width="140" />
  <img src="assets/screenshots/screenshot6.png" alt="Screenshot 6" width="140" />
  <img src="assets/screenshots/screenshot7.png" alt="Screenshot 7" width="140" />
  <img src="assets/screenshots/screenshot8.jpg" alt="Screenshot 8" width="140" />
</p>

---

## ✨ Funcionalidades

* 🌦️ **Clima em tempo real** via [Open-Meteo](https://open-meteo.com/) — sem API key
* 🔎 **Busca por cidade** com autocomplete e debounce
* 📍 **Localização atual** utilizando GPS e reverse geocoding
* 📅 **Previsão de 5 dias**
* 🕐 **Previsão das próximas 24 horas**

  * Horário de cada previsão
  * Temperatura
  * Condição climática
  * Probabilidade de chuva
  * Destaque visual para o horário atual
* 💧 **Métricas meteorológicas**

  * Umidade
  * Sensação térmica
  * Precipitação
  * Velocidade do vento
* 🌡️ **Alternância entre °C e °F** com persistência local
* ⭐ **Favoritos de cidades** utilizando SharedPreferences
* 📱 **Widget na tela inicial do Android** utilizando `home_widget`

  * Pin do widget pelo aplicativo, quando permitido pelo sistema
  * Atualização automática a cada hora
  * WorkManager + worker nativo em Kotlin
  * Coordenadas e unidade persistidas para execução em background
  * Exibição de temperatura, sensação térmica, condição climática, cidade e horário da última atualização
  * Ícone meteorológico adaptado às condições atuais
  * 🌙 **Representação da fase da Lua durante a noite**, quando aplicável
* 🌓 **Tema claro, escuro e baseado no sistema**
* 🎨 **Material Design 3**
* 🚀 **Splash screen animada** com branding
* 🔄 **Pull-to-refresh** para atualização manual
* ⚠️ **Mensagens de erro amigáveis**

  * Sem internet
  * Timeout
  * Cidade não encontrada
  * Permissões
* 🔙 **Botão voltar inteligente**

  * Fecha teclado/sugestões primeiro
  * Dois toques para sair
* ✨ **Animações**

  * Loading
  * Transições
  * Splash
* 📦 **Build release Android** com R8/ProGuard e regras específicas para WorkManager

---

# 🛠️ Stack & Competências

## 💻 Linguagens e Frameworks

| Tecnologia            | Uso no projeto                               |
| --------------------- | -------------------------------------------- |
| **Dart 3**            | Linguagem principal                          |
| **Flutter**           | Desenvolvimento da interface multiplataforma |
| **Material Design 3** | Design system, temas e componentes           |

---

## 🏗️ Arquitetura

| Competência                        | Aplicação                                                      |
| ---------------------------------- | -------------------------------------------------------------- |
| **Arquitetura em camadas**         | `models`, `services`, `providers`, `pages`, `widgets`, `utils` |
| **State Management**               | Provider + ChangeNotifier                                      |
| **Separação de responsabilidades** | UI desacoplada da lógica de negócio e das APIs                 |
| **Helpers**                        | `WeatherCodeHelper` para ícones, textos e gradientes           |

---

## 🌐 Dados e Rede

| Competência                     | Aplicação                                                   |
| ------------------------------- | ----------------------------------------------------------- |
| **API REST**                    | Comunicação HTTP + JSON                                     |
| **Open-Meteo Forecast**         | Clima atual e previsões diária e horária                    |
| **Open-Meteo Geocoding**        | Busca e autocomplete de cidades                             |
| **Reverse Geocoding**           | Conversão de coordenadas em nome da cidade                  |
| **Previsão horária**            | Consulta e processamento das próximas 24 horas              |
| **Tratamento de erros de rede** | `SocketException`, `TimeoutException` e mensagens amigáveis |

---

## 📱 Dispositivo, Widget e Persistência

| Competência                    | Aplicação                                                    |
| ------------------------------ | ------------------------------------------------------------ |
| **Geolocalização**             | `geolocator` + gerenciamento de permissões                   |
| **Persistência local**         | SharedPreferences para favoritos e unidade                   |
| **Home Screen Widget**         | `home_widget` + `WeatherHomeWidgetProvider` em Kotlin        |
| **Atualização em background**  | WorkManager + `WeatherUpdateWorker` em Kotlin                |
| **Integração Flutter/Android** | Comunicação entre Flutter e código nativo Kotlin             |
| **Datas e localização**        | `intl` com suporte a `pt_BR`                                 |
| **Informações astronômicas**   | Cálculo da fase da Lua utilizado pelo widget durante a noite |

---

## 🎨 UX / UI

| Competência              | Aplicação                              |
| ------------------------ | -------------------------------------- |
| **Animações**            | Fade, Slide e Scale                    |
| **Estados de UI**        | Loading, erro e conteúdo               |
| **Autocomplete**         | Debounce nas sugestões                 |
| **Favoritos**            | Chips de acesso rápido                 |
| **Previsão horária**     | Lista horizontal das próximas 24 horas |
| **Gradientes dinâmicos** | Card adaptado à condição climática     |
| **Navegação Android**    | `PopScope` + duplo toque para sair     |
| **Widget dinâmico**      | Informações meteorológicas atualizadas |

---

## 🧪 Qualidade e Boas Práticas

| Competência                        | Aplicação                                                          |
| ---------------------------------- | ------------------------------------------------------------------ |
| **Null Safety**                    | Dart null-safe                                                     |
| **Widgets reutilizáveis**          | `WeatherCard`, `ForecastList`, `HourlyForecastList`, `ErrorViewer` |
| **Testabilidade**                  | `http.Client` injetável para utilização de mocks                   |
| **Release Android**                | Minificação, R8 e ProGuard                                         |
| **Ciclo de vida**                  | Checks de `mounted` e `dispose`                                    |
| **Separação de responsabilidades** | Serviços, providers e componentes independentes                    |

---

# 📁 Estrutura do Projeto

```text
lib/
├── main.dart
├── models/
│   └── weather_model.dart
│       ├── WeatherModel
│       ├── DailyForecast
│       ├── HourlyForecast
│       └── CitySuggestion
│
├── services/
│   ├── weather_service.dart
│   │   └── API, geocoding e localização
│   │
│   └── widget_service.dart
│       └── Dados do widget e pin
│
├── providers/
│   └── weather_provider.dart
│       └── Estado global com Provider
│
├── pages/
│   ├── splash_page.dart
│   └── home_page.dart
│
├── widgets/
│   ├── weather_card.dart
│   ├── forecast_list.dart
│   ├── hourly_forecast_list.dart
│   └── error_viewer.dart
│
└── utils/
    └── weather_code_helper.dart
        └── Ícones, textos e gradientes

android/app/src/main/
├── AndroidManifest.xml
│
├── kotlin/.../weather_app/
│   ├── MainActivity.kt
│   ├── WeatherHomeWidgetProvider.kt
│   │   └── Provider do widget
│   │
│   └── WeatherUpdateWorker.kt
│       └── Atualização horária em background
│
└── res/
    ├── layout/
    │   └── weather_home_widget.xml
    │
    └── xml/
        └── weather_home_widget_info.xml
```

---

# 🚀 Como Rodar

## 📋 Pré-requisitos

* Flutter SDK **3.13+**
* Dart compatível com a versão instalada do Flutter
* Android Studio e/ou Xcode
* Emulador ou dispositivo físico
* Git

---

## 📥 Clonar o projeto

```bash
git clone https://github.com/othongustavo99/weather-app.git
cd weather-app
flutter pub get
```

---

## ▶️ Executar

```bash
flutter run
```

---

# 📦 Build Release — Android

Para gerar uma versão de produção:

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

> A configuração de release utiliza R8/ProGuard e regras específicas para manter o funcionamento do WorkManager e do widget Android.

---

# 🔐 Permissões

## Android

Arquivo:

```text
android/app/src/main/AndroidManifest.xml
```

Permissões utilizadas:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

### Finalidade

| Permissão                | Finalidade                                                  |
| ------------------------ | ----------------------------------------------------------- |
| `INTERNET`               | Comunicação com as APIs meteorológicas                      |
| `ACCESS_FINE_LOCATION`   | Obtenção da localização precisa                             |
| `ACCESS_COARSE_LOCATION` | Obtenção de localização aproximada                          |
| `RECEIVE_BOOT_COMPLETED` | Permite que o sistema reagende tarefas após reinicialização |

---

## 🍎 iOS

Arquivo:

```text
ios/Runner/Info.plist
```

Configuração de localização:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Precisamos da sua localização para mostrar o clima local.</string>
```

---

# 🔌 APIs Utilizadas

| API                                                                  | Função                                   | Autenticação |
| -------------------------------------------------------------------- | ---------------------------------------- | ------------ |
| [Open-Meteo Forecast](https://open-meteo.com/)                       | Clima atual e previsões diária e horária | Sem API key  |
| [Open-Meteo Geocoding](https://open-meteo.com/en/docs/geocoding-api) | Busca e autocomplete de cidades          | Sem API key  |
| **BigDataCloud**                                                     | Reverse geocoding — coordenadas → cidade | Sem API key  |

---

# 📦 Principais Dependências

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

> As versões efetivamente utilizadas pelo projeto podem ser consultadas no `pubspec.lock`.

No Android nativo, o projeto também utiliza:

```text
androidx.work:work-runtime-ktx
```

para o agendamento das atualizações do widget.

---

# 🧩 Widget e Atualização em Background

O widget da tela inicial funciona integrado ao Flutter e ao código nativo Android.

### Fluxo

```text
Flutter
   │
   ├── Dados meteorológicos
   ├── Cidade
   ├── Temperatura
   ├── Sensação térmica
   ├── Descrição
   ├── Latitude
   ├── Longitude
   └── Unidade
        │
        ▼
   home_widget
        │
        ▼
WeatherHomeWidgetProvider
        │
        ▼
   Widget Android
```

### Informações exibidas

O widget apresenta de forma compacta:

* Cidade atual
* Temperatura
* Sensação térmica
* Condição climática
* Ícone meteorológico
* Horário da última atualização
* Identidade visual do HzClima

Durante o período noturno, determinadas condições climáticas podem utilizar uma representação da **fase atual da Lua**, calculada pelo código nativo Android.

### Atualização automática

O widget é atualizado automaticamente através do **WorkManager**.

A cada execução, o `WeatherUpdateWorker`:

1. Lê as coordenadas armazenadas.
2. Recupera a unidade configurada.
3. Consulta a API Open-Meteo.
4. Atualiza os dados meteorológicos.
5. Salva os novos dados no armazenamento local.
6. Atualiza todos os widgets ativos.

As coordenadas somente são armazenadas quando existem valores válidos, evitando falhas durante a execução em background.

> ⚠️ Em alguns dispositivos Android, mecanismos como economia de bateria e Doze podem atrasar a execução. Portanto, o intervalo de 1 hora representa o agendamento mínimo desejado, não uma garantia de execução exatamente a cada 60 minutos.

---

# 🕐 Previsão das Próximas 24 Horas

O HzClima também apresenta uma previsão horária detalhada para as próximas 24 horas.

Os dados são obtidos através da API **Open-Meteo Forecast** e processados pelo modelo `HourlyForecast`.

Para cada horário, o aplicativo pode apresentar:

* 🕐 Horário da previsão
* 🌡️ Temperatura
* 🌦️ Condição climática
* 🌧️ Probabilidade de precipitação
* 📍 Destaque para o momento atual

A previsão é apresentada em uma lista horizontal, permitindo consultar rapidamente a evolução das condições climáticas ao longo do dia.

Essa funcionalidade complementa a previsão diária de 5 dias, oferecendo uma visão mais precisa das condições meteorológicas no curto prazo.

---

# 🧪 Testes

Para executar os testes:

```bash
flutter test
```

A estrutura atual de testes contempla:

* **Models**
* **Services**
* **Widgets**
* **Testes de requisições HTTP**
* **Mock de `http.Client`** para isolamento das chamadas de rede

O projeto utiliza injeção de dependência no cliente HTTP para facilitar a criação de mocks e tornar os serviços mais testáveis.

---

# 🎯 Objetivos de Aprendizado

O HzClima foi desenvolvido como projeto de estudo e portfólio, reunindo diferentes conceitos de desenvolvimento mobile.

### Principais conhecimentos aplicados

1. Desenvolvimento de um aplicativo Flutter completo
2. Integração com APIs REST públicas
3. Consumo e tratamento de JSON
4. Previsão meteorológica diária e horária
5. Tratamento de erros de rede
6. State Management com **Provider**
7. Persistência local com **SharedPreferences**
8. Geolocalização e gerenciamento de permissões
9. Comunicação entre Flutter e Android nativo
10. Desenvolvimento de **Home Screen Widget**
11. Atualização em background utilizando **WorkManager**
12. Material Design 3
13. Temas claro, escuro e sistema
14. Animações e transições
15. Gerenciamento dos estados de loading, erro e conteúdo
16. Testes unitários e testes de widgets
17. Build de produção para Android
18. R8 e ProGuard
19. Organização arquitetural em camadas
20. Separação de responsabilidades
21. Integração com código nativo utilizando Kotlin
22. Processamento de dados meteorológicos horários
23. Implementação de comportamento dinâmico para o widget
24. Boas práticas de ciclo de vida no Flutter

---

# 💼 Portfólio

O **HzClima** foi desenvolvido para ir além de um simples projeto de consumo de API.

O aplicativo reúne, em um único projeto:

* 🌐 Consumo de APIs REST reais
* 🏗️ Arquitetura organizada em camadas
* 🔄 Gerenciamento de estado com Provider
* 💾 Persistência local
* 📍 Geolocalização
* 🕐 Previsão meteorológica horária
* 📱 Integração com funcionalidades nativas do Android
* 🧩 Home Screen Widget
* ⚙️ Execução em background com WorkManager
* 🎨 Material Design 3
* 🌓 Dark Mode
* 🌙 Representação da fase da Lua no widget
* ✨ Animações
* ⚠️ Tratamento de erros
* 🧪 Testes
* 📦 Build de produção
* 🔐 Configuração de permissões
* 🛡️ R8/ProGuard

O projeto representa uma aplicação prática de conceitos estudados durante o desenvolvimento mobile com **Flutter e Dart**, além da integração com recursos nativos do Android utilizando **Kotlin**.

---

# 📄 Licença

Este projeto está sob a licença **MIT**.

Você pode utilizar, estudar, modificar e adaptar o código de acordo com os termos da licença.

---

<p align="center">
  Desenvolvido com Flutter 💙
</p>

<p align="center">
  <strong>HzClima</strong> — clima de forma simples, rápida e inteligente.
</p>
