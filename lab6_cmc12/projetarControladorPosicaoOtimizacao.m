function controlador = projetarControladorPosicaoOtimizacao(requisitos, controladorCorrente, planta)
% controlador = projetarControladorPosicaoAnalitico(requisitos, planta)
% projeta o controlador de posicao atraves de otimizacao. A
% struct requisitos eh:
% requisitos.wb: requisito de banda passante.
% requisitos.GM: requisito de margem de ganho.
% requisitos.PM: requisito de margem de fase.
% requisitos.fs: requisito de taxa de amostragem.
% A struct controladorCorrente eh dada por:
% controlador.K: ganho proporcional do controlador de corrente.
% controlador.alpha: parametro alpha da compensacao lead.
% controlador.Tl: parametro Tl da compensacao lead.
% controlador.T: periodo de amostragem do controlador de corrente.
% A struct planta contem os parametros da planta e pode ser obtida atraves
% de planta = obterPlantaServoPosicao().
% A saida da funcao eh a struct controlador:
% controlador.Kp: ganho proporcional do controlador de posicao.
% controlador.Kd: ganho derivativo do controlador de posicao.
% controlador.a: frequencia de corte do filtro do termo derivativo.
% controlador.T: periodo de amostragem do controlador de posicao.

controlador = projetarControladorPosicaoAnalitico(requisitos, planta);

% Implementar

J = @(x) custoControladorPosicao(requisitos, controladorCorrente, planta, x);

p0 = [controlador.Kp, controlador.Kd];

popt = fminsearch(J, p0);

controlador.Kp = popt(1);
controlador.Kd = popt(2);

end

function J = custoControladorPosicao(requisitos, controladorCorrente, planta, parametros)

controladorPosicao.Kp = parametros(1);
controladorPosicao.Kd = parametros(2);
controladorPosicao.a = requisitos.wb * 10.0;
controladorPosicao.T = 1.0 / requisitos.fs;

% Implementar

[Ga, Gf] = obterMalhaPosicao(controladorPosicao, controladorCorrente, planta);

wb = bandwidth(Gf);
[~, PM] = margin(Ga);

J = (requisitos.wb - wb)^2 + (requisitos.PM - PM)^2;

end