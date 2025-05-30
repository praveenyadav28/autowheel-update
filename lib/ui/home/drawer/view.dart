import 'package:autowheel_workshop/ui/home/view/voucher/contra_view.dart';
import 'package:autowheel_workshop/ui/home/view/voucher/income_view.dart';
import 'package:autowheel_workshop/utils/components/library.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  List viewList = [
    {
      "text": "Purchase Invoice View",
      "Image": Images.purchaseInvoice,
      "path": PurchaseInvoiceView(reportType: false)
    },
    {
      "text": "Purchase Return View",
      "Image": Images.purchaseReturn,
      "path": PurchaseReturnView(reportType: false)
    },
    {
      "text": "Estimate View",
      "Image": Images.estimate,
      "path": EstimateView(reportType: false),
    },
    {
      "text": "Jobcard View",
      "Image": Images.jobcard,
      "path": JoborderMain(initialIndex: 0, reportType: false)
    },
    {
      "text": "Sale Invoice View",
      "Image": Images.saleInv,
      "path": DirectSale(reportType: false)
    },
    {
      "text": "Sale Return View",
      "Image": Images.saleRtn,
      "path": SaleReturnView(reportType: false)
    },
    {
      "text": "Payment View",
      "Image": Images.payment,
      "path": PaymentView(reportType: false)
    },
    {
      "text": "Reciept View",
      "Image": Images.reciept,
      "path": RecieptView(reportType: false)
    },
    {
      "text": "Income View",
      "Image": Images.income,
      "path": IncomeView(reportType: false),
    },
    {
      "text": "Expanse View",
      "Image": Images.expanse,
      "path": ExpanseView(reportType: false)
    },
    // {
    //   "text": "Credit Note View",
    //   "Image": Images.credit,
    //   "path": const CreditNote(),
    // },
    // {
    //   "text": "Debit Note View",
    //   "Image": Images.debitNote,
    //   "path": const DebitNote()
    // },
    {
      "text": "Contra View",
      "Image": Images.contra,
      "path": ContraView(reportType: false),
    },
    {
      "text": "Journal View",
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
        title: const Text("View Screen", overflow: TextOverflow.ellipsis),
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
            itemCount: viewList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      pushTo(viewList[index]["path"]);
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColor.colPrimary.withOpacity(.1),
                      ),
                      child:
                          Center(child: Image.asset(viewList[index]["Image"])),
                    ),
                  ),
                  SizedBox(height: Sizes.height * 0.02),
                  Text(viewList[index]["text"])
                ],
              );
            },
          )),
    );
  }
}
