import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const PaymentPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_GcZZFDPP0jHtC4',
      'amount': 1000, // Amount in paise (1000 = ₹10)
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'timeout': 60, // in seconds
      'prefill': {
        'contact': '9876543210',
        'email': 'info@oneaim.in',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _showDialog("Success", "Payment successful! ID: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showDialog("Error", "Payment failed! Code: ${response.code}\nMessage: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showDialog("Wallet", "External wallet selected: ${response.walletName}");
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay ₹10 Razorpay")),
      body: Center(
        child: OutlinedButton(
          onPressed: openCheckout,
          child: const Text('Pay ₹10'),
        ),
      ),
    );
  }
}
