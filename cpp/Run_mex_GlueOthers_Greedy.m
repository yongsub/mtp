

function [hubLabel disLabel] = Run_mex_GlueOthers_Greedy(A, gccInd, gccLabel, hubInd, disInd)

hubNum = length(hubInd);
disNum = length(disInd);
	

[~, aInt, bInt, cutVal] = ComputeConductance(A(gccInd,gccInd), gccLabel);

[disccNum, disccLabel] = graphconncomp(A(disInd, disInd));  %find disconnected components


[~,I] = sort(disccLabel, 'ascend');

candInd = [hubInd ; disInd(I)];

aInd = gccInd(gccLabel==1);
bInd = gccInd(gccLabel==2);

aSum = full(sum(A(aInd,candInd),1)');
bSum = full(sum(A(bInd,candInd),1)');

otherLabel = mex_GlueOthers_Greedy(A(candInd,candInd), aSum, bSum, aInt, bInt, cutVal);


hubLabel = otherLabel(1:hubNum);
	
oriOrder = 1:disNum;
oriOrder(I) = 1:disNum;
disLabel = otherLabel((hubNum+1):end);
disLabel = disLabel(oriOrder);

end














