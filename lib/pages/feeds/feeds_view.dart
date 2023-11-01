import 'dart:convert';

import 'package:bydelivery/components/card_avaliacao.dart';
import 'package:bydelivery/models/avaliacao.dart';
import 'package:bydelivery/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flat_list/flat_list.dart';

// ignore: must_be_immutable
class FeedsView extends StatefulWidget {
  int idAvaliacao = 5;
  Usuario? usuario;

  FeedsView({super.key, this.usuario});

  @override
  State<FeedsView> createState() => _FeedsViewState();
}

class _FeedsViewState extends State<FeedsView> {
  int page = 1;
  int pageSize = 5;

  bool isLoading = true;

  List<Avaliacao> _avaliacoes = [];

  final TextEditingController commentController = TextEditingController();

  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    loadAvaliacoes();
  }

  // Método para carregar avaliações a partir de um arquivo JSON
  Future<void> loadAvaliacoes() async {
    setState(() {
      isLoading = true; // Mostrar a tela de carregamento
    });
    try {
      await Future.delayed(const Duration(seconds: 1));
      // Simule o carregamento do JSON a partir de um arquivo
      final jsonString = await rootBundle.loadString('assets/json/feeds.json');
      final jsonData = json.decode(jsonString.toString());

      List<Avaliacao> novasAvaliacoes = List.from(
        jsonData.map((avaliacao) => Avaliacao.fromJson(avaliacao)),
      );

      int totalReviewsLoading = page * pageSize;

      if (totalReviewsLoading > novasAvaliacoes.length) {
        totalReviewsLoading = novasAvaliacoes.length;
      }

      if (_avaliacoes.length != novasAvaliacoes.length) {
        novasAvaliacoes =
            novasAvaliacoes.sublist(_avaliacoes.length, totalReviewsLoading);
        page += 1;
        _avaliacoes.addAll(novasAvaliacoes);
        // ignore: avoid_print
        print("Total feeds: ${_avaliacoes.length}");
      } else {
        // ignore: avoid_print
        print("Não há mais Feeds.");
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Ocultar a tela de carregamento
      });
    }
    setState(() {
      isLoading = false; // Ocultar a tela de carregamento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Avaliações'),
        ),
        body: FlatList(
            onRefresh: () async {
              setState(() {
                isLoading = true;
                _avaliacoes = [];
              });
              loadAvaliacoes();
              Future.delayed(const Duration(seconds: 2));
            },
            listEmptyWidget: _avaliacoes.isEmpty && !isLoading
                ? const Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          margin: EdgeInsets.all(30),
                          color: Colors.amber,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
                            child: Text("Não foram encontradas avaliações."),
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
            listHeaderWidget: widget.usuario != null
                ? componenteAvaliacao()
                : isLoading
                    ? const SizedBox()
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Faça login para enviar uma avaliação")
                          ],
                        )),
            // controller: scrollController,
            loading: isLoading,
            data: _avaliacoes,
            onEndReached: () {
              loadAvaliacoes();
            },
            buildItem: (item, index) {
              final review = _avaliacoes[index];
              return CardAvaliacao(review);
            }));
  }

  Widget componenteAvaliacao() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
          child: Container(
            alignment:
                Alignment.topLeft, // Define o alinhamento para a esquerda
            child: TextField(
              controller: commentController,
              textAlign: TextAlign.start,
              maxLines: 2,
              maxLength: 500,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.chat_outlined),
                hintText: 'Deixe aqui seu comentário...',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 10, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = i.toDouble();
                        });
                      },
                      child: Icon(
                        Icons.star,
                        color: _rating >= i ? Colors.yellow : Colors.grey,
                        size: 30,
                      ),
                    )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    addReview();
                  },
                  child: const Text("Enviar avaliação"))
            ],
          ),
        ),
      ],
    );
  }

  void addReview() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    widget.idAvaliacao++;
    final avaliacao = Avaliacao(
        widget.idAvaliacao,
        widget.usuario!.id,
        widget.usuario!.avatar,
        widget.usuario!.nome,
        _rating,
        commentController.text.trim(),
        formattedDate);
    setState(() {
      _avaliacoes.add(avaliacao);
      _avaliacoes.sort((a, b) => b.id.compareTo(a.id));
      commentController.clear();
      _rating = 0.0;
    });
  }
}
