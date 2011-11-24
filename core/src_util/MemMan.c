/*
 * MemMan.c
 *
 *  Created on: Nov 24, 2011
 *      Author: cloudee
 */

#include "fy_util/MemMan.h"
typedef struct fy_memblockNode {
	struct fy_memblockNode *prev;
	struct fy_memblockNode *next;
	_FY_VLS(fy_ubyte,data);
} fy_memblockNode;

void fy_mmInit(fy_memblock *block) {
	block->last = block->first = fy_allocate(sizeof(fy_memblockNode));
	block->blocks = 0;
}

void fy_mmDestroy(fy_memblock *block) {
	fy_memblockNode *node, *next;
	node = block->first;
	do {
		next = node->next;
		free(node);
		node = next;
	} while (node != NULL);
	while (node != block->last) {
		node = node->next;
	}
}

void *fy_mmAllocate(fy_memblock *block, int size) {
	void *ret;
	fy_memblockNode *node = fy_allocate(sizeof(fy_memblockNode) + size);
	if (ret == NULL) {
		fy_fault("OUT OF MEMORY");
	}
	((fy_memblockNode*) block->last)->next = node;
	node->prev = block->last;
	block->last = node;
	block->blocks++;
	return node->data;
}

void fy_vmFree(fy_memblock *block, void *address) {

	fy_memblockNode *base = (fy_byte*) address - ((fy_memblockNode*) 0)->data;
	base->prev->next = base->next;
	if (base == block->last) {
		block->last = base->prev;
	} else {
		base->next->prev = base->prev;
	}
	fy_free(base);
	block->blocks--;
}
