// import 'package:autowheel_workshop/utils/components/library.dart';

// class BranchMaster extends StatefulWidget {
//   const BranchMaster({super.key});

//   @override
//   State<BranchMaster> createState() => _BranchMasterState();
// }

// class _BranchMasterState extends State<BranchMaster>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   // Callback function to switch to the first tab
//   void switchToFirstTab() {
//     _tabController.animateTo(0);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: (!Responsive.isDesktop(context))
//               ? IconButton(
//                   onPressed: context.read<MenuControlle>().controlMenu,
//                   icon: const Icon(Icons.menu))
//               : Container(),
//           centerTitle: true,
//           title: const Text("Branch Master", overflow: TextOverflow.ellipsis),
//           bottom: TabBar(
//             controller: _tabController,
//             indicator: BoxDecoration(color: AppColor.colBlack.withOpacity(.2)),
//             tabs: const [
//               Tab(text: 'Branch List'),
//               Tab(text: 'Make Branch'),
//             ],
//           ),
//           backgroundColor: AppColor.colPrimary),
//       backgroundColor: AppColor.colPrimary.withOpacity(.2),
//       body: TabBarView(
//         controller: _tabController,
//         children: const [
//           BranchListClass(),
//           AddBranch(
//               // switchToFirstTab: switchToFirstTab,
//               // isFirst: true,
//               )
//         ],
//       ),
//     );
//   }
// }
