import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/error_viewer.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  DateTime? _lastBackPress;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _cityController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<WeatherProvider>().searchSuggestions(_cityController.text);
    });
  }

  /// Lógica do botão voltar
  void _handleBack(WeatherProvider provider) {
    // 1) Teclado aberto ou sugestões visíveis → só fecha
    if (_focusNode.hasFocus || provider.suggestions.isNotEmpty) {
      _focusNode.unfocus();
      provider.clearSuggestions();
      return;
    }

    // 2) Dois toques para sair
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pressione voltar novamente para sair'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Segundo toque dentro de 2s → fecha o app
    SystemNavigator.pop();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cityController.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<WeatherProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(provider);
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HzClima',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            'Consulte o tempo em qualquer lugar',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white60 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: provider.isLoading ? null : () => provider.toggleUnit(),
                      child: Text(
                        provider.useFahrenheit ? '°F' : '°C',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      onPressed: provider.isLoading ? null : () => provider.loadByLocation(),
                      icon: const Icon(Icons.my_location_rounded),
                      tooltip: 'Usar minha localização',
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                  ),
                  child: TextField(
                    controller: _cityController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      provider.clearSuggestions();
                      provider.loadByCity(value);
                    },
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ex: São Paulo, Lisboa, Tokyo...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey.shade400,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark ? Colors.white54 : Colors.grey.shade500,
                      ),
                      suffixIcon: provider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.arrow_forward_rounded),
                              onPressed: () {
                                provider.clearSuggestions();
                                provider.loadByCity(_cityController.text);
                              },
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),

                // Autocomplete
                if (provider.suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: provider.suggestions.map((s) {
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.location_on_outlined, size: 20),
                          title: Text(s.displayName, style: const TextStyle(fontSize: 14)),
                          onTap: () {
                            _cityController.text = s.name;
                            _focusNode.unfocus();
                            provider.loadBySuggestion(s);
                          },
                        );
                      }).toList(),
                    ),
                  ),

                // Favoritos
                if (provider.favorites.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.favorites.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final fav = provider.favorites[index];
                        return InputChip(
                          label: Text(fav, style: const TextStyle(fontSize: 13)),
                          onPressed: () {
                            _cityController.text = fav;
                            provider.loadByCity(fav);
                          },
                          onDeleted: () => provider.removeFavorite(fav),
                          deleteIconColor: isDark ? Colors.white54 : Colors.grey,
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildContent(isDark, provider),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, WeatherProvider provider) {
    if (provider.isLoading) {
      return _buildLoading(isDark, key: const ValueKey('loading'));
    }

    if (provider.errorMessage != null) {
      return ErrorViewer(
        key: const ValueKey('error'),
        message: provider.errorMessage!,
        onRetry: () => provider.refresh(),
      );
    }

    if (provider.weather != null) {
      return RefreshIndicator(
        key: const ValueKey('weather'),
        onRefresh: provider.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              WeatherCard(
                weather: provider.weather!,
                cityName: provider.cityName,
                unitSymbol: provider.unitSymbol,
              ),
              const SizedBox(height: 28),
              ForecastList(forecasts: provider.weather!.dailyForecast),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return Center(
      key: const ValueKey('empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset('assets/icon/icon.jpg', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Bem-vindo ao HzClima!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Pesquise uma cidade ou\nuse sua localização atual',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white54 : Colors.grey.shade500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(bool isDark, {Key? key}) {
    return Center(
      key: key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(
                Icons.cloud_queue_rounded,
                size: 42,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Buscando o clima...',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}