
import 'package:flutter/material.dart';
import 'package:kids/core/audio/sound_manager.dart';
import 'package:kids/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:provider/provider.dart';

class DailyLoginPopup extends StatelessWidget {
  const DailyLoginPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orangeAccent, width: 4),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Daily Reward!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Come back every day!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  
                  // Days Grid - Responsive Wrap
                  Consumer<RewardsProvider>(
                    builder: (context, prov, _) {
                      final currentStreak = prov.currentStreak;
                      final dayInCycle = (currentStreak - 1) % 7 + 1;
                      
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(7, (index) {
                          final day = index + 1;
                          final isToday = day == dayInCycle;
                          final isPast = day < dayInCycle;
                          final isBigPrize = day == 7;
                          
                          return _buildDayItem(day, isToday, isPast, isBigPrize);
                        }),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Claim Button
                  Consumer<RewardsProvider>(
                    builder: (context, prov, _) {
                      final bool canClaim = prov.canClaimDailyReward;
                      
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: canClaim ? () {
                            SoundManager().playSuccess();
                            prov.claimDailyReward();
                            Navigator.of(context).pop();
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            disabledBackgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(
                            canClaim ? 'CLAIM!' : 'Come back tomorrow', 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: canClaim ? Colors.white : Colors.grey
                            )
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Floating Icon - Removed 'const' here
          Positioned(
            top: -40,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.orange.shade100,
                child: const Text('🎁', style: TextStyle(fontSize: 40)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(int day, bool isToday, bool isPast, bool isBigPrize) {
    Color bgColor = Colors.grey.shade100;
    Color borderColor = Colors.transparent;
    
    if (isPast) {
      bgColor = Colors.green.shade50;
      borderColor = Colors.green;
    } else if (isToday) {
      bgColor = Colors.amber.shade50;
      borderColor = Colors.amber;
    }

    // Slightly smaller cards to fit on smaller screens
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isToday ? 2 : 0),
        boxShadow: isToday ? [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 6)] : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Day $day', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          if (isPast)
            const Icon(Icons.check_circle, color: Colors.green, size: 24)
          else
            Text(isBigPrize ? '🎁' : '⭐', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            isBigPrize ? '100' : '${day * 5}', 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isToday ? Colors.deepOrange : Colors.black54)
          ),
        ],
      ),
    );
  }
}
