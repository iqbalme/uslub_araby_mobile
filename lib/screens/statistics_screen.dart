import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';
import 'package:uslub_araby/providers/saved_words_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final Map<String, bool> _achievements = {
    'pemula': false,
    'mahir': false,
    'ahli': false,
  };

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _achievements['pemula'] = prefs.getBool('achievement_pemula') ?? false;
      _achievements['mahir'] = prefs.getBool('achievement_mahir') ?? false;
      _achievements['ahli'] = prefs.getBool('achievement_ahli') ?? false;
    });
  }

  Future<void> _saveAchievement(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('achievement_$key', value);
    setState(() {
      _achievements[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Belajar')),
      body: Consumer2<UslubProvider, SavedWordsProvider>(
        builder: (context, uslubProvider, savedProvider, child) {
          final totalWords = uslubProvider.words.length;
          final savedWords = savedProvider.savedWords.length;

          // Check and update achievements
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (savedWords >= 10 && !_achievements['pemula']!) {
              _saveAchievement('pemula', true);
            }
            if (savedWords >= 50 && !_achievements['mahir']!) {
              _saveAchievement('mahir', true);
            }
            if (savedWords >= totalWords &&
                totalWords > 0 &&
                !_achievements['ahli']!) {
              _saveAchievement('ahli', true);
            }
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(
              16,
            ).copyWith(bottom: 100), // Extra bottom padding for navigation bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Belajar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Total Kata',
                        totalWords.toString(),
                        Icons.library_books,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Kata Tersimpan',
                        savedWords.toString(),
                        Icons.bookmark,
                        Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Progress Chart
                const Text(
                  'Progress Belajar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: savedWords.toDouble(),
                                  title: 'Tersimpan\n$savedWords',
                                  color: Colors.green,
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: (totalWords - savedWords).toDouble(),
                                  title: 'Belum\n${totalWords - savedWords}',
                                  color: Colors.grey[300]!,
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Persentase Kata yang Telah Dipelajari',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Achievement
                const Text(
                  'Pencapaian',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                _buildAchievementCard(
                  context,
                  'Pemula',
                  'Pelajari 10 kata pertama',
                  _achievements['pemula']!,
                  Icons.star_border,
                ),

                _buildAchievementCard(
                  context,
                  'Mahir',
                  'Pelajari 50 kata',
                  _achievements['mahir']!,
                  Icons.star_half,
                ),

                _buildAchievementCard(
                  context,
                  'Ahli',
                  'Pelajari semua kata',
                  _achievements['ahli']!,
                  Icons.star,
                ),

                const SizedBox(height: 24), // Extra padding at bottom
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    String title,
    String description,
    bool isAchieved,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: isAchieved ? Colors.amber : Colors.grey,
          size: 32,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isAchieved ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Text(description),
        trailing: isAchieved
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }
}
