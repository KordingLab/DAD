function [Y,T,X] = compile_jango_neuraldata(whichtargets,numSamp,numDelay,filename)

if nargin<3
    numDelay=0;
end

if length(numSamp)==1
    numSamp = numSamp*ones(length(whichtargets),1);
end

if length(numDelay)==1
    numDelay = numDelay*ones(length(whichtargets),1);
end

if nargin>=4
    if ~isempty(filename)
        load(filename)
    end 
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
        nS = numSamp(find(targets(i)==whichtargets));
        nD = numDelay(find(targets(i)==whichtargets));
        go_times = [go_times, nD+id(i):nD+id(i)+nS];
    end
end

Y = spikes(go_times,:); 
T = tvec(go_times);
X = binnedData.velocbin(go_times,:);

idd = find(T==0);

T(idd)=[];
Y(idd,:)=[];
X(idd,:)=[];


end





