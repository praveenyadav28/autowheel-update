// ignore_for_file: must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';

class LedgerMaster extends StatefulWidget {
  LedgerMaster({required this.groupId, super.key});
  int groupId;
  @override
  State<LedgerMaster> createState() => _LedgerMasterState();
}

class _LedgerMasterState extends State<LedgerMaster>
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
          title: const Text("Ledger Master", overflow: TextOverflow.ellipsis),
          bottom: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(color: AppColor.colBlack.withOpacity(.2)),
            tabs: const [
              Tab(text: 'Make Ledger'),
              Tab(text: 'Ledger List'),
            ],
          ),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colWhite,
      body: TabBarView(
        controller: _tabController,
        children: [
          AddLedger(
              switchToSecondTab: switchToSecondTab,
              isFirst: true,
              groupId: widget.groupId),
          LedgerListClass(groupId: widget.groupId == 0 ? 9 : widget.groupId),
        ],
      ),
    );
  }
}
