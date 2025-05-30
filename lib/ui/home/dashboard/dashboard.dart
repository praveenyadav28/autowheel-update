// ignore_for_file: unused_import, unnecessary_import, unused_label

// import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:autowheel_workshop/utils/components/library.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<Map<String, dynamic>> mattertypeList = [];
  List<Map<String, dynamic>> dashboardViewList = [];

  //JobcardNumber
  int draftCount = 0;
  int processCount = 0;
  int holdCount = 0;
  int readyCount = 0;
  int deliveredCount = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      fatchJobcardNumber().then((value) => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    dashboardViewList = [
      {
        "image": Images.totalvehicles,
        "title": "126",
        "subtitle": "Total Vehicles",
        'path': DirectSale(reportType: false),
      },
      {
        "image": Images.readydelivery,
        "title": "102",
        "subtitle": "Ready for Delivery",
        'path': DirectSale(reportType: false),
      },
      {
        "image": Images.directSale,
        "title": "16",
        "subtitle": "Invoice",
        'path': DirectSale(reportType: false),
      },
      {
        "image": Images.totalRecived,
        "title": "22",
        "subtitle": "Total Received",
        'path': DirectSale(reportType: false),
      },
    ];
    mattertypeList = [
      {
        'image': Images.spare,
        'subtitle': 'Drafted',
        'title': '$draftCount',
        'path': JoborderMain(initialIndex: 0, reportType: false),
      },
      {
        'image': Images.inworking,
        'subtitle': 'In Progress',
        'title': '$processCount',
        'path': JoborderMain(initialIndex: 1, reportType: false),
      },
      {
        'image': Images.budget,
        'subtitle': 'On Hold',
        'title': '$holdCount',
        'path': JoborderMain(initialIndex: 2, reportType: false),
      },
      {
        'image': Images.ready,
        'subtitle': 'Ready Vecile',
        'title': '$readyCount',
        'path': JoborderMain(initialIndex: 3, reportType: false),
      },
      {
        'image': Images.delivery,
        'subtitle': 'Vechile Delivered',
        'title': '$deliveredCount',
        'path': JoborderMain(initialIndex: 4, reportType: false),
      },
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.colPrimary,
        leading:
            (!Responsive.isDesktop(context))
                ? IconButton(
                  onPressed: context.read<MenuControlle>().controlMenu,
                  icon: const Icon(Icons.menu),
                )
                : Container(),
        centerTitle: true,
        title: const Text("Dashboard", overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        height: Sizes.height,
        color: AppColor.colPrimary.withOpacity(0.1),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Sizes.width * 0.04),
          child: Column(
            children: [
              SizedBox(height: Sizes.height * 0.03),
              Responsive(
                mobile: FileInfoCard(
                  dataList: dashboardViewList,
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                ),
                desktop: FileInfoCard(
                  dataList: dashboardViewList,
                  childAspectRatio: 2,
                  crossAxisCount: 4,
                ),
                tablet: FileInfoCard(
                  dataList: dashboardViewList,
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                ),
              ),
              SizedBox(height: Sizes.height * 0.04),
              Sizes.width < 800
                  ? Column(
                    children: [
                      const MonthlySalesChart(),
                      SizedBox(height: Sizes.height * 0.02),
                      const InteractivePieChart(),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 2, child: MonthlySalesChart()),
                      SizedBox(width: Sizes.width * 0.03),
                      const Expanded(flex: 1, child: InteractivePieChart()),
                    ],
                  ),
              SizedBox(height: Sizes.height * 0.04),
              Responsive(
                mobile: FileInfoCard(
                  dataList: mattertypeList,
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                ),
                desktop: FileInfoCard(
                  dataList: mattertypeList,
                  childAspectRatio: 1.8,
                  crossAxisCount: 5,
                ),
                tablet: FileInfoCard(
                  dataList: mattertypeList,
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            button(
              "Add Jobcard",
              AppColor.colPrimary,
              onTap: () async {
                var result = await pushTo(
                  JobCardScreen(jobcardNumber: 0, srNo: 0),
                );
                if (result.isNotEmpty) {
                  fatchJobcardNumber().then((value) => setState(() {}));
                }
              },
              width: Sizes.width * 0.3,
            ),
            const VerticalDivider(thickness: 2),
            button(
              "Invoice",
              AppColor.colPrimary,
              onTap: () {
                pushTo(
                  SaleInvoice(
                    invoiceNumber: 0,
                    saleIvoiceItems: const [],
                    jobcardNumber: 0,
                  ),
                );
              },
              width: Sizes.width * 0.3,
            ),
          ],
        ),
      ),
    );
  }

  //Get Jobcard Count
  Future fatchJobcardNumber() async {

    var datepickar1 = "${Preference.getString(PrefKeys.financialYear)}/04/01";
    var datepickar2 =
        "${int.parse(Preference.getString(PrefKeys.financialYear)) + 1}/03/31";
    draftCount = await ApiService.fetchData(
      "Transactions/GetJobCardCountALLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&jobclosestatus=0&datefrom=$datepickar1&dateto=$datepickar2",
    );
    processCount = await ApiService.fetchData(
      "Transactions/GetJobCardCountALLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&jobclosestatus=1&datefrom=$datepickar1&dateto=$datepickar2",
    );
    holdCount = await ApiService.fetchData(
      "Transactions/GetJobCardCountALLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&jobclosestatus=2&datefrom=$datepickar1&dateto=$datepickar2",
    );
    readyCount = await ApiService.fetchData(
      "Transactions/GetJobCardCountALLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&jobclosestatus=3&datefrom=$datepickar1&dateto=$datepickar2",
    );
    deliveredCount = await ApiService.fetchData(
      "Transactions/GetJobCardCountALLocationwiseAW?locationid=${Preference.getString(PrefKeys.locationId)}&jobclosestatus=4&datefrom=$datepickar1&dateto=$datepickar2",
    );
  }
}
