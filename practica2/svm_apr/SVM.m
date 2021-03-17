#!/usr/bin/octave -qf

if (nargin!=2)
printf("Usage: SVM.m <t><C>\n");
exit(1);
end;

arg_list=argv();
t=str2num(arg_list{1});
C=str2num(arg_list{2});

load data/mini/trSep.dat ; 
load data/mini/trSeplabels.dat;

%load data/mini/tr.dat ; 
%load data/mini/trlabels.dat;

opciones = sprintf("-t %d -c %d",t,C);
res=svmtrain(trlabels,tr, opciones);

vs_et=res.sv_indices; %etiquetas de vectores de soporte
%tr(vs_et,:)==res.SVs

vs=res.SVs; %vectores de soporte

lagrange=res.sv_coef;

vpesos=lagrange'*vs;
%vpesos=sum(lagrange'.*vs);

bucle=true;
for i=1:rows(vs)
  if (abs(lagrange(i))<C) break;
  end
end
signo=sign(lagrange(i));

pesoumbral= signo-vpesos*vs(i,:)';

margen=2/vpesos';

tolerancia= 1-signo*(vpesos*res.SVs'+pesoumbral)   %solo para no separable

Parte1=vpesos(1)/vpesos(2);
Parte2=pesoumbral/vpesos(2);
Parte2sup=(pesoumbral-1)/vpesos(2);
Parte2inf=(pesoumbral+1)/vpesos(2);
for i=0:7
  Y(i+1)=-Parte1*i-Parte2;
  Ysup(i+1)=-Parte1*i-Parte2sup;
  Yinf(i+1)=-Parte1*i-Parte2inf;
end

X=0:1:7;
plot(X,Y,X,Ysup,X,Yinf,tr(trlabels==1,1),tr(trlabels==1,2),"x",tr(trlabels==2,1),tr(trlabels==2,2),"s");
%plot(X,Y,X,Ysup,X,Yinf,tr(trlabels==1,1),tr(trlabels==1,2),"x",tr(trlabels==2,1),tr(trlabels==2,2),"s");
xlabel("X");
ylabel("Y");
title("tabla");
for i=1:rows(res.sv_coef)
  text(res.SVs(i,1)+0.2,res.SVs(i,2),num2str(round(tolerancia(i))))
  text(res.SVs(i,1),res.SVs(i,2)+0.2,num2str(round(res.sv_coef(i))))
end
otros=setdiff(1:rows(trlabels),res.sv_indices);
for i=otros
  text(tr(i,1)+0.2,tr(i,2),num2str(0))
  text(tr(i,1),tr(i,2)+0.2,num2str(0))
end
print ("plot15_7.jpg", "grafica.jpg");
grid on
pause(10);