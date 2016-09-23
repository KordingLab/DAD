
%genpath(path('/Users/evadyer/DropBox/Toolboxes/drtoolbox'))
filenm = 'Stevenson_2011_e1.mat';
fn =load(filenm);
maxTrials = 100;
badn = find(fn.Subject(1).Special.NeuronMapping(:,2)==255);

Subject = fn.Subject(1);
clear fn


%% prepare hand pos data
numT = length(Subject.Trial);
numT = min(maxTrials,numT);
X=[];
for i=1: numT
        X = [X; Subject.Trial(i).HandVel]; 
end


%% prepare neural data
Y=[];
numN = length(Subject.Trial(1).Neuron);
for j=1: numT
    Ynew = zeros(length(Subject.Trial(j).Time),numN);
    for i=1:numN  
        numS = length(find(Subject.Trial(j).Neuron(i).Spike));
        for k=1:numS
            tmp=Subject.Trial(j).Neuron(i).Spike(k);
            [~,id] = min(abs(tmp-Subject.Trial(j).Time));
            Ynew(id,i) = Ynew(id,i) + 1;
        end % end loop over spikes
    end % end loop over neurons
    Y = [Y; Ynew];
end % end loop over trials

Y(:,badn)=[];

%% remove duds
duds = find(sum(Y)<10);
Y(:,duds)=[];

%% smooth data
Ts = Subject.Trial(1).Time(2) - Subject.Trial(1).Time(1);
Nw = 100; % 200 ms 
w  = window(@gausswin,Nw,2.5);
out = conv2(Y,w);

Y2 = out(round(Nw/2)+20:round(Nw/2)+size(Y,1)-1-20,:);
Y3 = Y2; 
Y3(:,find(var(Y3)<5))=[];
[V, ~] = compute_mapping(Y3,'PCA',3);

figure; 
subplot(1,2,1); plot3(X(:,1),X(:,2),X(:,3),'^')
subplot(1,2,2); plot3(V(:,1),V(:,2),V(:,3),'r*')







