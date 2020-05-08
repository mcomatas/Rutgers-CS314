/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void exclusive_prefix_sum_gpu(int * oldSum, int * newSum, int distance, int numElements) {
	/*YOUR CODE HERE*/
	int tid = blockIdx.x * blockDim.x + threadIdx.x;//this is the thread id and will be used as index
	while( tid < numElements )
	{
		if( distance == 0 )//since it's exclusive prefix sum, when distance is 0 shift all values over to the right once
		{
			if( tid == 0 )
			{
				newSum[tid] = 0;
			}
			else
			{
				newSum[tid] = oldSum[tid - 1];
			}
		}
		else
		{
			if( tid - distance >= 0 )//if index - stride is still in the array, add those old sums together
			{
				newSum[tid] = oldSum[tid] + oldSum[tid - distance];
			}
			else//otherwise just move the element to the same index
			{
				newSum[tid] = oldSum[tid];
			}
		}
		tid += ( blockDim.x * gridDim.x );
	}
	return;
}
