% 
% ComputeConductance: compute conductance for the partition on the graph 
%
% Author: 
% 		Yongsub Lim (yongsub@kaist.ac.kr)
% 		U Kang    
%
% Parameter
%   A: adjacency matrix.
%	label: partition (1 or 2 for every node).
%
% Return values
%   conductance: conductance of the partition.
%	aInt: 2*(# of edges in group 1).
% 	bInt: 2*(# of edges in group 2).
% 	cutVal: # of edges acrossing two groups 1 and 2.

function [conductance, aInt, bInt, cutVal] = ComputeConductance(A, label)

aInd = find(label==1);
bInd = find(label==2);

aPart = A(aInd, aInd);
aInt = sum(sum(aPart));

bPart = A(bInd, bInd);
bInt = sum(sum(bPart));

cutPart = A(aInd, bInd);
cutVal = sum(sum(cutPart));

conductance = cutVal / (min(aInt,bInt)+cutVal);

end