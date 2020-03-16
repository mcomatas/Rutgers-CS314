/*
 *********************************************
 *  314 Principles of Programming Languages  *
 *  Spring 2014                              *
 *  Authors: Ulrich Kremer                   *
 *           Hans Christian Woithe           *
 *********************************************
 */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "InstrUtils.h"
#include "Utils.h"

void deleteNode( Instruction** head_ref, Instruction* del )
{
	if( *head_ref == NULL || del == NULL )
	{
		return;
	}
	if( *head_ref == del )
	{
		*head_ref = del->next;
	}
	if( del->next != NULL )
	{
		del->next->prev = del->prev;
	}
	if( del->prev != NULL )
	{
		del->prev->next = del->next;
	}
	free( del );
	return;
}

int main()
{
	Instruction *head;

	head = ReadInstructionList(stdin);
	if (!head) {
		WARNING("No instructions\n");
		exit(EXIT_FAILURE);
	}
	/* YOUR CODE GOES HERE */

	Instruction *ptr = LastInstruction( head );
	Instruction *checker;

	while( ptr != NULL )//loop to mark all critical opcode
	{
		if( ptr->opcode == WRITE || ptr->opcode == READ )
		{
			ptr->critical = '1';
		}
		if( ptr->critical == '1' )
		{
			if( ptr->opcode == WRITE )
			{
				if( ptr->prev != NULL )
				{
					checker = ptr->prev;
				}
				else
				{
					checker = ptr;
				}
				
				while( checker != NULL )
				{
					if( checker->field1 == ptr->field1 )
					{
						checker->critical = '1';
						break;
					}
					checker = checker->prev;
				}
			}
			if( ptr->opcode == STORE  || ptr->opcode == LOAD )//|| ptr->opcode == LOADI )
			{
				if( ptr->prev != NULL )
				{
					checker = ptr->prev;
				}
				else
				{
					checker = ptr;
				}
				while( checker != NULL )
				{
					if( checker->field1 == ptr->field2 )
					{
						checker->critical = '1';
						break;
					}
					checker = checker->prev;
				}
			}
			if( ptr->opcode == MUL || ptr->opcode == ADD || ptr->opcode == SUB || ptr->opcode == AND || ptr->opcode == OR )
			{
				if( ptr->prev != NULL )
				{
					checker = ptr->prev;
				}
				else
				{
					checker = ptr;
				}
				int checkedRegs = 0;
				while( checker != NULL )
				{
					if( checker->field1 == ptr->field2 || checker->field1 == ptr->field3 )
					{
						checker->critical = '1';
						checkedRegs++;
						if( checkedRegs == 2 )
						{
							break;
						}
					}
					checker = checker->prev;
				}
			}
		}
		ptr = ptr->prev;
	}

	ptr = head;
	while( ptr != NULL )
	{
		if( ptr->critical != '1' )
		{
			deleteNode( &head, ptr );
		}
		ptr = ptr->next;
	}

	if (head) {
		PrintInstructionList(stdout, head);
		DestroyInstructionList(head);
	}
	return EXIT_SUCCESS;
}


