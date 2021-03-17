addpath('~/asigDSIC/ETSINF/apr/bayes/BNT')
addpath(genpathKPM('~/asigDSIC/ETSINF/apr/bayes/BNT'))

N=5; P=1; F=2; C=3; X=4; D=5;
grafo = zeros(N,N);
grafo(P,C) = 1;
grafo(F,C) = 1;
grafo(C,[X D]) = 1;
nodosDiscretos= 1:N;
tallaNodos = 2*ones(1,N);
tallaNodos(X) = 3;
redB=mk_bnet(grafo, tallaNodos, 'discrete', nodosDiscretos);
redB.CPD{P} = tabular_CPD(redB, P, [0.9 0.1]);
redB.CPD{F} = tabular_CPD(redB, F, [0.7 0.3]);
redB.CPD{C} = tabular_CPD(redB, C, [0.999 0.97 0.95 0.92 0.001 0.03 0.05 0.08]);
redB.CPD{X} = tabular_CPD(redB, X, [0.8 0.1 0.10 0.20 0.10 0.70]);
redB.CPD{D} = tabular_CPD(redB, D, [0.7 0.35 0.30 0.65])
%Hasta Aqui Apartado B1


%Inferencia Apartado B2
motor = jtree_inf_engine(redB);
evidencia = cell(1, N);

evidencia{F} = 1;
evidencia{X} = 1;
evidencia{D} = 2;
[motor, logVerosim] = enter_evidence(motor, evidencia);
m = marginal_nodes(motor, C);
m.T

%Inferencia Apartado B3
motor = jtree_inf_engine(redB);
evidencia = cell(1, N);

evidencia{C} = 2;
[motor, logVerosim] = enter_evidence(motor, evidencia);
[explMaxProb, logVerosim] = calc_mpe(motor, evidencia)