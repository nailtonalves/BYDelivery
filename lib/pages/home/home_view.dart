import 'dart:async';
import 'dart:convert';
import 'package:bydelivery/components/card_delivery.dart';
import 'package:bydelivery/models/delivery.dart';
import 'package:bydelivery/models/usuario.dart';
import 'package:bydelivery/pages/feeds/feeds_view.dart';
import 'package:bydelivery/pages/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:bydelivery/pages/login/authentication.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  Usuario? user;
  HomeView({super.key, this.user});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  Delivery? _delivery;
  bool _showCardDelivery = false;
  bool isRed = false;
  int countdown = 0;
  late Timer _timer;

  StreamSubscription? _deliverySubscription;

  @override
  void initState() {
    super.initState();
    _showAvailableDelivery();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        isRed = false;
        _hideAvailableDelivery();
      } else {
        countdown--;
        if (countdown == 5) {
          isRed = true;
        }
        setState(() {});
      }
    });
  }

  void _hideAvailableDelivery() {
    _timer.cancel();
    setState(() {
      _showCardDelivery = false;
    });
    _showAvailableDelivery();
  }

  void _showAvailableDelivery() {
    Future.delayed(const Duration(seconds: 5), () {
      _showCardDelivery = true;
      countdown = 16;
      _startCountdown();
    });
  }

  @override
  void dispose() {
    _deliverySubscription?.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<List<Delivery>> loadDeliveries() async {
    // Simule o carregamento do JSON a partir de um arquivo
    final jsonString = rootBundle.loadString('assets/json/deliveries.json');
    final jsonData = json.decode(jsonString.toString());

    List<Delivery> deliveries = List.from(
      jsonData.map((delivery) => Delivery.fromJson(delivery)),
    );
    return deliveries;
  }

  // Future<void> showDeliveryAvailable() async {
  //   const deliveryInterval = Duration(seconds: 17);

  //   List<Delivery> deliveries = await loadDeliveries();

  //   _deliverySubscription = Stream.periodic(deliveryInterval, (count) {
  //     final deliveryIndex = count % deliveries.length;
  //     final delivery = deliveries[deliveryIndex];
  //     setState(() {
  //       _delivery = delivery;
  //       _showCardDelivery = true;
  //     });
  //   }).listen(null);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: const Text('Home'),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: GestureDetector(
                  onTap: () {
                    Authentication.logout();
                    // Esta função navega para a tela de login e limpa a pilha de telas
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.exit_to_app_rounded,
                    size: 32,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FeedsView(usuario: widget.user)),
                                );
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.comment),
                                  SizedBox(width: 8),
                                  Text("Fazer avaliação."),
                                ],
                              )),
                        )
                      ],
                    ),
                    const Card(
                      color: Colors.amber,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Row(children: [
                            Icon(Icons.savings),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Valor faturado até o momento")
                          ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "R\$",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                "56,39",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 80),
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              Text(
                                "Lorem ipsum haehuiae efiahe iefjf duis non commodo, dapibus inceptos aenean cras. ",
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                textScaleFactor: 0.9,
                              )
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Row(children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: AnimatedCrossFade(
                          sizeCurve: Curves.easeInOutCubic,
                          firstChild:
                              CardDelivey(countdown: countdown, isRed: isRed),
                          secondChild: const SizedBox(
                            height: 50,
                            child: Text("",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber)),
                          ),
                          crossFadeState: _showCardDelivery
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 500))),
                )
              ]),
            )
          ],
        ));
  }
}
