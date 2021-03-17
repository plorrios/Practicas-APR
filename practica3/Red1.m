#!/usr/bin/octave -qf
addpath("nnet_apr");
load data/hart/tr.dat;
load data/hart/trlabels.dat;
load data/hart/ts.dat;
load data/hart/tslabels.dat;

mInput=tr';
mOutput=trlabels';
mTestInput=ts';
mTestOutput=tslabels';

[nFeat, nSamples] = size(mInput);
nTr=floor(nSamples*0.8);
nVal=nSamples-nTr;

rand('seed',23);
indices=randperm(nSamples);

mTrainInput=mInput(:,indices(1:nTr));
mTrainOutput=mOutput(indices(1:nTr));
mValiInput=mInput(:,indices((nTr+1):nSamples));
mvaliOutput=mOutput(indices((nTr+1):nSamples));

labs=unique(trlabels);
trohe=zeros(labs,columns(tr));
for i=labs
  C=find(i==labs);
  indc=find(trlabels==i);
  trohe(C,indc)=1;
end
validoutDisp=trohe;

[mTrainInputN,cMeanInput,cStdInput]=prestd(mTrainInput);
VV.P = mValiInput;
VV.T = validoutDisp;
VV.P = trastd(VV.P,cMeanInput,cStdInput);

MLPnet=newff(minmax(mTrainInputN),[nHidden nOutput],{"tansig","logsig"},"trainlm","","mse");
MLPnet.trainParam.show = 10;
MLPnet=trainParam.epochs = 300;
net=train(MLPnet,mTrainInputN,trainoutDisp,[],[],VV);

mTestInputN = trastd(mTestInput,cMeanInput,cStdInput);
simOut = sim(net,mTestInputN);

[_,pos] = max(simout);%posicion de la label elegida
label = labs(pos);%label elegida
err = mean(label!=tslabels)%media de error
