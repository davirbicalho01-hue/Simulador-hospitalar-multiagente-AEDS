Fila<Paciente> filaTriagemNormal;
Fila<Paciente> filaTriagemPreferencial;

boolean[] enfermeiraOciosa;
Paciente[] pacienteNaTriagem;
long[] fimTriagem;
boolean[] triagemIniciada;

int atendimentosPreferenciaisSeguidos = 0;

Manchester manchester;
AtendimentoMedico atendimentoMedico;

void inicializarTriagem() {
  filaTriagemNormal = new Fila<Paciente>();
  filaTriagemPreferencial = new Fila<Paciente>();

  enfermeiraOciosa = new boolean[qtdEnfermeiros];
  pacienteNaTriagem = new Paciente[qtdEnfermeiros];
  fimTriagem = new long[qtdEnfermeiros];
  triagemIniciada = new boolean[qtdEnfermeiros];

  manchester = new Manchester();
  atendimentoMedico = new AtendimentoMedico();

  for (int i = 0; i < qtdEnfermeiros; i++) {
    enfermeiraOciosa[i] = true;
    pacienteNaTriagem[i] = null;
    fimTriagem[i] = 0;
    triagemIniciada[i] = false;
  }

  atendimentosPreferenciaisSeguidos = 0;
}


Paciente proximoDaTriagem() {

  if (filaTriagemNormal.vazia() && filaTriagemPreferencial.vazia()) {
    return null;
  }

  if (!filaTriagemPreferencial.vazia() &&
      (filaTriagemNormal.vazia() ||
       atendimentosPreferenciaisSeguidos < 2)) {

    atendimentosPreferenciaisSeguidos++;

    return filaTriagemPreferencial.desenfileirar();
  }

  if (!filaTriagemNormal.vazia()) {

    atendimentosPreferenciaisSeguidos = 0;

    return filaTriagemNormal.desenfileirar();
  }


  atendimentosPreferenciaisSeguidos++;

  return filaTriagemPreferencial.desenfileirar();
}


float sortearTempoTriagem() {

  float t = 6.0 + 2.0 * randomGaussian();

  return max(t, 2.0);
}


Coordenada celulaAdjacenteLivre(Coordenada base) {

  int[] dLinha = {-1, 1, 0, 0};
  int[] dColuna = {0, 0, -1, 1};

  for (int k = 0; k < 4; k++) {

    int l = base.linha + dLinha[k];
    int c = base.coluna + dColuna[k];

    if (l >= 0 && l < numLinhas &&
        c >= 0 && c < numColunas) {

      if (mapa[l][c] == '.') {

        return new Coordenada(l, c);
      }
    }
  }

  return null;
}


void atualizarTriagem() {

  for (int i = 0; i < qtdEnfermeiros; i++) {

    if (!enfermeiraOciosa[i] &&
        triagemIniciada[i] &&
        millisSimulacao() >= fimTriagem[i]) {

      Paciente p = pacienteNaTriagem[i];

      p.estado = EstadoPaciente.INDO_ASSENTO_MEDICO;

      pacienteNaTriagem[i] = null;
      enfermeiraOciosa[i] = true;
      triagemIniciada[i] = false;
    }

    if (enfermeiraOciosa[i]) {

      Paciente proximo = proximoDaTriagem();

      if (proximo != null) {

        liberarAssento(proximo);

        Coordenada destino =
          celulaAdjacenteLivre(enfermeiros[i]);

        if (destino != null) {

          proximo.destino = destino.copy();
          proximo.estado = EstadoPaciente.INDO_TRIAGEM;

          pacienteNaTriagem[i] = proximo;
          enfermeiraOciosa[i] = false;
        }
      }
    }
  }
}


void iniciarAtendimentoTriagem(int idxEnfermeira, Paciente p) {

  p.estado = EstadoPaciente.EM_TRIAGEM;

  triagemIniciada[idxEnfermeira] = true;

  fimTriagem[idxEnfermeira] =
    millisSimulacao() +
    (long)(sortearTempoTriagem() * 1000);
}
