import 'package:bydelivery/models/avaliacao.dart';
import 'package:flutter/material.dart';

class CardAvaliacao extends StatefulWidget {
  final Avaliacao avaliacao;

  const CardAvaliacao(this.avaliacao, {super.key});

  @override
  State<CardAvaliacao> createState() => _CardAvaliacaoState();
}

class _CardAvaliacaoState extends State<CardAvaliacao> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image(
                fit: BoxFit.fitWidth,
                width: 40,
                image: AssetImage(widget.avaliacao.avatar),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(widget.avaliacao.usuario),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 20, 0, 0),
            child: Row(children: [
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    Icon(
                      Icons.star,
                      color: widget.avaliacao.rating >= i
                          ? Colors.yellow
                          : Colors.grey,
                      size: 17,
                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(widget.avaliacao.data, textScaleFactor: 0.7),
              )
            ]),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  Text(
                    widget.avaliacao.cometario,
                    textAlign: TextAlign.start,
                  )
                ],
              ))
        ],
      ),
    ));
  }
}
