/*
 **********************************************
 *  CS314 Principles of Programming Languages *
 *  Spring 2020                               *
 **********************************************
 */
#include <stdio.h>
#include <stdlib.h>

__global__ void markFilterEdges_gpu(int * src, int * dst, int * matches, int * keepEdges, int numEdges) {
	/*YOUR CODE HERE*/
	//basically check if source or dst is matched, then set to 1
	//if not matched then I can set to keepEdges[tid] = 0
	int tid = blockIdx.x * blockDim.x + threadIdx.x;//this is the thread id and will be used as index
	while( tid < numEdges )
	{
		if( matches[src[tid]] == -1 && matches[dst[tid]] == -1 )//either source or destination has an unmatched node, meaning we want to keep this edge
		{
			keepEdges[tid] = 1;//if we want to keep the edge, set it to 1
		}
		else
		{
			keepEdges[tid] = 0;//otherwise set it to 0
		}
		tid += ( blockDim.x * gridDim.x );
	}
	return;
}
