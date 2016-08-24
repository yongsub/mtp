% 
% MetisClustering: partition the graph using METIS
%
% Author: 
% 		Yongsub Lim (yongsub@kaist.ac.kr)
% 		U Kang    
%
% Parameter
%   A: adjacency matrix.
%
% Return values
%   label: partition result (1 or 2 for every node in A).
%   conductance: conductance of the resulting partition.

function [label, conductance] = MetisClustering(A)

[leftPart, rightPart] = metispart(A,2);

n = size(A,1);

label = zeros(n,1);
label(leftPart) = 1;
label(rightPart) = 2;

conductance = ComputeConductance(A, label);

end