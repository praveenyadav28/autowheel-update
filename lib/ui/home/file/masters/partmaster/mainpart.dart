import 'package:autowheel_workshop/utils/components/library.dart';

class PartMaster extends StatefulWidget {
  const PartMaster({super.key});
  @override
  State<PartMaster> createState() => _PartMasterState();
}

class _PartMasterState extends State<PartMaster>
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
          title: const Text("Part Master", overflow: TextOverflow.ellipsis),
          bottom: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(color: AppColor.colBlack.withOpacity(.2)),
            tabs: const [
              Tab(text: 'Make Part'),
              Tab(text: 'Part List'),
            ],
          ),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: TabBarView(
        controller: _tabController,
        children: [
          AddParts(
            switchToSecondTab: switchToSecondTab,
            isFirst: true,
          ),
          const PartListClass(),
        ],
      ),
    );
  }
}
