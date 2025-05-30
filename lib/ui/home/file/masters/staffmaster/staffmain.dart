import 'package:autowheel_workshop/utils/components/library.dart';

class StaffMaster extends StatefulWidget {
  const StaffMaster({super.key});

  @override
  State<StaffMaster> createState() => _StaffMasterState();
}

class _StaffMasterState extends State<StaffMaster>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Callback function to switch to the first tab
  void switchToSecondTab() {
    _tabController.animateTo(1);
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
                Navigator.pop(context, "Update Data");
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("Staff Master", overflow: TextOverflow.ellipsis),
          bottom: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(color: AppColor.colBlack.withOpacity(.2)),
            tabs: const [
              Tab(text: 'Make Staff'),
              Tab(text: 'Staff List'),
            ],
          ),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: TabBarView(
        controller: _tabController,
        children: [
          AddStaffWidget(
            switchToSecondTab: switchToSecondTab,
            isFirst: true,
          ),
          const StaffList(),
        ],
      ),
    );
  }
}
