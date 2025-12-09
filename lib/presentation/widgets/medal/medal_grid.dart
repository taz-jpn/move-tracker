import 'package:flutter/material.dart';
import '../../../data/models/medal.dart';

class MedalGrid extends StatelessWidget {
  final Set<MedalType> earnedMedals;

  const MedalGrid({
    super.key,
    required this.earnedMedals,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.military_tech, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'メダル',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${earnedMedals.length} / ${MedalType.values.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: MedalType.values.length,
              itemBuilder: (context, index) {
                final medalType = MedalType.values[index];
                final definition = MedalDefinitions.get(medalType);
                final isEarned = earnedMedals.contains(medalType);

                return _MedalItem(
                  definition: definition,
                  isEarned: isEarned,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MedalItem extends StatelessWidget {
  final MedalDefinition definition;
  final bool isEarned;

  const _MedalItem({
    required this.definition,
    required this.isEarned,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMedalInfo(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isEarned ? definition.color.withAlpha(51) : Colors.grey[200],
              shape: BoxShape.circle,
              border: Border.all(
                color: isEarned ? definition.color : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Icon(
              definition.icon,
              color: isEarned ? definition.color : Colors.grey[400],
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            definition.name,
            style: TextStyle(
              fontSize: 10,
              color: isEarned ? Colors.black87 : Colors.grey[400],
              fontWeight: isEarned ? FontWeight.w500 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showMedalInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isEarned ? definition.color.withAlpha(51) : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEarned ? definition.color : Colors.grey[300]!,
                  width: 3,
                ),
              ),
              child: Icon(
                definition.icon,
                color: isEarned ? definition.color : Colors.grey[400],
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              definition.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              definition.description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isEarned ? '獲得済み' : '未獲得',
              style: TextStyle(
                color: isEarned ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
