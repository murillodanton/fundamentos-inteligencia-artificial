% =========================================================================
% gorjeta_fuzzy.m
% Fundamentos da IA - U3/A4 - Parte 2: gorjeta COM Logica Nebulosa
% Requer o pacote fuzzy-logic-toolkit do Octave:
%   pkg install -forge fuzzy-logic-toolkit   (apenas na primeira vez)
% =========================================================================
clear; clc; close all;
% Para gerar imagens sem abrir janelas: OCTAVE_HEADLESS=1.
if strcmp(getenv('OCTAVE_HEADLESS'), '1')
  graphics_toolkit('gnuplot');
  set(0, 'defaultfigurevisible', 'off');
end
try
  pkg load fuzzy-logic-toolkit
catch
  error('Instale fuzzy-logic-toolkit no Octave ou execute gorjeta_fuzzy_manual.m.');
end

% ---- 1. Entradas e saida ------------------------------------------------
fis = newfis('gorjeta', 'mamdani', 'min', 'max', 'min', 'max', 'centroid');
fis = addvar(fis, 'input',  'servico', [0 10]);
fis = addvar(fis, 'input',  'comida',  [0 10]);
fis = addvar(fis, 'output', 'gorjeta', [0 20]);   % em %

% ---- 2. Funcoes de pertinencia -----------------------------------------
% Servico (gaussianas centradas em 0, 5 e 10)
fis = addmf(fis, 'input', 1, 'ruim',      'gaussmf', [1.5 0]);
fis = addmf(fis, 'input', 1, 'bom',       'gaussmf', [1.5 5]);
fis = addmf(fis, 'input', 1, 'excelente', 'gaussmf', [1.5 10]);
% Comida: ombros externos para satisfazer a < b <= c < d do toolkit.
% No dominio [0,10], equivalem a [0 0 1 3] e [7 9 10 10].
fis = addmf(fis, 'input', 2, 'ruim',      'trapmf', [-1 0 1 3]);
fis = addmf(fis, 'input', 2, 'deliciosa', 'trapmf', [7 9 10 11]);
% Gorjeta (triangulares em torno de 5%, 10% e 15%)
fis = addmf(fis, 'output', 1, 'pequena',  'trimf', [0 5 10]);
fis = addmf(fis, 'output', 1, 'mediana',  'trimf', [5 10 15]);
fis = addmf(fis, 'output', 1, 'generosa', 'trimf', [10 15 20]);

% ---- 3. Regras -----------------------------------------------------------
% Formato: [servico comida gorjeta peso conector]  (conector 1=E, 2=OU)
regras = [ 1 1 1 1 2 ;   % servico ruim OU comida ruim       -> pequena
           2 0 2 1 1 ;   % servico bom                       -> mediana
           3 2 3 1 2 ];  % servico excelente OU comida delic.-> generosa
fis = addrule(fis, regras);
showrule(fis);

% ---- 4. Simulacao --------------------------------------------------------
casos = [0 0; 5 0; 0 5; 5 5; 8 3; 3 8; 5 10; 10 5; 10 10];   % [servico comida]
% Usa 1001 pontos de saida, como na implementacao manual.
gorjetas = evalfis(casos, fis, 1001);
printf('\n%-8s %-8s %-8s\n', 'Servico', 'Comida', 'Gorjeta');
for k = 1:rows(casos)
  printf('%-8d %-8d %6.2f%%\n', casos(k,1), casos(k,2), gorjetas(k));
end

% Graficos: funcoes de pertinencia e superficie de decisao
figure;
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
 plotmf(fis, 'input', 1);  title('Servico');
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
print('-dpng', 'pertinencia_servico.png');
figure;
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
 plotmf(fis, 'input', 2);  title('Comida');
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
print('-dpng', 'pertinencia_comida.png');
figure;
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
 plotmf(fis, 'output', 1); title('Gorjeta');
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
print('-dpng', 'pertinencia_gorjeta.png');
figure;
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
 gensurf(fis); title('Gorjeta - Logica Nebulosa');
if strcmp(getenv('OCTAVE_HEADLESS'), '1'), graphics_toolkit(gcf, 'gnuplot'); end;
print('-dpng', 'superficie_fuzzy.png');
