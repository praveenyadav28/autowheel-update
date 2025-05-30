import 'package:autowheel_workshop/utils/components/library.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List transactionList = [
    {
      "text": "Purchase Invoice",
      "Image": Images.purchaseInvoice,
      "path": PurchaseInvoice(invoiceNumber: 0)
    },
    {
      "text": "Purchase Return",
      "Image": Images.purchaseReturn,
      "path": PurchaseReturn(invoiceNumber: 0)
    },
    {
      "text": "Estimate",
      "Image": Images.estimate,
      "path": Estimate(items: const [], docNumber: 0),
    },
    {
      "text": "Jobcard",
      "Image": Images.jobcard,
      "path": JobCardScreen(jobcardNumber: 0, srNo: 0)
    },
    {
      "text": "Sale Invoice",
      "Image": Images.saleInv,
      "path": SaleInvoice(
          invoiceNumber: 0, saleIvoiceItems: const [], jobcardNumber: 0)
    },
    {
      "text": "Sale Return",
      "Image": Images.saleRtn,
      "path": SaleReturn(invoiceNumber: 0)
    },
    {
      "text": "Payment",
      "Image": Images.payment,
      "path": PaymentScreen(paymentVoucherNo: 0)
    },
    {
      "text": "Reciept",
      "Image": Images.reciept,
      "path": ReceiptScreen(reciptVoucherNo: 0)
    },
    {
      "text": "Income",
      "Image": Images.income,
      "path": IncomeVoucher(incomeVoucherNo: 0)
    },
    {
      "text": "Expanse",
      "Image": Images.expanse,
      "path": ExpanceVoucher(expanseVoucherNo: 0)
    },
    // {
    //   "text": "Credit Note",
    //   "Image": Images.credit,
    //   "path": const CreditNote(),
    // },
    // {
    //   "text": "Debit Note",
    //   "Image": Images.debitNote,
    //   "path": const DebitNote()
    // },
    {
      "text": "Contra",
      "Image": Images.contra,
      "path": ContraVoucher(contraVoucherNo: 0),
    },
    {
      "text": "Journal",
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
        title: const Text("Transaction", overflow: TextOverflow.ellipsis),
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
              crossAxisCount: (Responsive.isMobile(context)) ? 2 : 4,
            ),
            itemCount: transactionList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      pushTo(transactionList[index]["path"]);
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
                          child: Image.asset(transactionList[index]["Image"])),
                    ),
                  ),
                  SizedBox(height: Sizes.height * 0.02),
                  Text(transactionList[index]["text"])
                ],
              );
            },
          )),
    );
  }
}
