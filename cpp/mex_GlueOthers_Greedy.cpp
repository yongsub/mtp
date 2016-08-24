


#include "mex.h"
#include "matrix.h"

inline
double min(double a, double b){
	return a < b ? a : b;
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	const mwIndex* ir = mxGetIr(prhs[0]);
	const mwIndex* jc = mxGetJc(prhs[0]);

	double* ASum = mxGetPr(prhs[1]);
	double* BSum = mxGetPr(prhs[2]);
	const mwSize candNum = mxGetM(prhs[1]);

	double AInt = mxGetScalar(prhs[3]);
	double BInt = mxGetScalar(prhs[4]);
	double cutVal = mxGetScalar(prhs[5]);

	plhs[0] = mxCreateDoubleMatrix(candNum, 1, mxREAL);
	double* nodeLabel = mxGetPr(plhs[0]);
	for(int i=0; i<candNum; i++){
		nodeLabel[i] = 0;
	}
	
	for(mwIndex i=0; i<candNum; i++){
		if( nodeLabel[i] > 0 ){
			continue;
		}

		double newAInt[2], newBInt[2], newCutVal[2], newCond[2];
		
		// Compute values when assigned to A
		newAInt[0] = AInt + 2*ASum[i];
		newBInt[0] = BInt;
		newCutVal[0] = cutVal + BSum[i];
		newCond[0] = newCutVal[0] / (min(newAInt[0],newBInt[0]) + newCutVal[0]);

		// Compute values when assigned to B
		newAInt[1] = AInt;
		newBInt[1] = BInt + 2*BSum[i];
		newCutVal[1] = cutVal + ASum[i];
		newCond[1] = newCutVal[1] / (min(newAInt[1],newBInt[1]) + newCutVal[1]);

		int minGroup;
		if(newCond[0] < newCond[1]) minGroup = 0;
		else minGroup = 1;

		AInt = newAInt[minGroup];
		BInt = newBInt[minGroup];
		cutVal = newCutVal[minGroup];
		nodeLabel[i] = minGroup + 1;

		mwIndex lr = jc[i], rr = jc[i+1];
		for(mwIndex j=lr; j<rr; j++){
			mwIndex u = ir[j];
			if(minGroup == 0){
				ASum[u] += 1;
			}
			else{
				BSum[u] += 1;
			}
		}
	}
}









































