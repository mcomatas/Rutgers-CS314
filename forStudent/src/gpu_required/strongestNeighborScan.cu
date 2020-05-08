/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void strongestNeighborScan_gpu(int * src, int * oldDst, int * newDst, int * oldWeight, int * newWeight, int * madeChanges, int distance, int numEdges) {
	/*YOUR CODE HERE*/
	int tid = blockIdx.x * blockDim.x + threadIdx.x;//this is the thread id and will be used as index
	while( tid < numEdges )//as long as thread id is in bounds of the array
	{
		if( tid - distance >= 0 )//then we can do something, it's in bounds of the array
		{
			if( src[tid - distance] == src[tid] )//check if the two are in the same segment
			{
				if( oldWeight[tid - distance] >= oldWeight[tid] )//check the max, and update accordingly
				{
					newDst[tid] = oldDst[tid - distance];
					newWeight[tid] = oldWeight[tid - distance];
					(*madeChanges) = 1;
				}
				else
				{
					newDst[tid] = oldDst[tid];
					newWeight[tid] = oldWeight[tid];
				}
			}
			else
			{
				newDst[tid] = oldDst[tid];
				newWeight[tid] = oldWeight[tid];
			}
		}
		else
		{
			newDst[tid] = oldDst[tid];
			newWeight[tid] = oldWeight[tid];	
		}
		tid += ( blockDim.x * gridDim.x );
	}
	return;
}
