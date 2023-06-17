import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('How to use this app?'),
          backgroundColor: const Color.fromARGB(255, 14, 34, 44)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "An EMI (Equated Monthly Installment) calculator is a useful tool that helps individuals and businesses determine the amount they need to pay each month towards a loan or mortgage.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  textAlign: TextAlign.justify,
                  "1.An EMI calculator is a financial tool designed to calculate the Equated Monthly Installment, which is the fixed amount borrowers need to pay towards a loan or mortgage.",
                  style: TextStyle(fontSize: 15)),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "2.By using an EMI calculator, borrowers can easily determine the affordability of a loan and plan their finances accordingly.",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "3.It takes into account factors such as the principal amount, interest rate, and loan tenure to calculate the EMI accurately.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "How to use:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.justify,
                "All you have to do is enter your principal amount, rate of interest and loan tenure in months. When you click on 'calculate EMI' button you will get Monthly EMI, Total interest and Total payment with graphical representation also.",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                textAlign: TextAlign.justify,
                "Remember, an EMI calculator is a valuable tool, but it's always recommended to consult with a financial advisor or lender for accurate and personalized loan calculations and advice.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red.shade600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
