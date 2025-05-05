import 'package:api/providers/session_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SessionProvider>(context, listen: false).getSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Session"), backgroundColor: Colors.blue),
      body: Consumer<SessionProvider>(
        builder: (context, provider, _) {
          final userIds =
              provider.sessions.map((s) => s.user_id).toSet().toList();

          final filteredSessions =
              selectedUserId == null
                  ? []
                  : provider.sessions
                      .where((s) => s.user_id == selectedUserId)
                      .toList();

          Map<String, double> totalCorrect = {};
          Map<String, double> totalQuestion = {};

          for (var s in filteredSessions) {
            final part = s.part;
            final correct = double.tryParse(s.correct_answers) ?? 0;
            final total = double.tryParse(s.total_questions) ?? 0;

            totalCorrect[part] = (totalCorrect[part] ?? 0) + correct;
            totalQuestion[part] = (totalQuestion[part] ?? 0) + total;
          }

          List<BarChartGroupData> barGroups = [];
          int index = 0;
          totalCorrect.forEach((part, correct) {
            final total = totalQuestion[part] ?? 1;
            final percent = (correct / total) * 100;

            barGroups.add(
              BarChartGroupData(
                x: index++,
                barRods: [
                  BarChartRodData(
                    toY: percent,
                    width: 30,
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.green,
                  ),
                ],
              ),
            );
          });

          List<String> parts = totalCorrect.keys.toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("Chọn user_id"),
                  value: selectedUserId,
                  items:
                      userIds.map((id) {
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(id),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUserId = value;
                    });
                  },
                ),
              ),
              if (selectedUserId != null && barGroups.isNotEmpty)
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            titlesData: FlTitlesData(
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (double value, TitleMeta meta) {
                                    return Text('Part ${parts[value.toInt()]}',style: TextStyle(
                                      fontSize: 10
                                    ),);
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: true),
                            barTouchData: BarTouchData(enabled: true),
                            maxY: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else if (selectedUserId != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Không có dữ liệu để hiển thị."),
                ),
            ],
          );
        },
      ),
    );
  }
}
