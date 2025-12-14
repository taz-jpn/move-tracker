import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/score_provider.dart';
import 'map_screen.dart';
import 'score_screen.dart';
import 'history_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    MapScreen(),
    ScoreScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          // タブ切り替え時にデータを最新化
          if (index == 1) {
            // スコア画面
            ref.invalidate(scoreSummaryProvider);
            ref.invalidate(earnedMedalTypesProvider);
          } else if (index == 2) {
            // 履歴画面
            ref.invalidate(sessionHistoryProvider);
          }
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: AppLocalizations.of(context)!.tabMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: AppLocalizations.of(context)!.tabScore,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: AppLocalizations.of(context)!.tabHistory,
          ),
        ],
      ),
    );
  }
}
