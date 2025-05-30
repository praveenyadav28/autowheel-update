import 'package:autowheel_workshop/ui/home/view/voucher/contra_view.dart';
import 'package:autowheel_workshop/ui/home/view/voucher/income_view.dart';
import 'package:autowheel_workshop/utils/components/library.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List reportList = [
    {
      "text": "Purchase Invoice Report",
      "Image": Images.purchaseInvoice,
      "path": PurchaseInvoiceView(reportType: true)
    },
    {
      "text": "Purchase Return Report",
      "Image": Images.purchaseReturn,
      "path": PurchaseReturnView(reportType: true)
    },
    {
      "text": "Estimate Report",
      "Image": Images.estimate,
      "path": EstimateView(reportType: true),
    },
    {
      "text": "Jobcard Report",
      "Image": Images.jobcard,
      "path": JoborderMain(initialIndex: 0, reportType: true)
    },
    {
      "text": "Sale Invoice Report",
      "Image": Images.saleInv,
      "path": DirectSale(reportType: true)
    },
    {
      "text": "Sale Return Report",
      "Image": Images.saleRtn,
      "path": SaleReturnView(reportType: true)
    },
    {
      "text": "Payment Report",
      "Image": Images.payment,
      "path": PaymentView(reportType: true)
    },
    {
      "text": "Reciept Report",
      "Image": Images.reciept,
      "path": RecieptView(reportType: true)
    },
    {
      "text": "Income Report",
      "Image": Images.income,
      "path": IncomeView(reportType: true),
    },
    {
      "text": "Expanse Report",
      "Image": Images.expanse,
      "path": ExpanseView(reportType: true)
    },
    // {
    //   "text": "Credit Note Report",
    //   "Image": Images.credit,
    //   "path": const CreditNote(),
    // },
    // {
    //   "text": "Debit Note Report",
    //   "Image": Images.debitNote,
    //   "path": const DebitNote()
    // },
    {
      "text": "Contra Report",
      "Image": Images.contra,
      "path": ContraView(reportType: true),
    },
    {
      "text": "Journal Report",
      "Image": Images.journal,
      "path": const JournalScreen(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.colPrimary,
        leading: (!Responsive.isDesktop(context))
            ? IconButton(
                onPressed: context.read<MenuControlle>().controlMenu,
                icon: const Icon(Icons.menu))
            : Container(),
        centerTitle: true,
        title: const Text("Report Screen", overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColor.colPrimary.withOpacity(.1),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: Sizes.height * 0.02, horizontal: Sizes.width * .05),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (Responsive.isMobile(context)) ? 2 : 4),
            itemCount: reportList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      pushTo(reportList[index]["path"]);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColor.colPrimary.withOpacity(.1),
                      ),
                      child: Center(
                          child: Image.asset(reportList[index]["Image"])),
                    ),
                  ),
                  SizedBox(height: Sizes.height * 0.02),
                  Text(reportList[index]["text"])
                ],
              );
            },
          )),
    );
  }
}
