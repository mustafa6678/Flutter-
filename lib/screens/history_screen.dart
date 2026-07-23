import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final historyService = context.read<HistoryService>();
    final uid = auth.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Play History')),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : AppColors.lightBackgroundGradient,
        ),
        child: SafeArea(
          child: uid == null
              ? const Center(child: Text('Sign in to see your history.'))
              : StreamBuilder<List<MatchRecord>>(
                  stream: historyService.watchHistory(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Could not load history.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: isDark ? AppColors.goldBright : AppColors.black),
                        ),
                      );
                    }

                    final matches = snapshot.data ?? [];
                    if (matches.isEmpty) {
                      return Center(
                        child: Text(
                          'No games played yet.\nYour match history will show up here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: (isDark ? AppColors.goldBright : AppColors.black).withOpacity(0.6),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: matches.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _MatchTile(match: matches[index], isDark: isDark);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  final MatchRecord match;
  final bool isDark;

  const _MatchTile({required this.match, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.goldBright : AppColors.black;

    late final String resultLabel;
    late final Color resultColor;
    if (match.result == GameStatus.draw) {
      resultLabel = 'Draw';
      resultColor = AppColors.goldDeep;
    } else if (match.humanWon) {
      resultLabel = 'Win';
      resultColor = AppColors.success;
    } else {
      resultLabel = 'Loss';
      resultColor = AppColors.danger;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal : AppColors.creamCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldDeep.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              resultLabel,
              style: TextStyle(color: resultColor, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.mode.label,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM d, y · h:mm a').format(match.playedAt),
                  style: TextStyle(color: textColor.withOpacity(0.55), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
