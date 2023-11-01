import 'package:bydelivery/pages/delivery_map/delivery_map_view.dart';
import 'package:flutter/material.dart';

class CardDelivey extends StatelessWidget {
  final bool isRed;
  final int countdown;
  const CardDelivey({super.key, this.countdown = 0, this.isRed = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Center(
              child: Text("Chegou uma nova entrega!",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const Divider(),
            const Row(children: [
              Text(
                'R\$ 10,69',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            const Row(children: [
              Icon(
                Icons.arrow_circle_up_rounded,
                color: Colors.greenAccent,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("6min"),
                        Text(" - "),
                        Text("1,7km"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Rua das Orquídias, 789. Candeias"),
                      ],
                    ),
                  ],
                ),
              )
            ]),
            const Row(children: [
              Icon(
                Icons.arrow_circle_down_rounded,
                color: Colors.amber,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("7min"),
                        Text(" - "),
                        Text("3,2km"),
                      ],
                    ),
                    Row(
                      children: [Text("Rua Apollo 11, 34. Centro")],
                    ),
                  ],
                ),
              ),
            ]),
            FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      if (countdown > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DeliveryMapView()),
                        );
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Aceitar"),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: 1 - (countdown / 15),
                                    color: isRed ? Colors.red : Colors.green,
                                  ),
                                  countdown > 0
                                      ? Text(
                                          '$countdown s',
                                          style: TextStyle(
                                            color: isRed
                                                ? Colors.red
                                                : Colors.amber,
                                          ),
                                        )
                                      : const Text(
                                          "0 s",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
