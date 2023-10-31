import 'dart:convert';

import 'package:bydelivery/components/card_avaliacao.dart';
import 'package:bydelivery/components/loanding_screen.dart';
import 'package:bydelivery/models/avaliacao.dart';
import 'package:bydelivery/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class FeedsView extends StatefulWidget {
  int idAvaliacao = 5;
  Usuario? usuario;

  final List<Avaliacao> _avaliacoes = [];
  FeedsView({super.key, this.usuario});

  @override
  State<FeedsView> createState() => _FeedsViewState();
}

class _FeedsViewState extends State<FeedsView> {
  double _rating = 0;
  double newRating = 0.0;
  int page = 1;
  int pageSize = 5;
  bool isLoading = false;

  late ScrollController scrollController;

  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAvaliacoes();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print(scrollController.position.extentAfter);
    if (scrollController.position.extentAfter < pageSize) {
      loadAvaliacoes();
    }
  }

  // Método para carregar avaliações a partir de um arquivo JSON
  Future<void> loadAvaliacoes() async {
    setState(() {
      isLoading = true; // Mostrar a tela de carregamento
    });
    await Future.delayed(const Duration(seconds: 1));
    // Simule o carregamento do JSON a partir de um arquivo
    final jsonString = await rootBundle.loadString('assets/json/feeds.json');
    final jsonData = json.decode(jsonString.toString());

    List<Avaliacao> novasAvaliacoes = List.from(
      jsonData.map((avaliacao) => Avaliacao.fromJson(avaliacao)),
    );

    int totalReviewsLoading = page * pageSize;

    if (novasAvaliacoes.length > totalReviewsLoading) {
      novasAvaliacoes = novasAvaliacoes.sublist(0, totalReviewsLoading);
    }
    setState(() {
      page += 1;
      widget._avaliacoes.addAll(novasAvaliacoes);
      isLoading = false; // Ocultar a tela de carregamento
    });
  }

  @override
  Widget build(BuildContext context) {
    // widget.usuario = Usuario();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Avaliações'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (widget.usuario != null) componenteAvaliacao(),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget._avaliacoes.length,
                    itemBuilder: (context, index) {
                      final review = widget._avaliacoes[index];
                      return CardAvaliacao(review);
                    },
                  ),
                ),
              ],
            ),
            if (isLoading) const LoadingScreen()
          ],
        ));
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
      widget._avaliacoes.add(avaliacao);
      widget._avaliacoes.sort((a, b) => b.id.compareTo(a.id));
      commentController.clear();
      _rating = 0.0;
    });
  }
}
