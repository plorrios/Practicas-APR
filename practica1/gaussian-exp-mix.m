#!/usr/bin/octave -qf

if (nargin!=8)
printf("Usage: multinomial-exp.m <trdata> <trlabels> <tedata> <telabels> <alpha> <mink> <stepk> <maxk>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
alpha=str2num(arg_list{5});
mink=str2num(arg_list{6});
stepk=str2num(arg_list{7});
maxk=str2num(arg_list{8});

#Cargamos las matrices
load(trdata);
load(trlabs);
load(tedata);
load(telabs);

[m,W]=pca2(X);
for k=mink:stepk:maxk
  XR=(X-m)*W(:,1:k);
  YR=(Y-m)*W(:,1:k);
  size(XR);
  err=mixgaussian(XR,xl,YR,yl,1,alpha);
  printf("%d %f\n",k,err);
end
% Samples and labels are expected to come as rows
