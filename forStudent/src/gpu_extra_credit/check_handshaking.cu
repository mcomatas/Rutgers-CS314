/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void check_handshaking_gpu(int * strongNeighbor, int * matches, int numNodes) {
	/*YOUR CODE HERE*/
	int tid = blockIdx.x * blockDim.x + threadIdx.x;//this is the thread id and will be used as index
	while( tid < numNodes )//as long as thread id is within numNodes(array bounds)
	{
		if( tid == strongNeighbor[strongNeighbor[tid]] )
		{
			if( matches[tid] == -1 && matches[strongNeighbor[tid]] == -1 )//both need to equal -1, both nodes are unmatched
			{
				matches[tid] = strongNeighbor[tid];
				matches[strongNeighbor[tid]] = strongNeighbor[strongNeighbor[tid]];
			}
		}
		tid += ( blockDim.x * gridDim.x );
	}
	return;
}
