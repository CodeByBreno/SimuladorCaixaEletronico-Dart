import 'caixaEletronico.dart';

void main(){
  Conta usuario = Conta('5845 6578 2532 7020', '123456789', 'Breno Gabriel', 20, 500.0);
  CaixaEletronico caixa = CaixaEletronico([usuario]);
  Interface sistema = Interface(usuario, caixa);

  bool flag = true;
  bool result = true;
  while(true){
    flag = sistema.acessarSistema();
    if (flag == false) break;

    while(result){
      sistema.apresentarSistema();
      result = sistema.realizarOperacao();
      sistema.espereConfirmacao();
    }
  }
}