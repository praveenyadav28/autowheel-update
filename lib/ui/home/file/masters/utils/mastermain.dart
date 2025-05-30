// ignore_for_file: must_be_immutable

import 'package:autowheel_workshop/utils/components/library.dart';

class MastersMain extends StatefulWidget {
  MastersMain(
      {super.key,
      required this.appbarTitle,
      required this.tabbarTitle1,
      required this.tabbarTitle2,
      required this.tabbarView1,
      required this.tabbarView2});
  String appbarTitle = "";
  String tabbarTitle1 = "";
  String tabbarTitle2 = "";
  Widget tabbarView1;
  Widget tabbarView2;
  @override
  State<MastersMain> createState() => _MastersMainState();
}

class _MastersMainState extends State<MastersMain>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Callback function to switch to the first tab
  void switchToFirstTab() {
    _tabController.animateTo(0);
  }

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
          leading: (!Responsive.isDesktop(context))
              ? IconButton(
                  onPressed: context.read<MenuControlle>().controlMenu,
                  icon: const Icon(Icons.menu))
              : Container(),
          centerTitle: true,
          title: Text(widget.appbarTitle, overflow: TextOverflow.ellipsis),
          bottom: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(color: AppColor.colBlack.withOpacity(.1)),
            tabs: [
              Tab(text: widget.tabbarTitle1),
              Tab(text: widget.tabbarTitle2),
            ],
          ),
          backgroundColor: AppColor.colPrimary),
      backgroundColor: AppColor.colPrimary.withOpacity(.1),
      body: TabBarView(
        controller: _tabController,
        children: [
          widget.tabbarView1,
          widget.tabbarView2,
          // PartListClass(switchToSecondTab: switchToSecondTab),
          // AddParts(switchToFirstTab: switchToFirstTab),
        ],
      ),
    );
  }
}
