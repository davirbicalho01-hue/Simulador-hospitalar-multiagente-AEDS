int contadorSenhaNormal = 0;
int contadorSenhaPreferencial = 0;

boolean totemOcupado = false;

boolean[] assentoOcupado;
Paciente[] pacienteNoAssento;

void inicializarTotem() {
  contadorSenhaNormal = 0;
  contadorSenhaPreferencial = 0;
  totemOcupado = false;

  assentoOcupado = new boolean[qtdAssentos];
  pacienteNoAssento = new Paciente[qtdAssentos];

  for (int i = 0; i < qtdAssentos; i++) {
    assentoOcupado[i] = false;
    pacienteNoAssento[i] = null;
  }
}

String gerarSenha(boolean preferencial) {
  if (preferencial) {
    contadorSenhaPreferencial++;
    return "P" + nf(contadorSenhaPreferencial, 4);
  } else {
    contadorSenhaNormal++;
    return "N" + nf(contadorSenhaNormal, 4);
  }
}

int reservarAssentoMaisProximo(int[][] distanciasAPartirDoPaciente, Paciente p) {

  int melhorAssento = -1;
  int menorDistancia = 999999;

  for (int i = 0; i < qtdAssentos; i++) {

    if (!assentoOcupado[i]) {

      Coordenada assento = assentos[i];

      int distancia =
        distanciasAPartirDoPaciente[assento.linha][assento.coluna];

      if (distancia >= 0 && distancia < menorDistancia) {
        menorDistancia = distancia;
        melhorAssento = i;
      }
    }
  }

  if (melhorAssento != -1) {
    assentoOcupado[melhorAssento] = true;
    pacienteNoAssento[melhorAssento] = p;
  }

  return melhorAssento;
}

void liberarAssento(Paciente p) {

  for (int i = 0; i < qtdAssentos; i++) {

    if (pacienteNoAssento[i] == p) {

      assentoOcupado[i] = false;
      pacienteNoAssento[i] = null;

      return;
    }
  }
}

void processarTotem(Paciente p, int[][] distanciasAPartirDoPaciente) {

  if (totemOcupado) return;

  totemOcupado = true;

  int idxAssento =
    reservarAssentoMaisProximo(distanciasAPartirDoPaciente, p);

  if (idxAssento != -1) {
    p.destino = assentos[idxAssento].copy();
    p.estado = EstadoPaciente.INDO_ASSENTO_TRIAGEM;
  }

  totemOcupado = false;
}
