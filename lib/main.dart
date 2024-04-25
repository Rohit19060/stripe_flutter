import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:king_cache/king_cache.dart';
import 'package:stripe_template/constants.dart';
import 'package:stripe_template/model/payment_method.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51LQbDxSA4Qahl4YHrMM6xrtMWAZQtMhsKhj6r94jR2Pl9h0AP72VAJUtNXzNMXR7h9c1nC4W9x1tIFNjjHuX6GyV00ZbUOf2LG";
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Template',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StripeHome(),
    );
  }
}

class StripeHome extends StatefulWidget {
  const StripeHome({super.key});

  @override
  State<StripeHome> createState() => _StripeHomeState();
}

class _StripeHomeState extends State<StripeHome> {
  List<PaymentMethodCustom> paymentMethods = [];

  @override
  void initState() {
    super.initState();
    getCards().then((value) {
      setState(() {
        paymentMethods = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Template'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await addCard();
              getCards().then((value) {
                setState(() {
                  paymentMethods = value;
                });
              });
            },
            child: const Text('Add Card'),
          ),
          ElevatedButton(
            onPressed: () {
              checkout(paymentMethods.first);
            },
            child: const Text('Pay with Stripe'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final paymentMethod = paymentMethods[index];
                return ListTile(
                  onLongPress: () {
                    updateCard(paymentMethod);
                  },
                  onTap: () async {
                    await removeCard(paymentMethod.id);
                    getCards().then((value) {
                      setState(() {
                        paymentMethods = value;
                      });
                    });
                  },
                  title: Text("Brand: ${paymentMethod.card.brand}"),
                  subtitle: Text("Last 4 Digit: ${paymentMethod.card.last4}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> updateCard(PaymentMethodCustom method) async {
  final res = await KingCache.networkRequest('$url/update_card/${method.id}');
  if (!res.status) {
    return;
  }

  final setupIntentSecret = res.data['setupIntent'].toString();
  final ephemeralKey = res.data['ephemeralKey'].toString();
  final customerId = res.data['customerId'].toString();

  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      merchantDisplayName: 'Stripe Template',
      setupIntentClientSecret: setupIntentSecret,
      customerId: customerId,
      customerEphemeralKeySecret: ephemeralKey,
      googlePay: const PaymentSheetGooglePay(
        merchantCountryCode: 'DE',
        testEnv: true,
      ),
      billingDetails: const BillingDetails(
          name: 'Rohit Jain', email: "rohitjain19060@gmail.com"),
    ),
  );
  await Stripe.instance.presentPaymentSheet();
}

Future<void> removeCard(String id) async {
  final res = await KingCache.networkRequest('$url/remove_card/$id');
  if (!res.status) {
    return;
  }
}

Future<List<PaymentMethodCustom>> getCards() async {
  final res = await KingCache.networkRequest('$url/payment_methods');
  if (!res.status) {
    return [];
  }
  final cards = res.data["paymentMethods"]['data'] as List<dynamic>? ?? [];
  return cards.map((e) => PaymentMethodCustom.fromJson(e)).toList();
}

Future<void> addCard() async {
  final res = await KingCache.networkRequest('$url/add_card_initiate');
  if (!res.status) {
    return;
  }

  final setupIntentSecret = res.data['setupIntent'].toString();
  final ephemeralKey = res.data['ephemeralKey'].toString();
  final customerId = res.data['customerId'].toString();

  await Stripe.instance.initPaymentSheet(
    paymentSheetParameters: SetupPaymentSheetParameters(
      merchantDisplayName: 'Stripe Template',
      setupIntentClientSecret: setupIntentSecret,
      customerId: customerId,
      customerEphemeralKeySecret: ephemeralKey,
      googlePay: const PaymentSheetGooglePay(
        merchantCountryCode: 'DE',
        testEnv: true,
      ),
      billingDetails: const BillingDetails(
          name: 'Rohit Jain', email: "rohitjain19060@gmail.com"),
    ),
  );
  await Stripe.instance.presentPaymentSheet();
}

Future<void> checkout(PaymentMethodCustom method) async {
  final res = await KingCache.networkRequest('$url/checkout_initiate');
  if (!res.status) {
    return;
  }
  final paymentIntent = res.data['paymentIntent'].toString();
  await Stripe.instance.confirmPayment(
    paymentIntentClientSecret: paymentIntent,
    data: PaymentMethodParams.cardFromMethodId(
      paymentMethodData: PaymentMethodDataCardFromMethod(
        paymentMethodId: method.id,
      ),
    ),
  );
}
