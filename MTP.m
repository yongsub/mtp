% 
% MTP: find a subgraph with high quality partitions
%
% Author: 
% 		Yongsub Lim (yongsub@kaist.ac.kr), 
% 		U Kang    
%
% Parameter
%   AOrig : adjacency matrix of a graph. 
%   k : # of nodes to be removed.
%
% Return values
%   cutLabel: group label for nodes (0 for excluded nodes).
%   conductance: conductance of resulting subgraph partition.

function [cutLabel, conductance] = MTP(Aorig, k, gb)

if nargin ~= 3, error('MTP requires 3 arguments.'); end

if ~ismatrix(Aorig) || size(Aorig,1)~=size(Aorig,2)
	error('In MTP, @Aorig should be a square matrix.');
end
if ~isscalar(k)
	error('In MTP, @k should be a scalar integer or on range [0,1).');
end
if k~=round(k)
	if k >= 0 && k < 1
		k = round(size(Aorig,2)*k);
	else
		error('In MTP, @k should be a scalar integer or on range [0,1).');
	end
end

n = size(Aorig,1);

A = double(Aorig | Aorig');		% deal with a symmetric matrix
A(1:(n+1):(n^2)) = 0;

% graphSize = full([size(A,1), nnz(A)/2]);

[gccInd, hubInd, disInd] = SplitGraph(A, k);
Agcc = A(gccInd, gccInd);
[gccLabel, gccCond] = MetisClustering(Agcc);

cutLabel = zeros(n,1);
cutLabel([gccInd; hubInd; disInd]) = full([gccLabel; zeros(length(hubInd),1)-1; zeros(length(disInd),1)-2]);

conductance = [gccCond, nan];

if gb
	[hubLabel, disLabel] = GlueOthers_Greedy(A, gccInd, gccLabel, hubInd, disInd);
	cutLabel([hubInd; disInd]) = [hubLabel; disLabel];
	conductance(2) = ComputeConductance(A, cutLabel);
end

end








