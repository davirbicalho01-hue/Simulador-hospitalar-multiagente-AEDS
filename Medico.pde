class Medico {

  Coordenada posicao;
  boolean ocupado;

  Paciente pacienteAtual;

  long inicioAtendimento;
  float tempoAtendimento;


  Medico(Coordenada posicao) {
    this.posicao = posicao.copy();

    ocupado = false;
    pacienteAtual = null;
  }


  void iniciarAtendimento(Paciente paciente) {

    pacienteAtual = paciente;
    ocupado = true;

    tempoAtendimento = max(12.0 + 4.0 * randomGaussian(), 4.0);

    inicioAtendimento = millisSimulacao();
  }


  boolean atendimentoTerminou() {

    if (!ocupado) {
      return false;
    }

    return millisSimulacao() - inicioAtendimento >= tempoAtendimento * 1000;
  }


  Paciente finalizarAtendimento() {

    Paciente pacienteFinalizado = pacienteAtual;

    pacienteAtual = null;
    ocupado = false;

    return pacienteFinalizado;
  }
}
