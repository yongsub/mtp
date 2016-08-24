% 
% SplitGraph: remove hubs from the graph, and identify GCC
%
% Author: 
% 		Yongsub Lim (yongsub@kaist.ac.kr)
% 		U Kang    
%
% Parameter
%   A: adjacency matrix.
%   k: # of nodes to be removed.
%
% Return values
%   gccInd: indices belonging to GCC after the hub removal.
%   hubInd: indices belonging to the hubs.
% 	disInd: indices belonging to disconnected components after the hub removal.
% 	compHist: size distribution of connected components after the hub removal.

function [gccInd, hubInd, disInd] = SlashGraph(A, k)

degree = sum(A,2);
[~,I] = sort(degree, 'descend');

hubInd = I(1:k);
% undInd = I(k+1:end);
undInd = (1:size(A,1))';
undInd(hubInd) = [];

[compNum,compLabel] = graphconncomp(A(undInd, undInd));
compHist = histc(compLabel, 1:compNum);

[~,gcc_id] = max(compHist);

gccInd = undInd(compLabel==gcc_id);
disInd = undInd(compLabel~=gcc_id);

end