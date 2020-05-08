/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void packGraph_gpu(int * newSrc, int * oldSrc, int * newDst, int * oldDst, int * newWeight, int * oldWeight, int * edgeMap, int numEdges) {
	/*YOUR CODE HERE*/
	int tid = blockIdx.x * blockDim.x + threadIdx.x;//this is the thread id and will be used as index
	while( tid < numEdges )
	{
		if( edgeMap[tid + 1] != edgeMap[tid] )
		{
			newSrc[edgeMap[tid]] = oldSrc[tid];
			newDst[edgeMap[tid]] = oldDst[tid];
			newWeight[edgeMap[tid]] = oldWeight[tid];
		}
		tid += ( blockDim.x * gridDim.x );
	}
	return;
}
