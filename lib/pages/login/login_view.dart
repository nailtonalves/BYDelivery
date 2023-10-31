import 'package:bydelivery/components/loanding_screen.dart';
import 'package:bydelivery/models/usuario.dart';
import 'package:bydelivery/pages/feeds/feeds_view.dart';
import 'package:bydelivery/pages/home/home_view.dart';
import 'package:bydelivery/pages/login/authentication.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  Usuario? user;
  bool _isEsconderSenha = true;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  void _alterarVisibilidadeSenha() {
    setState(() {
      _isEsconderSenha = !_isEsconderSenha;
    });
  }

  Future<void> googleLogin() async {
    await Authentication.loginWithGoogle();
    user = Authentication.user;

    if (user != null) {
      cleanForm();
      goToHome();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Ocorreu um erro ao logar com sua conta Gmail.'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
  }

  // Future<void> googleLogin() async {
  //   await Authentication.handleSignIn();
  //   user = Authentication.user;
  //   if (user != null) {
  //     cleanForm();
  //     goToHome();
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       backgroundColor: Colors.redAccent,
  //       content: Text('Ocorreu um erro ao logar com sua conta Gmail.'),
  //       duration: Duration(seconds: 2),
  //     ));
  //     return;
  //   }
  // }

  Future<void> appLogin(String email, String senha) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    await Authentication.login(email, senha);
    user = Authentication.user;
    if (user != null) {
      cleanForm();
      goToHome();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Usuário e/ou senha incorreto.'),
        duration: Duration(seconds: 2),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  void goToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeView(user: user)),
    );
  }

  void validForm() {}

  void cleanForm() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 1,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 40),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            fit: BoxFit.fitWidth,
                            width: 100,
                            image: AssetImage(
                                'assets/images/entrega-expressa.png'),
                          ),
                          Text(
                            'BYDelivery',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Bem-vindo(a)!",
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      )
                    ],
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 24),
                        child: Text(
                          "Ao futuro das entregas",
                          style: TextStyle(fontWeight: FontWeight.w200),
                        ),
                      ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Form(
                                child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  labelText: 'Usuário',
                                  hintText: 'Informe o seu email.'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            TextField(
                              controller: passwordController,
                              obscureText: _isEsconderSenha,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _alterarVisibilidadeSenha();
                                      });
                                    },
                                    child: Icon(_isEsconderSenha
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  icon: const Icon(Icons.vpn_key),
                                  labelText: 'Senha',
                                  hintText: 'Informe a sua senha.'),
                            )
                          ],
                        )))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Não tem cadastro?"),
                          Text(
                            "Cadastre-se aqui.",
                            style: TextStyle(color: Colors.deepPurple),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                  'É necessário informar Usuário e senha.'),
                              duration: Duration(seconds: 2),
                            ));
                            return;
                          }
                          FocusScope.of(context).unfocus();
                          appLogin(
                              emailController.text, passwordController.text);
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                          const Size(170, 80),
                        )),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: _animation,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image(
                              fit: BoxFit.fitWidth,
                              width: 60,
                              image: AssetImage(
                                  'assets/images/bate-papo-bolha.png'),
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeedsView()),
                              );
                            },
                            child: const Text(
                                "Veja o que estão falando sobre nós..."))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText('Outras formas de login',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              'Lexend Deca',
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Colors.teal[100],
                        elevation: 10,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          googleLogin();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/google.png'),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text("Utilizando conta Google")
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        if (isLoading) const LoadingScreen()
      ],
    ));
  }
}
