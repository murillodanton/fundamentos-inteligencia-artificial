% =========================================================================
% gorjeta_procedural.m
% Fundamentos da IA - U3/A4 - Parte 1: gorjeta SEM Logica Nebulosa
%
% Regras (escala 0 a 10 para comida e servico):
%   - servico ruim (< 3)       -> gorjeta sobe de 5% ate 10%
%   - servico bom  (3 a 7)     -> gorjeta mediana de 10%
%   - servico excelente (> 7)  -> gorjeta sobe de 10% ate 15%
% A comida entra com peso menor (20%), variando linearmente de 5% a 15%.
% =========================================================================
clear; clc; close all;
% Para gerar imagens sem abrir janelas: OCTAVE_HEADLESS=1.
if strcmp(getenv('OCTAVE_HEADLESS'), '1')
  graphics_toolkit('gnuplot');
  set(0, 'defaultfigurevisible', 'off');
end

function g = calcular_gorjeta_procedural(comida, servico)
  assert(isscalar(servico) && isscalar(comida) && isreal(servico) && isreal(comida) && ...
         isfinite(servico) && isfinite(comida) && servico >= 0 && servico <= 10 && comida >= 0 && comida <= 10, ...
         'Servico e comida devem ser escalares reais finitos entre 0 e 10.');
  peso_servico = 0.8;               % servico pesa 80%, comida 20%
  % Parcela do servico (funcao linear por partes)
  if servico < 3
    g_serv = 0.05 + (0.05/3) * servico;            % 5%  -> 10%
  elseif servico < 7
    g_serv = 0.10;                                 % 10% (plato)
  else
    g_serv = 0.10 + (0.05/3) * (servico - 7);      % 10% -> 15%
  end
  % Parcela da comida (linear de 5% a 15%)
  g_comida = 0.05 + 0.10 * comida / 10;
  g = peso_servico * g_serv + (1 - peso_servico) * g_comida;
end

% ---- Tabela de resultados para alguns casos -----------------------------
casos = [0 0; 0 5; 5 0; 5 5; 3 8; 8 3; 10 5; 5 10; 10 10];
printf('%-8s %-8s %-8s\n', 'Comida', 'Servico', 'Gorjeta');
for k = 1:rows(casos)
  c = casos(k,1); s = casos(k,2);
  printf('%-8d %-8d %6.2f%%\n', c, s, 100*calcular_gorjeta_procedural(c, s));
end

% ---- Superficie (equivalente a Figura 1 do roteiro) ---------------------
[C, S] = meshgrid(0:0.5:10, 0:0.5:10);
G = arrayfun(@calcular_gorjeta_procedural, C, S);
figure;
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;

surf(S, C, 100*G);
xlabel('Servico'); ylabel('Comida'); zlabel('Gorjeta (%)');
title('Gorjeta - solucao procedural (sem Logica Nebulosa)');
colormap(jet); view(-37.5, 30); grid on;
print('-dpng', 'superficie_procedural.png');
