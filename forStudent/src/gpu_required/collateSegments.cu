/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void collateSegments_gpu(int * src, int * scanResult, int * output, int numEdges) {
	/*YOUR CODE HERE*/
	int tid = blockIdx.x * blockDim.x + threadIdx.x;//this is the thread id and will be used as index
	while( tid < numEdges )
	{
		if( tid == (numEdges - 1) )//last element in the array
		{
			output[src[tid]] = scanResult[tid];
		}
		else if( src[tid] != src[tid+1] )
		{
			output[src[tid]] = scanResult[tid];
		}
		tid += ( blockDim.x * gridDim.x );
	}
	return;
}
