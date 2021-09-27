import 'package:flutter/material.dart';
import 'package:vidente_app/controllers/tema_controller.dart';
import 'package:vidente_app/models/cidade.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vidente_app/models/tema.dart';
import 'package:vidente_app/services/cidade_service.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  List<Cidade> cidades;
  bool carregandoCidades;

  @override
  void initState() {
    super.initState();
    carregarCidades();
    this.carregandoCidades = false;
  }

  void carregarCidades() async {
    CidadeService service = CidadeService();
    cidades = await service.recuperarCidades();
  }

  Iterable<Cidade> filtrarCidades(String consulta) {
    return this.cidades.where(
        (cidade) => cidade.nome.toLowerCase().contains(consulta.toLowerCase()));
  }

  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: Color(0xFF88B2D9),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Escolha seu tema',
                  style: TextStyle(fontSize: 18),
                ),
                Column(
                  children: [
                    Icon(Icons.brightness_6_outlined),
                    Switch(
                      value: TemaController.instancia.temaEscolhido == null ||
                              TemaController.instancia.temaEscolhido.codigo == 0
                          ? false
                          : true,
                      onChanged: (valor) {
                        int recup = (valor ? 1 : 0);
                        // Global.shared.resposta = recup;
                        // TemaController.instancia
                        //     .trocarTema(Tema(Global.shared.resposta));
                        TemaController.instancia.trocarTema(Tema(recup));
                      },
                    ),
                  ],
                ),
              ],
            ),
            TypeAheadField<Cidade>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: this._typeAheadController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Procurar cidade',
                ),
              ),
              suggestionsCallback: filtrarCidades,
              onSuggestionSelected: (sugestao) {
                final String filtro = sugestao.nome + ' ' + sugestao.estado;
                this._typeAheadController.text = filtro;
              },
              itemBuilder: (context, sugestao) {
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(sugestao.nome + " - " + sugestao.siglaEstado),
                  subtitle: Text(sugestao.estado),
                );
              },
              noItemsFoundBuilder: (context) => Container(
                child: Center(
                  child: Text(
                    'Nenhuma cidade encontrada',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xFF88B2D9),
                    padding: EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Salvar Configurações',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    CidadeService service = CidadeService();

                    // TemaController.instancia
                    //     .salvarTema(Tema(Global.shared.resposta));

                    service
                        .pesquisarCidade(this._typeAheadController.text)
                        .then((resultado) =>
                            Navigator.pushNamed(context, '/home'));
                    setState(() {
                      this.carregandoCidades = true;
                    });
                  },
                )),
              ],
            ),
            this.carregandoCidades
                ? Column(
                    children: [
                      Padding(padding: EdgeInsets.all(20)),
                      Image(
                        image: AssetImage('images/loading.gif'),
                        width: 50,
                      )
                    ],
                  )
                : Text('')
          ],
        ),
      ),
    );
  }
}

class Global {
  static final shared = Global();
  int resposta = 0;
}
