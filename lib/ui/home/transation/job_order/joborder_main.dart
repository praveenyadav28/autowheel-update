// ignore_for_file: must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';

class JoborderMain extends StatefulWidget {
  JoborderMain(
      {required this.initialIndex, required this.reportType, super.key});
  bool reportType = false;
  int initialIndex;
  @override
  State<JoborderMain> createState() => _JoborderMainState();
}

class _JoborderMainState extends State<JoborderMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        initialIndex: widget.initialIndex, length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("Job Order", overflow: TextOverflow.ellipsis),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            controller: _tabController,
            indicator: BoxDecoration(color: AppColor.colBlack.withOpacity(.1)),
            tabs: [
              Tab(
                text: '        Draft       ',
                icon: Image.asset(Images.spare, height: 24),
              ),
              Tab(
                text: '     In Progess     ',
                icon: Image.asset(Images.inworking, height: 24),
              ),
              Tab(
                text: '       On Hold      ',
                icon: Image.asset(Images.budget, height: 24),
              ),
              Tab(
                text: '        Ready       ',
                icon: Image.asset(Images.ready, height: 24),
              ),
              Tab(
                text: 'Vehicles Deliverd',
                icon: Image.asset(Images.delivery, height: 24),
              ),
            ],
          ),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: Container(
        color: AppColor.colPrimary.withOpacity(.1),
        child: TabBarView(
            controller: _tabController,
            children: List.generate(5, (i) {
              return Draft(status: i, reportType: widget.reportType);
            })),
      ),
    );
  }
}
