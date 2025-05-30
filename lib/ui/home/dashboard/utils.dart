// ignore_for_file: library_private_types_in_public_api

import 'package:autowheel_workshop/utils/components/library.dart';
import 'package:fl_chart/fl_chart.dart';

class FileInfoCard extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;
  final int crossAxisCount;
  final double childAspectRatio;

  const FileInfoCard(
      {super.key,
      required this.dataList,
      this.crossAxisCount = 5,
      this.childAspectRatio = 2});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: dataList.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: Sizes.width * 0.015,
        crossAxisCount: crossAxisCount,
      ),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          pushTo(dataList[index]["path"]);
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                dataList[index]["image"],
                height: 45,
                width: 45,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dataList[index]["title"],
                    overflow: TextOverflow.ellipsis,
                    style:
                        rubikTextStyle(20, FontWeight.w500, AppColor.colBlack),
                  ),
                  Text(
                    dataList[index]["subtitle"],
                    overflow: TextOverflow.ellipsis,
                    style:
                        rubikTextStyle(11, FontWeight.w500, AppColor.colBlack),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InteractivePieChart extends StatefulWidget {
  const InteractivePieChart({super.key});

  @override
  _InteractivePieChartState createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart> {
  List<Map<String, dynamic>> data = [
    {'title': '', 'value': 0.0},
    {'title': 'A', 'value': 30.0},
    {'title': 'B', 'value': 45.0},
    {'title': 'C', 'value': 25.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding:
          EdgeInsets.symmetric(vertical: Sizes.height * 0.03, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColor.colWhite, borderRadius: BorderRadius.circular(10)),
      child: PieChart(
        PieChartData(
          sections: data.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return PieChartSectionData(
              color: Colors.primaries[index % Colors.primaries.length],
              value: data['value'],
              title: data['title'],
              radius: 60,
              titleStyle:
                  rubikTextStyle(15, FontWeight.w500, AppColor.colBlack),
              // onTap: () {
              //   setState(() {
              //     selectedIndex = index;
              //   });
              // },
            );
          }).toList(),
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}

class MonthlySalesChart extends StatelessWidget {
  const MonthlySalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    List<List<FlSpot>> lineChartData = [
      [
        const FlSpot(0.2, 21),
        const FlSpot(3, 15),
        const FlSpot(4, 20),
        const FlSpot(5, 31),
        const FlSpot(8, 12)
      ],
      [
        const FlSpot(1, 12),
        const FlSpot(1.2, 1),
        const FlSpot(2, 32),
        const FlSpot(4, 12),
        const FlSpot(6, 67)
      ],
      [
        const FlSpot(2, 23),
        const FlSpot(2.4, 43),
        const FlSpot(4, 42),
        const FlSpot(4.1, 56),
        const FlSpot(4.7, 34)
      ],
      [
        const FlSpot(0, 8),
        const FlSpot(1, 12),
        const FlSpot(2, 18),
        const FlSpot(3, 23),
        const FlSpot(4, 6),
      ],
    ];

    return Container(
        height: 250,
        padding:
            EdgeInsets.symmetric(vertical: Sizes.height * 0.03, horizontal: 20),
        decoration: BoxDecoration(
            color: AppColor.colWhite, borderRadius: BorderRadius.circular(10)),
        child: LineChart(
          LineChartData(
            lineBarsData: lineChartData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return LineChartBarData(
                spots: data,
                isCurved: true,
                color: Colors.primaries[
                    index % Colors.primaries.length], // Assign different colors
                dotData: const FlDotData(show: true),
              );
            }).toList(),
            titlesData: const FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 30,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            gridData: const FlGridData(show: true),
          ),
        ));
  }
}
