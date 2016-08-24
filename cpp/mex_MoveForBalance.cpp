

#include "mex.h"
#include "matrix.h"

inline
double min(double a, double b){
	return a < b ? a : b;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){	
	mwIndex* ir = mxGetIr(prhs[0]);
	mwIndex* jc = mxGetJc(prhs[0]);
	
	mwSize moveNum = mwSize(mxGetScalar(prhs[1]));

	double* fromSum = mxGetPr(prhs[2]);
	double* toSum = mxGetPr(prhs[3]);
	mwSize candNum = mxGetM(prhs[2]);

	double fromInt = mxGetScalar(prhs[4]);
	double toInt = mxGetScalar(prhs[5]);
	double cutVal = mxGetScalar(prhs[6]);

	plhs[0] = mxCreateDoubleMatrix(moveNum, 1, mxREAL);
	double* movedNode = mxGetPr(plhs[0]);

	bool* candAlreadyMoved = new bool[candNum];
	for(int i=0; i<candNum; i++) candAlreadyMoved[i] = false;

	double label, newAInt, newBInt, newCutVal;
	
	for(mwIndex i=0; i<moveNum; i++){		
		double minFromInt, minToInt, minCutVal, minCond=10e10;
		mwIndex minInd = -1;

		for(int j=0; j<candNum; j++){
			if(candAlreadyMoved[j] == true){
				continue;
			}

			double newFromInt = fromInt, newToInt = toInt, newCutVal = cutVal;

			newFromInt -= 2*fromSum[j];
			newToInt += 2*toSum[j];
			newCutVal += fromSum[j] - toSum[j];

			double newCond = newCutVal / (min(newFromInt,newToInt) + newCutVal);

			if( newCond < minCond ){
				minFromInt = newFromInt;
				minToInt = newToInt;
				minCutVal = newCutVal;
				minCond = newCond;
				minInd = j;
			}
		}

		fromInt = minFromInt;
		toInt = minToInt;
		cutVal = minCutVal;
		movedNode[i] = minInd + 1; // for 1-base indexing

		candAlreadyMoved[minInd] = true;

		mwIndex lr = jc[minInd], rr = jc[minInd+1];
		for(mwIndex j=lr; j<rr; j++){
			mwIndex u = ir[j];
			fromSum[u] -= 1;
			toSum[u] += 1;
		}
	}

	delete [] candAlreadyMoved;
}
