function [Y,T,X] = compile_neuraldata(whichtargets,numSamp,numDelay,filename)

if nargin<3
    numDelay=0;
end

if nargin>4
    load(filename)
else
    load('testdata-foreva.mat')
end

spikes = binnedData.spikeratedata;
times = binnedData.timeframe;
gocues = binnedData.trialtable(:,7);
targets = binnedData.trialtable(:,10);

L = length(gocues);
id  =zeros(L,1);
for i=1:L
   [~,id(i)] = min(abs(times-gocues(i))); 
end

tvec = zeros(length(times),1);
for i=1:L-1
   tvec(id(i):id(i+1))=targets(i);
end

T0 = tvec;
T0(1:id(1)-1)=[];
Y0 = spikes; 
Y0(1:id(1)-1,:)=[];

%numSamp = 10;
go_times = [];
for i=1:L
    if length(setdiff(whichtargets,targets(i)))~=length(whichtargets)
        go_times = [go_times, numDelay+id(i):numDelay+id(i)+numSamp];
    end
end

Y = spikes(go_times,:); 
T = tvec(go_times);

X = binnedData.velocbin(go_times,:);

% M1{1} = 'PCA'; 
% dim = 3;
% [Vr,~] = computeV(Y,dim,M1);
% 
% V = Vr{1};
%clear Vr
%figure, colorData(V,Tvec)

end





