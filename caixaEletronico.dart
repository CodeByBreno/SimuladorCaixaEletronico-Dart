import 'dart:io';

class Conta{
  double saldo = 0;
  List<String> operacores = [];
  String numCartao = '';
  String senha = '';
  String nome = '';
  int idade = 0;

  Conta(String nc, String senha, String nome, int i, double saldoInicial){
    this.numCartao = nc;
    this.senha = senha;
    this.nome = nome;
    this.idade = i;
    this.saldo = saldoInicial;
    this.addOperacao(saldoInicial, 3);
  }

  bool addOperacao(double valor, int op){
    bool result = false;
    switch(op){
      case 0:
        this.operacores.add("Deposito : +$valor");
        result = true;
        break;
      case 1:
        this.operacores.add("Saque : -$valor");
        result = true;
        break;
      case 2:
        this.operacores.add("Retirada de Extrato");
        result = true;
        break;
      case 3:
        this.operacores.add("Criação da Conta : +$valor");
        result = true;
        break;
      default:
        result = false;
    }
    return result;
  }
}

class CaixaEletronico{
  List<Conta>usuarios = [];
  Conta? user;

  CaixaEletronico(List<Conta> usuarios){
    this.usuarios = usuarios;
  }

  bool acessar(String? numCartao, String? senha){
    if ((numCartao == null) || (senha == null)) return false;

    for (Conta user in this.usuarios){
      if ((user.numCartao == numCartao) && (user.senha == senha)){
        this.user = user;
        return true;
      }
    }
    return false;
  }

  bool online(){
    if (this.user != null) return true;
    return false;
  }

  double? verificarSaldo(){
    if (this.online == false) return null; 
    return this.user!.saldo;
  }

  bool? depositar(double valor){
    if (this.online == false) return null; 

    bool result = false;
    this.user!.saldo += valor;
    result = this.user!.addOperacao(valor, 0);
    return result;
  }

  bool? saque(double valor){
    if (this.online == false) return null; 

    bool result = false;
    this.user!.saldo -= valor;
    result = this.user!.addOperacao(valor, 1);
    return result;
  }

  List<String>? extrato(){
    if (this.online == false) return null; 

    this.user!.addOperacao(0, 2);
    return this.user!.operacores;
  }
}

class Interface{
  Conta? user;
  CaixaEletronico? sistema;

  Interface(Conta usuario, CaixaEletronico sistema){
    this.user = usuario;
    this.sistema = sistema;
  }

  bool checkNull(){
    if ((this.user == null) || (this.sistema == null)) return true;
    return false;
  }

  bool acessarSistema(){
    bool result = false;
    if (this.checkNull()) return false;

    while(result == false){  
      print("\nInforme o número da sua conta e sua senha: ");
      print("Digite 1 para sair");

      String? nc = stdin.readLineSync();
      if (nc == '1'){
        print("\nSistema Finalizando...");
        return false;
      }
      String? password = stdin.readLineSync();

      result = this.sistema!.acessar(nc, password);
      if (result == false){
        print("\n\nCredenciais inválidas!");
      }
    }
    return true;
  }

  void apresentarSistema(){
      // O ideal seria usar uma lista de opções

      print("\nBem vindo ao sistema!");
      print("O que deseja fazer?");
      print("0 - Ver Saldo");
      print("1 - Deposito");
      print("2 - Saque");
      print("3 - Extrato");
      print("Outro - Finalizar Sessão");
  }

  bool realizarOperacao(){
    bool result = false;
    String? resposta = stdin.readLineSync();
      switch(resposta){
        case '0':
          result = this.verSaldo();
        case '1':
          result = this.depositar();
        case '2':
          result = this.saque();
        case '3':
          result = this.extrato();
        default:
          result = false;
      }
    return result;
  }

  bool verSaldo(){
    print("\n\n-------------------------");
    if(this.checkNull()) return false;
    print("Saldo atual: " + this.sistema!.verificarSaldo().toString());
    return true;
  }

  bool depositar(){
    print("\n\n-------------------------");
    if (this.checkNull()) return false;
    while(true){
      print("Quanto você deseja depositar?");
      String? valor = stdin.readLineSync();
      
      try{
        double v = double.parse(valor!);
        this.sistema!.depositar(v);
        print("Deposito de R\$ $v realizado com sucesso!");
        return true;
      } on FormatException{
        print("Valor inválido!");
        print("Deseja sair do sistema? y/N");
        String? resposta = stdin.readLineSync();
        if ((resposta == null) || (resposta == 'y')) return false;
      }
    }
  }

  bool saque(){
    print("\n\n-------------------------");
    if (this.checkNull()) return false;
    while(true){
      print("Quanto você deseja retirar?");
      String? valor = stdin.readLineSync();
      
      try{
        double v = double.parse(valor!);
        this.sistema!.saque(v);
        print("Saque de R\$ $v realizado com sucesso!");
        return true;
      } on FormatException{
        print("Valor inválido!");
        print("Deseja sair do sistema? y/N");
        String? resposta = stdin.readLineSync();
        if ((resposta == null) || (resposta == 'y')) return false;
      }
    }
  }

  bool extrato(){
    print("\n\n-------------------------");
    if (this.checkNull()) return false;

    var extrato = this.sistema!.extrato();

    if (extrato == null) return false;
    for (int i = 0; i < extrato.length; i++){
      print("$i - " + extrato[i]);
    }
    return true;
  }

  void espereConfirmacao(){
    print("Pressione algo para continuar...");
    // ignore: unused_local_variable
    var anyway = stdin.readLineSync();
  }
}