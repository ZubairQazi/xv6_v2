// Memory layout

#define EXTMEM  0x100000            // Start of extended memory
#define PHYSTOP 0xE000000           // Top physical memory
#define DEVSPACE 0xFE000000         // Other devices are at high addresses

// Key addresses for address space layout (see kmap in vm.c for layout)
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

/*
 TODO 2: you will have to change this to the address of the top word in
 the stack page.  Note that KERNBASE is the first word in the kernel
 address space, so this is the word _right under_ that.
 */
// We need it to be under the kernel, so rather than hardfixing the value
// to 0x7FFFFFFF, we just changed it to be 1 under it, so we can just change
// the KERNBASE and it should still work
#define STACKBASE (KERNBASE - 0x1)        // First stack virtual address, KERNBASE - 1

#define V2P(a) (((uint) (a)) - KERNBASE)
#define P2V(a) (((void *) (a)) + KERNBASE)

#define V2P_WO(x) ((x) - KERNBASE)    // same as V2P, but without casts
#define P2V_WO(x) ((x) + KERNBASE)    // same as P2V, but without casts
