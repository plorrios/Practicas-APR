function[m,W]=pca2(X)
m=mean(X);%calculo de la media
A=X-m;%calculo de la matriz A para el calculio de la matriz de covarianzas
Sigma=(1/rows(X))*A'*A;%Calculo de la matriz de covarianzas
[eigvec,eigval]=eig(Sigma);%Calculo de los vectores propios
[_,I]=sort(diag(eigval),"descend");%Calculo de los vectores propios
W=eigvec(:,I);%Calculo de los vectores propios
endfunction
%comentarios sencillos indicando que se hace en cada linea