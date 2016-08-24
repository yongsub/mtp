% 
% GlueOthers_Greedy: determine labels for hubs and spokes
%
% Author: 
% 		Yongsub Lim (yongsub@kaist.ac.kr)
% 		U Kang    
%
% Parameter
%   A: adjacency matrix.
%	gccInd: indices of GCC
%	gccLabel: partition for GCC (1 or 2)
%	hubInd: indices for hubs
%	disInd: indices for spokes
%
% Return values
%   hubLabel: partition assignments for hubs specified by hubInd
%	disLabel: partition assignments for spokes specified by disInd

function [hubLabel, disLabel] = GlueOthers_Greedy(A, gccInd, gccLabel, hubInd, disInd)

[hubLabel, disLabel] = Run_mex_GlueOthers_Greedy(A, gccInd, gccLabel, hubInd, disInd);


allInd = [gccInd; hubInd; disInd];
allLabel = zeros(size(A,1),1);
allLabel(allInd) = [gccLabel; hubLabel; disLabel];

cand = full([hubInd; disInd]);

aInd = allLabel==1;
bInd = allLabel==2;

aSize = nnz(aInd);
bSize = nnz(bInd);

[~, aInt, bInt, cutVal] = ComputeConductance(A, allLabel);

if aSize == bSize || isempty(cand)
	return;
elseif aSize > bSize
	moveNum = floor((aSize-bSize)/2);
	cand = cand(allLabel(cand)==1);
	from = 1;
	to = 2;
else
	moveNum = floor((bSize-aSize)/2);
	cand = cand(allLabel(cand)==2);		
	from = 2;
	to = 1;
end

ABSum = {full(sum(A(aInd,cand),1)'), full(sum(A(bInd,cand),1)')};
ABInt = {aInt, bInt};

movedInd = mex_MoveForBalance(A(cand,cand), moveNum, ABSum{from}, ABSum{to}, ABInt{from}, ABInt{to}, cutVal);
allLabel(cand(movedInd)) = to;

hubLabel = allLabel(hubInd);
disLabel = allLabel(disInd);


end
























