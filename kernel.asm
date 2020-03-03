
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 2d 10 80       	mov    $0x80102d80,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 6f 10 80       	push   $0x80106fc0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 a5 40 00 00       	call   80104100 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 6f 10 80       	push   $0x80106fc7
80100097:	50                   	push   %eax
80100098:	e8 53 3f 00 00       	call   80103ff0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 17 41 00 00       	call   80104200 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 b9 41 00 00       	call   80104320 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 3e 00 00       	call   80104030 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 8d 1e 00 00       	call   80102010 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 6f 10 80       	push   $0x80106fce
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 3f 00 00       	call   801040d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 47 1e 00 00       	jmp    80102010 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 6f 10 80       	push   $0x80106fdf
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 3e 00 00       	call   801040d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 3e 00 00       	call   80104090 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 f0 3f 00 00       	call   80104200 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 bf 40 00 00       	jmp    80104320 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 6f 10 80       	push   $0x80106fe6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 13 00 00       	call   80101670 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 6f 3f 00 00       	call   80104200 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 ce 39 00 00       	call   80103c90 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 c9 33 00 00       	call   801036a0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 35 40 00 00       	call   80104320 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 9d 12 00 00       	call   80101590 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 d5 3f 00 00       	call   80104320 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 3d 12 00 00       	call   80101590 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 82 22 00 00       	call   80102610 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ed 6f 10 80       	push   $0x80106fed
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 6b 7a 10 80 	movl   $0x80107a6b,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 63 3d 00 00       	call   80104120 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 01 70 10 80       	push   $0x80107001
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 d1 55 00 00       	call   801059f0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 18 55 00 00       	call   801059f0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 0c 55 00 00       	call   801059f0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 00 55 00 00       	call   801059f0 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 07 3f 00 00       	call   80104420 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 42 3e 00 00       	call   80104370 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 05 70 10 80       	push   $0x80107005
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 30 70 10 80 	movzbl -0x7fef8fd0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 5c 10 00 00       	call   80101670 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 e0 3b 00 00       	call   80104200 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 d4 3c 00 00       	call   80104320 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 0f 00 00       	call   80101590 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 0e 3c 00 00       	call   80104320 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 18 70 10 80       	mov    $0x80107018,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 33 3a 00 00       	call   80104200 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 1f 70 10 80       	push   $0x8010701f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 f8 39 00 00       	call   80104200 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 b3 3a 00 00       	call   80104320 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 45 35 00 00       	call   80103e40 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 b4 35 00 00       	jmp    80103f30 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 28 70 10 80       	push   $0x80107028
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 4b 37 00 00       	call   80104100 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 e2 17 00 00       	call   801021c0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec ec 00 00 00    	sub    $0xec,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 9f 2c 00 00       	call   801036a0 <myproc>
80100a01:	89 c3                	mov    %eax,%ebx
  // curproc->pages = 1;

  begin_op();
80100a03:	e8 68 20 00 00       	call   80102a70 <begin_op>

  if((ip = namei(path)) == 0){
80100a08:	83 ec 0c             	sub    $0xc,%esp
80100a0b:	ff 75 08             	pushl  0x8(%ebp)
80100a0e:	e8 cd 13 00 00       	call   80101de0 <namei>
80100a13:	83 c4 10             	add    $0x10,%esp
80100a16:	85 c0                	test   %eax,%eax
80100a18:	0f 84 50 01 00 00    	je     80100b6e <exec+0x17e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a1e:	83 ec 0c             	sub    $0xc,%esp
80100a21:	89 c6                	mov    %eax,%esi
80100a23:	50                   	push   %eax
80100a24:	e8 67 0b 00 00       	call   80101590 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a29:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a2f:	6a 34                	push   $0x34
80100a31:	6a 00                	push   $0x0
80100a33:	50                   	push   %eax
80100a34:	56                   	push   %esi
80100a35:	e8 36 0e 00 00       	call   80101870 <readi>
80100a3a:	83 c4 20             	add    $0x20,%esp
80100a3d:	83 f8 34             	cmp    $0x34,%eax
80100a40:	74 1e                	je     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	56                   	push   %esi
80100a46:	e8 d5 0d 00 00       	call   80101820 <iunlockput>
    end_op();
80100a4b:	e8 90 20 00 00       	call   80102ae0 <end_op>
80100a50:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5b:	5b                   	pop    %ebx
80100a5c:	5e                   	pop    %esi
80100a5d:	5f                   	pop    %edi
80100a5e:	5d                   	pop    %ebp
80100a5f:	c3                   	ret    
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 d6                	jne    80100a42 <exec+0x52>
    goto bad;
    
  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 0f 61 00 00       	call   80106b80 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 c7                	mov    %eax,%edi
80100a75:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
80100a7b:	74 c5                	je     80100a42 <exec+0x52>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a84:	00 
80100a85:	74 22                	je     80100aa9 <exec+0xb9>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph));
80100a87:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100a8d:	6a 20                	push   $0x20
80100a8f:	ff b5 40 ff ff ff    	pushl  -0xc0(%ebp)
80100a95:	50                   	push   %eax
80100a96:	56                   	push   %esi
80100a97:	e8 d4 0d 00 00       	call   80101870 <readi>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100a9c:	89 3c 24             	mov    %edi,(%esp)
80100a9f:	e8 5c 60 00 00       	call   80106b00 <freevm>
80100aa4:	83 c4 10             	add    $0x10,%esp
80100aa7:	eb 99                	jmp    80100a42 <exec+0x52>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100aa9:	83 ec 0c             	sub    $0xc,%esp
80100aac:	56                   	push   %esi
80100aad:	e8 6e 0d 00 00       	call   80101820 <iunlockput>
  end_op();
80100ab2:	e8 29 20 00 00       	call   80102ae0 <end_op>
  // Make the first inaccessible.  Use the second as the user stack.
  //sz = PGROUNDUP(sz);
  //if we assign it in the if statement, whats the point of the above line?
  // mem: 0x000...0xFFFF, stack is at 0xFFFF, so we alloc from 0xFFF to 0xFADD (S-PG)
  sz = PGROUNDUP(sz);
  if (allocuvm(pgdir, PGROUNDDOWN(STACKBASE), STACKBASE) == 0)
80100ab7:	83 c4 0c             	add    $0xc,%esp
80100aba:	68 ff ff ff 7f       	push   $0x7fffffff
80100abf:	68 00 f0 ff 7f       	push   $0x7ffff000
80100ac4:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100aca:	e8 01 5f 00 00       	call   801069d0 <allocuvm>
80100acf:	83 c4 10             	add    $0x10,%esp
80100ad2:	85 c0                	test   %eax,%eax
80100ad4:	74 7d                	je     80100b53 <exec+0x163>
  //sp = sz
  // change stack pointer from sz to newly 
  sp = STACKBASE;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad9:	31 ff                	xor    %edi,%edi
80100adb:	be ff ff ff 7f       	mov    $0x7fffffff,%esi
80100ae0:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100ae6:	8b 00                	mov    (%eax),%eax
80100ae8:	85 c0                	test   %eax,%eax
80100aea:	0f 84 a3 00 00 00    	je     80100b93 <exec+0x1a3>
80100af0:	89 9d 10 ff ff ff    	mov    %ebx,-0xf0(%ebp)
80100af6:	8b 9d 14 ff ff ff    	mov    -0xec(%ebp),%ebx
80100afc:	eb 21                	jmp    80100b1f <exec+0x12f>
80100afe:	66 90                	xchg   %ax,%ax
80100b00:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100b03:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  //sp = sz
  // change stack pointer from sz to newly 
  sp = STACKBASE;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b0a:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100b0d:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  //sp = sz
  // change stack pointer from sz to newly 
  sp = STACKBASE;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b13:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100b16:	85 c0                	test   %eax,%eax
80100b18:	74 73                	je     80100b8d <exec+0x19d>
    if(argc >= MAXARG)
80100b1a:	83 ff 20             	cmp    $0x20,%edi
80100b1d:	74 34                	je     80100b53 <exec+0x163>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b1f:	83 ec 0c             	sub    $0xc,%esp
80100b22:	50                   	push   %eax
80100b23:	e8 88 3a 00 00       	call   801045b0 <strlen>
80100b28:	f7 d0                	not    %eax
80100b2a:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b2c:	58                   	pop    %eax
80100b2d:	8b 45 0c             	mov    0xc(%ebp),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b30:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b33:	ff 34 b8             	pushl  (%eax,%edi,4)
80100b36:	e8 75 3a 00 00       	call   801045b0 <strlen>
80100b3b:	83 c0 01             	add    $0x1,%eax
80100b3e:	50                   	push   %eax
80100b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b42:	ff 34 b8             	pushl  (%eax,%edi,4)
80100b45:	56                   	push   %esi
80100b46:	53                   	push   %ebx
80100b47:	e8 44 63 00 00       	call   80106e90 <copyout>
80100b4c:	83 c4 20             	add    $0x20,%esp
80100b4f:	85 c0                	test   %eax,%eax
80100b51:	79 ad                	jns    80100b00 <exec+0x110>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b53:	83 ec 0c             	sub    $0xc,%esp
80100b56:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b5c:	e8 9f 5f 00 00       	call   80106b00 <freevm>
80100b61:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b69:	e9 ea fe ff ff       	jmp    80100a58 <exec+0x68>
  // curproc->pages = 1;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100b6e:	e8 6d 1f 00 00       	call   80102ae0 <end_op>
    cprintf("exec: fail\n");
80100b73:	83 ec 0c             	sub    $0xc,%esp
80100b76:	68 41 70 10 80       	push   $0x80107041
80100b7b:	e8 e0 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100b80:	83 c4 10             	add    $0x10,%esp
80100b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b88:	e9 cb fe ff ff       	jmp    80100a58 <exec+0x68>
80100b8d:	8b 9d 10 ff ff ff    	mov    -0xf0(%ebp),%ebx
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b93:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100b9a:	89 f2                	mov    %esi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100b9c:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ba3:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ba7:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100bae:	ff ff ff 
  ustack[1] = argc;
80100bb1:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bb7:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100bb9:	83 c0 0c             	add    $0xc,%eax
80100bbc:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bbe:	50                   	push   %eax
80100bbf:	51                   	push   %ecx
80100bc0:	56                   	push   %esi
80100bc1:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bc7:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bcd:	e8 be 62 00 00       	call   80106e90 <copyout>
80100bd2:	83 c4 10             	add    $0x10,%esp
80100bd5:	85 c0                	test   %eax,%eax
80100bd7:	0f 88 76 ff ff ff    	js     80100b53 <exec+0x163>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100bdd:	8b 45 08             	mov    0x8(%ebp),%eax
80100be0:	0f b6 10             	movzbl (%eax),%edx
80100be3:	84 d2                	test   %dl,%dl
80100be5:	74 1c                	je     80100c03 <exec+0x213>
80100be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100bea:	83 c0 01             	add    $0x1,%eax
80100bed:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s == '/')
      last = s+1;
80100bf0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100bf3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100bf6:	0f 44 c8             	cmove  %eax,%ecx
80100bf9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100bfc:	84 d2                	test   %dl,%dl
80100bfe:	75 f0                	jne    80100bf0 <exec+0x200>
80100c00:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c03:	8d 43 6c             	lea    0x6c(%ebx),%eax
80100c06:	83 ec 04             	sub    $0x4,%esp
80100c09:	6a 10                	push   $0x10
80100c0b:	ff 75 08             	pushl  0x8(%ebp)
80100c0e:	50                   	push   %eax
80100c0f:	e8 5c 39 00 00       	call   80104570 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100c14:	8b 43 04             	mov    0x4(%ebx),%eax
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100c17:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  curproc->tf->eip = elf.entry;  // main
80100c1d:	8b 53 18             	mov    0x18(%ebx),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100c20:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  curproc->pgdir = pgdir;
80100c26:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
80100c2c:	89 43 04             	mov    %eax,0x4(%ebx)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100c2f:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100c35:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100c38:	8b 53 18             	mov    0x18(%ebx),%edx
80100c3b:	89 72 44             	mov    %esi,0x44(%edx)
  curproc->pages = 1;
80100c3e:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  switchuvm(curproc);
80100c45:	89 1c 24             	mov    %ebx,(%esp)
80100c48:	e8 33 5b 00 00       	call   80106780 <switchuvm>
  freevm(oldpgdir);
80100c4d:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
80100c53:	89 04 24             	mov    %eax,(%esp)
80100c56:	e8 a5 5e 00 00       	call   80106b00 <freevm>
  return 0;
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	31 c0                	xor    %eax,%eax
80100c60:	e9 f3 fd ff ff       	jmp    80100a58 <exec+0x68>
80100c65:	66 90                	xchg   %ax,%ax
80100c67:	66 90                	xchg   %ax,%ax
80100c69:	66 90                	xchg   %ax,%ax
80100c6b:	66 90                	xchg   %ax,%ax
80100c6d:	66 90                	xchg   %ax,%ax
80100c6f:	90                   	nop

80100c70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c70:	55                   	push   %ebp
80100c71:	89 e5                	mov    %esp,%ebp
80100c73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c76:	68 4d 70 10 80       	push   $0x8010704d
80100c7b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c80:	e8 7b 34 00 00       	call   80104100 <initlock>
}
80100c85:	83 c4 10             	add    $0x10,%esp
80100c88:	c9                   	leave  
80100c89:	c3                   	ret    
80100c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100c90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c90:	55                   	push   %ebp
80100c91:	89 e5                	mov    %esp,%ebp
80100c93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c94:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c99:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c9c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ca1:	e8 5a 35 00 00       	call   80104200 <acquire>
80100ca6:	83 c4 10             	add    $0x10,%esp
80100ca9:	eb 10                	jmp    80100cbb <filealloc+0x2b>
80100cab:	90                   	nop
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cb0:	83 c3 18             	add    $0x18,%ebx
80100cb3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100cb9:	74 25                	je     80100ce0 <filealloc+0x50>
    if(f->ref == 0){
80100cbb:	8b 43 04             	mov    0x4(%ebx),%eax
80100cbe:	85 c0                	test   %eax,%eax
80100cc0:	75 ee                	jne    80100cb0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100cc2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100cc5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ccc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cd1:	e8 4a 36 00 00       	call   80104320 <release>
      return f;
80100cd6:	89 d8                	mov    %ebx,%eax
80100cd8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100cdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cde:	c9                   	leave  
80100cdf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100ce0:	83 ec 0c             	sub    $0xc,%esp
80100ce3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ce8:	e8 33 36 00 00       	call   80104320 <release>
  return 0;
80100ced:	83 c4 10             	add    $0x10,%esp
80100cf0:	31 c0                	xor    %eax,%eax
}
80100cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf5:	c9                   	leave  
80100cf6:	c3                   	ret    
80100cf7:	89 f6                	mov    %esi,%esi
80100cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100d00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d00:	55                   	push   %ebp
80100d01:	89 e5                	mov    %esp,%ebp
80100d03:	53                   	push   %ebx
80100d04:	83 ec 10             	sub    $0x10,%esp
80100d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d0a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d0f:	e8 ec 34 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100d14:	8b 43 04             	mov    0x4(%ebx),%eax
80100d17:	83 c4 10             	add    $0x10,%esp
80100d1a:	85 c0                	test   %eax,%eax
80100d1c:	7e 1a                	jle    80100d38 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100d1e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100d21:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100d24:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d27:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d2c:	e8 ef 35 00 00       	call   80104320 <release>
  return f;
}
80100d31:	89 d8                	mov    %ebx,%eax
80100d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d36:	c9                   	leave  
80100d37:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100d38:	83 ec 0c             	sub    $0xc,%esp
80100d3b:	68 54 70 10 80       	push   $0x80107054
80100d40:	e8 2b f6 ff ff       	call   80100370 <panic>
80100d45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100d50 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	57                   	push   %edi
80100d54:	56                   	push   %esi
80100d55:	53                   	push   %ebx
80100d56:	83 ec 28             	sub    $0x28,%esp
80100d59:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100d5c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d61:	e8 9a 34 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100d66:	8b 47 04             	mov    0x4(%edi),%eax
80100d69:	83 c4 10             	add    $0x10,%esp
80100d6c:	85 c0                	test   %eax,%eax
80100d6e:	0f 8e 9b 00 00 00    	jle    80100e0f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100d74:	83 e8 01             	sub    $0x1,%eax
80100d77:	85 c0                	test   %eax,%eax
80100d79:	89 47 04             	mov    %eax,0x4(%edi)
80100d7c:	74 1a                	je     80100d98 <fileclose+0x48>
    release(&ftable.lock);
80100d7e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d88:	5b                   	pop    %ebx
80100d89:	5e                   	pop    %esi
80100d8a:	5f                   	pop    %edi
80100d8b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100d8c:	e9 8f 35 00 00       	jmp    80104320 <release>
80100d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100d98:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100d9c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100d9e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100da1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100da4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100daa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100dad:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100db0:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100db5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100db8:	e8 63 35 00 00       	call   80104320 <release>

  if(ff.type == FD_PIPE)
80100dbd:	83 c4 10             	add    $0x10,%esp
80100dc0:	83 fb 01             	cmp    $0x1,%ebx
80100dc3:	74 13                	je     80100dd8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100dc5:	83 fb 02             	cmp    $0x2,%ebx
80100dc8:	74 26                	je     80100df0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dcd:	5b                   	pop    %ebx
80100dce:	5e                   	pop    %esi
80100dcf:	5f                   	pop    %edi
80100dd0:	5d                   	pop    %ebp
80100dd1:	c3                   	ret    
80100dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100dd8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ddc:	83 ec 08             	sub    $0x8,%esp
80100ddf:	53                   	push   %ebx
80100de0:	56                   	push   %esi
80100de1:	e8 2a 24 00 00       	call   80103210 <pipeclose>
80100de6:	83 c4 10             	add    $0x10,%esp
80100de9:	eb df                	jmp    80100dca <fileclose+0x7a>
80100deb:	90                   	nop
80100dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100df0:	e8 7b 1c 00 00       	call   80102a70 <begin_op>
    iput(ff.ip);
80100df5:	83 ec 0c             	sub    $0xc,%esp
80100df8:	ff 75 e0             	pushl  -0x20(%ebp)
80100dfb:	e8 c0 08 00 00       	call   801016c0 <iput>
    end_op();
80100e00:	83 c4 10             	add    $0x10,%esp
  }
}
80100e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e06:	5b                   	pop    %ebx
80100e07:	5e                   	pop    %esi
80100e08:	5f                   	pop    %edi
80100e09:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100e0a:	e9 d1 1c 00 00       	jmp    80102ae0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100e0f:	83 ec 0c             	sub    $0xc,%esp
80100e12:	68 5c 70 10 80       	push   $0x8010705c
80100e17:	e8 54 f5 ff ff       	call   80100370 <panic>
80100e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 04             	sub    $0x4,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e2d:	75 31                	jne    80100e60 <filestat+0x40>
    ilock(f->ip);
80100e2f:	83 ec 0c             	sub    $0xc,%esp
80100e32:	ff 73 10             	pushl  0x10(%ebx)
80100e35:	e8 56 07 00 00       	call   80101590 <ilock>
    stati(f->ip, st);
80100e3a:	58                   	pop    %eax
80100e3b:	5a                   	pop    %edx
80100e3c:	ff 75 0c             	pushl  0xc(%ebp)
80100e3f:	ff 73 10             	pushl  0x10(%ebx)
80100e42:	e8 f9 09 00 00       	call   80101840 <stati>
    iunlock(f->ip);
80100e47:	59                   	pop    %ecx
80100e48:	ff 73 10             	pushl  0x10(%ebx)
80100e4b:	e8 20 08 00 00       	call   80101670 <iunlock>
    return 0;
80100e50:	83 c4 10             	add    $0x10,%esp
80100e53:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e58:	c9                   	leave  
80100e59:	c3                   	ret    
80100e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e68:	c9                   	leave  
80100e69:	c3                   	ret    
80100e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 0c             	sub    $0xc,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100e7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100e82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e86:	74 60                	je     80100ee8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100e88:	8b 03                	mov    (%ebx),%eax
80100e8a:	83 f8 01             	cmp    $0x1,%eax
80100e8d:	74 41                	je     80100ed0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e8f:	83 f8 02             	cmp    $0x2,%eax
80100e92:	75 5b                	jne    80100eef <fileread+0x7f>
    ilock(f->ip);
80100e94:	83 ec 0c             	sub    $0xc,%esp
80100e97:	ff 73 10             	pushl  0x10(%ebx)
80100e9a:	e8 f1 06 00 00       	call   80101590 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e9f:	57                   	push   %edi
80100ea0:	ff 73 14             	pushl  0x14(%ebx)
80100ea3:	56                   	push   %esi
80100ea4:	ff 73 10             	pushl  0x10(%ebx)
80100ea7:	e8 c4 09 00 00       	call   80101870 <readi>
80100eac:	83 c4 20             	add    $0x20,%esp
80100eaf:	85 c0                	test   %eax,%eax
80100eb1:	89 c6                	mov    %eax,%esi
80100eb3:	7e 03                	jle    80100eb8 <fileread+0x48>
      f->off += r;
80100eb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100eb8:	83 ec 0c             	sub    $0xc,%esp
80100ebb:	ff 73 10             	pushl  0x10(%ebx)
80100ebe:	e8 ad 07 00 00       	call   80101670 <iunlock>
    return r;
80100ec3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100ec6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ecb:	5b                   	pop    %ebx
80100ecc:	5e                   	pop    %esi
80100ecd:	5f                   	pop    %edi
80100ece:	5d                   	pop    %ebp
80100ecf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100ed0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ed3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100ed6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed9:	5b                   	pop    %ebx
80100eda:	5e                   	pop    %esi
80100edb:	5f                   	pop    %edi
80100edc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100edd:	e9 ce 24 00 00       	jmp    801033b0 <piperead>
80100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100eed:	eb d9                	jmp    80100ec8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 66 70 10 80       	push   $0x80107066
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 1c             	sub    $0x1c,%esp
80100f09:	8b 75 08             	mov    0x8(%ebp),%esi
80100f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100f0f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f13:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100f16:	8b 45 10             	mov    0x10(%ebp),%eax
80100f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100f1c:	0f 84 aa 00 00 00    	je     80100fcc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100f22:	8b 06                	mov    (%esi),%eax
80100f24:	83 f8 01             	cmp    $0x1,%eax
80100f27:	0f 84 c2 00 00 00    	je     80100fef <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f2d:	83 f8 02             	cmp    $0x2,%eax
80100f30:	0f 85 d8 00 00 00    	jne    8010100e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f39:	31 ff                	xor    %edi,%edi
80100f3b:	85 c0                	test   %eax,%eax
80100f3d:	7f 34                	jg     80100f73 <filewrite+0x73>
80100f3f:	e9 9c 00 00 00       	jmp    80100fe0 <filewrite+0xe0>
80100f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100f48:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100f4b:	83 ec 0c             	sub    $0xc,%esp
80100f4e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100f51:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80100f54:	e8 17 07 00 00       	call   80101670 <iunlock>
      end_op();
80100f59:	e8 82 1b 00 00       	call   80102ae0 <end_op>
80100f5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f61:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80100f64:	39 d8                	cmp    %ebx,%eax
80100f66:	0f 85 95 00 00 00    	jne    80101001 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80100f6c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100f6e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80100f71:	7e 6d                	jle    80100fe0 <filewrite+0xe0>
      int n1 = n - i;
80100f73:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100f76:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80100f7b:	29 fb                	sub    %edi,%ebx
80100f7d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80100f83:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80100f86:	e8 e5 1a 00 00       	call   80102a70 <begin_op>
      ilock(f->ip);
80100f8b:	83 ec 0c             	sub    $0xc,%esp
80100f8e:	ff 76 10             	pushl  0x10(%esi)
80100f91:	e8 fa 05 00 00       	call   80101590 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f96:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f99:	53                   	push   %ebx
80100f9a:	ff 76 14             	pushl  0x14(%esi)
80100f9d:	01 f8                	add    %edi,%eax
80100f9f:	50                   	push   %eax
80100fa0:	ff 76 10             	pushl  0x10(%esi)
80100fa3:	e8 c8 09 00 00       	call   80101970 <writei>
80100fa8:	83 c4 20             	add    $0x20,%esp
80100fab:	85 c0                	test   %eax,%eax
80100fad:	7f 99                	jg     80100f48 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 76 10             	pushl  0x10(%esi)
80100fb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100fb8:	e8 b3 06 00 00       	call   80101670 <iunlock>
      end_op();
80100fbd:	e8 1e 1b 00 00       	call   80102ae0 <end_op>

      if(r < 0)
80100fc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100fc5:	83 c4 10             	add    $0x10,%esp
80100fc8:	85 c0                	test   %eax,%eax
80100fca:	74 98                	je     80100f64 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100fcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret    
80100fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80100fe0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80100fe3:	75 e7                	jne    80100fcc <filewrite+0xcc>
  }
  panic("filewrite");
}
80100fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe8:	89 f8                	mov    %edi,%eax
80100fea:	5b                   	pop    %ebx
80100feb:	5e                   	pop    %esi
80100fec:	5f                   	pop    %edi
80100fed:	5d                   	pop    %ebp
80100fee:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100fef:	8b 46 0c             	mov    0xc(%esi),%eax
80100ff2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff8:	5b                   	pop    %ebx
80100ff9:	5e                   	pop    %esi
80100ffa:	5f                   	pop    %edi
80100ffb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80100ffc:	e9 af 22 00 00       	jmp    801032b0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101001:	83 ec 0c             	sub    $0xc,%esp
80101004:	68 6f 70 10 80       	push   $0x8010706f
80101009:	e8 62 f3 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010100e:	83 ec 0c             	sub    $0xc,%esp
80101011:	68 75 70 10 80       	push   $0x80107075
80101016:	e8 55 f3 ff ff       	call   80100370 <panic>
8010101b:	66 90                	xchg   %ax,%ax
8010101d:	66 90                	xchg   %ax,%ax
8010101f:	90                   	nop

80101020 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101029:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010102f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101032:	85 c9                	test   %ecx,%ecx
80101034:	0f 84 85 00 00 00    	je     801010bf <balloc+0x9f>
8010103a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101041:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101044:	83 ec 08             	sub    $0x8,%esp
80101047:	89 f0                	mov    %esi,%eax
80101049:	c1 f8 0c             	sar    $0xc,%eax
8010104c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101052:	50                   	push   %eax
80101053:	ff 75 d8             	pushl  -0x28(%ebp)
80101056:	e8 75 f0 ff ff       	call   801000d0 <bread>
8010105b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010105e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101063:	83 c4 10             	add    $0x10,%esp
80101066:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101069:	31 c0                	xor    %eax,%eax
8010106b:	eb 2d                	jmp    8010109a <balloc+0x7a>
8010106d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101070:	89 c1                	mov    %eax,%ecx
80101072:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101077:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010107a:	83 e1 07             	and    $0x7,%ecx
8010107d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010107f:	89 c1                	mov    %eax,%ecx
80101081:	c1 f9 03             	sar    $0x3,%ecx
80101084:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101089:	85 d7                	test   %edx,%edi
8010108b:	74 43                	je     801010d0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010108d:	83 c0 01             	add    $0x1,%eax
80101090:	83 c6 01             	add    $0x1,%esi
80101093:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101098:	74 05                	je     8010109f <balloc+0x7f>
8010109a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010109d:	72 d1                	jb     80101070 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801010a5:	e8 36 f1 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010aa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801010b1:	83 c4 10             	add    $0x10,%esp
801010b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b7:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801010bd:	77 82                	ja     80101041 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 7f 70 10 80       	push   $0x8010707f
801010c7:	e8 a4 f2 ff ff       	call   80100370 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801010d0:	09 fa                	or     %edi,%edx
801010d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801010d5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801010d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801010dc:	57                   	push   %edi
801010dd:	e8 6e 1b 00 00       	call   80102c50 <log_write>
        brelse(bp);
801010e2:	89 3c 24             	mov    %edi,(%esp)
801010e5:	e8 f6 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801010ea:	58                   	pop    %eax
801010eb:	5a                   	pop    %edx
801010ec:	56                   	push   %esi
801010ed:	ff 75 d8             	pushl  -0x28(%ebp)
801010f0:	e8 db ef ff ff       	call   801000d0 <bread>
801010f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801010f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801010fa:	83 c4 0c             	add    $0xc,%esp
801010fd:	68 00 02 00 00       	push   $0x200
80101102:	6a 00                	push   $0x0
80101104:	50                   	push   %eax
80101105:	e8 66 32 00 00       	call   80104370 <memset>
  log_write(bp);
8010110a:	89 1c 24             	mov    %ebx,(%esp)
8010110d:	e8 3e 1b 00 00       	call   80102c50 <log_write>
  brelse(bp);
80101112:	89 1c 24             	mov    %ebx,(%esp)
80101115:	e8 c6 f0 ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010111a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010111d:	89 f0                	mov    %esi,%eax
8010111f:	5b                   	pop    %ebx
80101120:	5e                   	pop    %esi
80101121:	5f                   	pop    %edi
80101122:	5d                   	pop    %ebp
80101123:	c3                   	ret    
80101124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010112a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101130 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101138:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010113a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010113f:	83 ec 28             	sub    $0x28,%esp
80101142:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101145:	68 e0 09 11 80       	push   $0x801109e0
8010114a:	e8 b1 30 00 00       	call   80104200 <acquire>
8010114f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101152:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101155:	eb 1b                	jmp    80101172 <iget+0x42>
80101157:	89 f6                	mov    %esi,%esi
80101159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101160:	85 f6                	test   %esi,%esi
80101162:	74 44                	je     801011a8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101164:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010116a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101170:	74 4e                	je     801011c0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101172:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101175:	85 c9                	test   %ecx,%ecx
80101177:	7e e7                	jle    80101160 <iget+0x30>
80101179:	39 3b                	cmp    %edi,(%ebx)
8010117b:	75 e3                	jne    80101160 <iget+0x30>
8010117d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101180:	75 de                	jne    80101160 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101182:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101185:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101188:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010118a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010118f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101192:	e8 89 31 00 00       	call   80104320 <release>
      return ip;
80101197:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	89 f0                	mov    %esi,%eax
8010119f:	5b                   	pop    %ebx
801011a0:	5e                   	pop    %esi
801011a1:	5f                   	pop    %edi
801011a2:	5d                   	pop    %ebp
801011a3:	c3                   	ret    
801011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011a8:	85 c9                	test   %ecx,%ecx
801011aa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ad:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011b3:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011b9:	75 b7                	jne    80101172 <iget+0x42>
801011bb:	90                   	nop
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801011c0:	85 f6                	test   %esi,%esi
801011c2:	74 2d                	je     801011f1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801011c4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801011c7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801011c9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801011cc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801011d3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801011da:	68 e0 09 11 80       	push   $0x801109e0
801011df:	e8 3c 31 00 00       	call   80104320 <release>

  return ip;
801011e4:	83 c4 10             	add    $0x10,%esp
}
801011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ea:	89 f0                	mov    %esi,%eax
801011ec:	5b                   	pop    %ebx
801011ed:	5e                   	pop    %esi
801011ee:	5f                   	pop    %edi
801011ef:	5d                   	pop    %ebp
801011f0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	68 95 70 10 80       	push   $0x80107095
801011f9:	e8 72 f1 ff ff       	call   80100370 <panic>
801011fe:	66 90                	xchg   %ax,%ax

80101200 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	89 c6                	mov    %eax,%esi
80101208:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010120b:	83 fa 0b             	cmp    $0xb,%edx
8010120e:	77 18                	ja     80101228 <bmap+0x28>
80101210:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101213:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101216:	85 c0                	test   %eax,%eax
80101218:	74 76                	je     80101290 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	5b                   	pop    %ebx
8010121e:	5e                   	pop    %esi
8010121f:	5f                   	pop    %edi
80101220:	5d                   	pop    %ebp
80101221:	c3                   	ret    
80101222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101228:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010122b:	83 fb 7f             	cmp    $0x7f,%ebx
8010122e:	0f 87 83 00 00 00    	ja     801012b7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101234:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010123a:	85 c0                	test   %eax,%eax
8010123c:	74 6a                	je     801012a8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010123e:	83 ec 08             	sub    $0x8,%esp
80101241:	50                   	push   %eax
80101242:	ff 36                	pushl  (%esi)
80101244:	e8 87 ee ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101249:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010124d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101250:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101252:	8b 1a                	mov    (%edx),%ebx
80101254:	85 db                	test   %ebx,%ebx
80101256:	75 1d                	jne    80101275 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101258:	8b 06                	mov    (%esi),%eax
8010125a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010125d:	e8 be fd ff ff       	call   80101020 <balloc>
80101262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101265:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101268:	89 c3                	mov    %eax,%ebx
8010126a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 de 19 00 00       	call   80102c50 <log_write>
80101272:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101275:	83 ec 0c             	sub    $0xc,%esp
80101278:	57                   	push   %edi
80101279:	e8 62 ef ff ff       	call   801001e0 <brelse>
8010127e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101281:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101284:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101286:	5b                   	pop    %ebx
80101287:	5e                   	pop    %esi
80101288:	5f                   	pop    %edi
80101289:	5d                   	pop    %ebp
8010128a:	c3                   	ret    
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101290:	8b 06                	mov    (%esi),%eax
80101292:	e8 89 fd ff ff       	call   80101020 <balloc>
80101297:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010129a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129d:	5b                   	pop    %ebx
8010129e:	5e                   	pop    %esi
8010129f:	5f                   	pop    %edi
801012a0:	5d                   	pop    %ebp
801012a1:	c3                   	ret    
801012a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801012a8:	8b 06                	mov    (%esi),%eax
801012aa:	e8 71 fd ff ff       	call   80101020 <balloc>
801012af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801012b5:	eb 87                	jmp    8010123e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801012b7:	83 ec 0c             	sub    $0xc,%esp
801012ba:	68 a5 70 10 80       	push   $0x801070a5
801012bf:	e8 ac f0 ff ff       	call   80100370 <panic>
801012c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012d0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	56                   	push   %esi
801012d4:	53                   	push   %ebx
801012d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801012d8:	83 ec 08             	sub    $0x8,%esp
801012db:	6a 01                	push   $0x1
801012dd:	ff 75 08             	pushl  0x8(%ebp)
801012e0:	e8 eb ed ff ff       	call   801000d0 <bread>
801012e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801012ea:	83 c4 0c             	add    $0xc,%esp
801012ed:	6a 1c                	push   $0x1c
801012ef:	50                   	push   %eax
801012f0:	56                   	push   %esi
801012f1:	e8 2a 31 00 00       	call   80104420 <memmove>
  brelse(bp);
801012f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801012f9:	83 c4 10             	add    $0x10,%esp
}
801012fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012ff:	5b                   	pop    %ebx
80101300:	5e                   	pop    %esi
80101301:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101302:	e9 d9 ee ff ff       	jmp    801001e0 <brelse>
80101307:	89 f6                	mov    %esi,%esi
80101309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101310 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	56                   	push   %esi
80101314:	53                   	push   %ebx
80101315:	89 d3                	mov    %edx,%ebx
80101317:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101319:	83 ec 08             	sub    $0x8,%esp
8010131c:	68 c0 09 11 80       	push   $0x801109c0
80101321:	50                   	push   %eax
80101322:	e8 a9 ff ff ff       	call   801012d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101327:	58                   	pop    %eax
80101328:	5a                   	pop    %edx
80101329:	89 da                	mov    %ebx,%edx
8010132b:	c1 ea 0c             	shr    $0xc,%edx
8010132e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101334:	52                   	push   %edx
80101335:	56                   	push   %esi
80101336:	e8 95 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010133b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010133d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101343:	ba 01 00 00 00       	mov    $0x1,%edx
80101348:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010134b:	c1 fb 03             	sar    $0x3,%ebx
8010134e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101351:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101353:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101358:	85 d1                	test   %edx,%ecx
8010135a:	74 27                	je     80101383 <bfree+0x73>
8010135c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010135e:	f7 d2                	not    %edx
80101360:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101362:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101365:	21 d0                	and    %edx,%eax
80101367:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010136b:	56                   	push   %esi
8010136c:	e8 df 18 00 00       	call   80102c50 <log_write>
  brelse(bp);
80101371:	89 34 24             	mov    %esi,(%esp)
80101374:	e8 67 ee ff ff       	call   801001e0 <brelse>
}
80101379:	83 c4 10             	add    $0x10,%esp
8010137c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5d                   	pop    %ebp
80101382:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101383:	83 ec 0c             	sub    $0xc,%esp
80101386:	68 b8 70 10 80       	push   $0x801070b8
8010138b:	e8 e0 ef ff ff       	call   80100370 <panic>

80101390 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	53                   	push   %ebx
80101394:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101399:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010139c:	68 cb 70 10 80       	push   $0x801070cb
801013a1:	68 e0 09 11 80       	push   $0x801109e0
801013a6:	e8 55 2d 00 00       	call   80104100 <initlock>
801013ab:	83 c4 10             	add    $0x10,%esp
801013ae:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801013b0:	83 ec 08             	sub    $0x8,%esp
801013b3:	68 d2 70 10 80       	push   $0x801070d2
801013b8:	53                   	push   %ebx
801013b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bf:	e8 2c 2c 00 00       	call   80103ff0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801013c4:	83 c4 10             	add    $0x10,%esp
801013c7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801013cd:	75 e1                	jne    801013b0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801013cf:	83 ec 08             	sub    $0x8,%esp
801013d2:	68 c0 09 11 80       	push   $0x801109c0
801013d7:	ff 75 08             	pushl  0x8(%ebp)
801013da:	e8 f1 fe ff ff       	call   801012d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801013df:	ff 35 d8 09 11 80    	pushl  0x801109d8
801013e5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801013eb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801013f1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801013f7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801013fd:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101403:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101409:	68 38 71 10 80       	push   $0x80107138
8010140e:	e8 4d f2 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101413:	83 c4 30             	add    $0x30,%esp
80101416:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101419:	c9                   	leave  
8010141a:	c3                   	ret    
8010141b:	90                   	nop
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101420 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	53                   	push   %ebx
80101426:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101429:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101430:	8b 45 0c             	mov    0xc(%ebp),%eax
80101433:	8b 75 08             	mov    0x8(%ebp),%esi
80101436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101439:	0f 86 91 00 00 00    	jbe    801014d0 <ialloc+0xb0>
8010143f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101444:	eb 21                	jmp    80101467 <ialloc+0x47>
80101446:	8d 76 00             	lea    0x0(%esi),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101450:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101453:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101456:	57                   	push   %edi
80101457:	e8 84 ed ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010145c:	83 c4 10             	add    $0x10,%esp
8010145f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101465:	76 69                	jbe    801014d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101467:	89 d8                	mov    %ebx,%eax
80101469:	83 ec 08             	sub    $0x8,%esp
8010146c:	c1 e8 03             	shr    $0x3,%eax
8010146f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101475:	50                   	push   %eax
80101476:	56                   	push   %esi
80101477:	e8 54 ec ff ff       	call   801000d0 <bread>
8010147c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010147e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101480:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101483:	83 e0 07             	and    $0x7,%eax
80101486:	c1 e0 06             	shl    $0x6,%eax
80101489:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010148d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101491:	75 bd                	jne    80101450 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101493:	83 ec 04             	sub    $0x4,%esp
80101496:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101499:	6a 40                	push   $0x40
8010149b:	6a 00                	push   $0x0
8010149d:	51                   	push   %ecx
8010149e:	e8 cd 2e 00 00       	call   80104370 <memset>
      dip->type = type;
801014a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801014a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801014aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801014ad:	89 3c 24             	mov    %edi,(%esp)
801014b0:	e8 9b 17 00 00       	call   80102c50 <log_write>
      brelse(bp);
801014b5:	89 3c 24             	mov    %edi,(%esp)
801014b8:	e8 23 ed ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801014bd:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801014c3:	89 da                	mov    %ebx,%edx
801014c5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801014c7:	5b                   	pop    %ebx
801014c8:	5e                   	pop    %esi
801014c9:	5f                   	pop    %edi
801014ca:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801014cb:	e9 60 fc ff ff       	jmp    80101130 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801014d0:	83 ec 0c             	sub    $0xc,%esp
801014d3:	68 d8 70 10 80       	push   $0x801070d8
801014d8:	e8 93 ee ff ff       	call   80100370 <panic>
801014dd:	8d 76 00             	lea    0x0(%esi),%esi

801014e0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	56                   	push   %esi
801014e4:	53                   	push   %ebx
801014e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014e8:	83 ec 08             	sub    $0x8,%esp
801014eb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014ee:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014f1:	c1 e8 03             	shr    $0x3,%eax
801014f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801014fa:	50                   	push   %eax
801014fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801014fe:	e8 cd eb ff ff       	call   801000d0 <bread>
80101503:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101505:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101508:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010150c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010150f:	83 e0 07             	and    $0x7,%eax
80101512:	c1 e0 06             	shl    $0x6,%eax
80101515:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101519:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010151c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101520:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101523:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101527:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010152b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010152f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101533:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101537:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010153a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010153d:	6a 34                	push   $0x34
8010153f:	53                   	push   %ebx
80101540:	50                   	push   %eax
80101541:	e8 da 2e 00 00       	call   80104420 <memmove>
  log_write(bp);
80101546:	89 34 24             	mov    %esi,(%esp)
80101549:	e8 02 17 00 00       	call   80102c50 <log_write>
  brelse(bp);
8010154e:	89 75 08             	mov    %esi,0x8(%ebp)
80101551:	83 c4 10             	add    $0x10,%esp
}
80101554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101557:	5b                   	pop    %ebx
80101558:	5e                   	pop    %esi
80101559:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010155a:	e9 81 ec ff ff       	jmp    801001e0 <brelse>
8010155f:	90                   	nop

80101560 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	83 ec 10             	sub    $0x10,%esp
80101567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010156a:	68 e0 09 11 80       	push   $0x801109e0
8010156f:	e8 8c 2c 00 00       	call   80104200 <acquire>
  ip->ref++;
80101574:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101578:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010157f:	e8 9c 2d 00 00       	call   80104320 <release>
  return ip;
}
80101584:	89 d8                	mov    %ebx,%eax
80101586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101589:	c9                   	leave  
8010158a:	c3                   	ret    
8010158b:	90                   	nop
8010158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101590 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101598:	85 db                	test   %ebx,%ebx
8010159a:	0f 84 b7 00 00 00    	je     80101657 <ilock+0xc7>
801015a0:	8b 53 08             	mov    0x8(%ebx),%edx
801015a3:	85 d2                	test   %edx,%edx
801015a5:	0f 8e ac 00 00 00    	jle    80101657 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
801015ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801015ae:	83 ec 0c             	sub    $0xc,%esp
801015b1:	50                   	push   %eax
801015b2:	e8 79 2a 00 00       	call   80104030 <acquiresleep>

  if(ip->valid == 0){
801015b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801015ba:	83 c4 10             	add    $0x10,%esp
801015bd:	85 c0                	test   %eax,%eax
801015bf:	74 0f                	je     801015d0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801015c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015c4:	5b                   	pop    %ebx
801015c5:	5e                   	pop    %esi
801015c6:	5d                   	pop    %ebp
801015c7:	c3                   	ret    
801015c8:	90                   	nop
801015c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d0:	8b 43 04             	mov    0x4(%ebx),%eax
801015d3:	83 ec 08             	sub    $0x8,%esp
801015d6:	c1 e8 03             	shr    $0x3,%eax
801015d9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015df:	50                   	push   %eax
801015e0:	ff 33                	pushl  (%ebx)
801015e2:	e8 e9 ea ff ff       	call   801000d0 <bread>
801015e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015f9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015fc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801015ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101603:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101607:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010160b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010160f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101613:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101617:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010161b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010161e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101621:	6a 34                	push   $0x34
80101623:	50                   	push   %eax
80101624:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101627:	50                   	push   %eax
80101628:	e8 f3 2d 00 00       	call   80104420 <memmove>
    brelse(bp);
8010162d:	89 34 24             	mov    %esi,(%esp)
80101630:	e8 ab eb ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101635:	83 c4 10             	add    $0x10,%esp
80101638:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010163d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101644:	0f 85 77 ff ff ff    	jne    801015c1 <ilock+0x31>
      panic("ilock: no type");
8010164a:	83 ec 0c             	sub    $0xc,%esp
8010164d:	68 f0 70 10 80       	push   $0x801070f0
80101652:	e8 19 ed ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101657:	83 ec 0c             	sub    $0xc,%esp
8010165a:	68 ea 70 10 80       	push   $0x801070ea
8010165f:	e8 0c ed ff ff       	call   80100370 <panic>
80101664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010166a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101670 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	74 28                	je     801016a4 <iunlock+0x34>
8010167c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010167f:	83 ec 0c             	sub    $0xc,%esp
80101682:	56                   	push   %esi
80101683:	e8 48 2a 00 00       	call   801040d0 <holdingsleep>
80101688:	83 c4 10             	add    $0x10,%esp
8010168b:	85 c0                	test   %eax,%eax
8010168d:	74 15                	je     801016a4 <iunlock+0x34>
8010168f:	8b 43 08             	mov    0x8(%ebx),%eax
80101692:	85 c0                	test   %eax,%eax
80101694:	7e 0e                	jle    801016a4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101696:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101699:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010169c:	5b                   	pop    %ebx
8010169d:	5e                   	pop    %esi
8010169e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010169f:	e9 ec 29 00 00       	jmp    80104090 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801016a4:	83 ec 0c             	sub    $0xc,%esp
801016a7:	68 ff 70 10 80       	push   $0x801070ff
801016ac:	e8 bf ec ff ff       	call   80100370 <panic>
801016b1:	eb 0d                	jmp    801016c0 <iput>
801016b3:	90                   	nop
801016b4:	90                   	nop
801016b5:	90                   	nop
801016b6:	90                   	nop
801016b7:	90                   	nop
801016b8:	90                   	nop
801016b9:	90                   	nop
801016ba:	90                   	nop
801016bb:	90                   	nop
801016bc:	90                   	nop
801016bd:	90                   	nop
801016be:	90                   	nop
801016bf:	90                   	nop

801016c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	57                   	push   %edi
801016c4:	56                   	push   %esi
801016c5:	53                   	push   %ebx
801016c6:	83 ec 28             	sub    $0x28,%esp
801016c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801016cc:	8d 7e 0c             	lea    0xc(%esi),%edi
801016cf:	57                   	push   %edi
801016d0:	e8 5b 29 00 00       	call   80104030 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016d5:	8b 56 4c             	mov    0x4c(%esi),%edx
801016d8:	83 c4 10             	add    $0x10,%esp
801016db:	85 d2                	test   %edx,%edx
801016dd:	74 07                	je     801016e6 <iput+0x26>
801016df:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801016e4:	74 32                	je     80101718 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801016e6:	83 ec 0c             	sub    $0xc,%esp
801016e9:	57                   	push   %edi
801016ea:	e8 a1 29 00 00       	call   80104090 <releasesleep>

  acquire(&icache.lock);
801016ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016f6:	e8 05 2b 00 00       	call   80104200 <acquire>
  ip->ref--;
801016fb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801016ff:	83 c4 10             	add    $0x10,%esp
80101702:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010170c:	5b                   	pop    %ebx
8010170d:	5e                   	pop    %esi
8010170e:	5f                   	pop    %edi
8010170f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101710:	e9 0b 2c 00 00       	jmp    80104320 <release>
80101715:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101718:	83 ec 0c             	sub    $0xc,%esp
8010171b:	68 e0 09 11 80       	push   $0x801109e0
80101720:	e8 db 2a 00 00       	call   80104200 <acquire>
    int r = ip->ref;
80101725:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101728:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010172f:	e8 ec 2b 00 00       	call   80104320 <release>
    if(r == 1){
80101734:	83 c4 10             	add    $0x10,%esp
80101737:	83 fb 01             	cmp    $0x1,%ebx
8010173a:	75 aa                	jne    801016e6 <iput+0x26>
8010173c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101742:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101745:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101748:	89 cf                	mov    %ecx,%edi
8010174a:	eb 0b                	jmp    80101757 <iput+0x97>
8010174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101750:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101753:	39 fb                	cmp    %edi,%ebx
80101755:	74 19                	je     80101770 <iput+0xb0>
    if(ip->addrs[i]){
80101757:	8b 13                	mov    (%ebx),%edx
80101759:	85 d2                	test   %edx,%edx
8010175b:	74 f3                	je     80101750 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010175d:	8b 06                	mov    (%esi),%eax
8010175f:	e8 ac fb ff ff       	call   80101310 <bfree>
      ip->addrs[i] = 0;
80101764:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010176a:	eb e4                	jmp    80101750 <iput+0x90>
8010176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101770:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101776:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101779:	85 c0                	test   %eax,%eax
8010177b:	75 33                	jne    801017b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010177d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101780:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101787:	56                   	push   %esi
80101788:	e8 53 fd ff ff       	call   801014e0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010178d:	31 c0                	xor    %eax,%eax
8010178f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101793:	89 34 24             	mov    %esi,(%esp)
80101796:	e8 45 fd ff ff       	call   801014e0 <iupdate>
      ip->valid = 0;
8010179b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801017a2:	83 c4 10             	add    $0x10,%esp
801017a5:	e9 3c ff ff ff       	jmp    801016e6 <iput+0x26>
801017aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801017b0:	83 ec 08             	sub    $0x8,%esp
801017b3:	50                   	push   %eax
801017b4:	ff 36                	pushl  (%esi)
801017b6:	e8 15 e9 ff ff       	call   801000d0 <bread>
801017bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801017c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801017c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801017c7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	89 cf                	mov    %ecx,%edi
801017cf:	eb 0e                	jmp    801017df <iput+0x11f>
801017d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017d8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801017db:	39 fb                	cmp    %edi,%ebx
801017dd:	74 0f                	je     801017ee <iput+0x12e>
      if(a[j])
801017df:	8b 13                	mov    (%ebx),%edx
801017e1:	85 d2                	test   %edx,%edx
801017e3:	74 f3                	je     801017d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801017e5:	8b 06                	mov    (%esi),%eax
801017e7:	e8 24 fb ff ff       	call   80101310 <bfree>
801017ec:	eb ea                	jmp    801017d8 <iput+0x118>
    }
    brelse(bp);
801017ee:	83 ec 0c             	sub    $0xc,%esp
801017f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801017f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801017f7:	e8 e4 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801017fc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101802:	8b 06                	mov    (%esi),%eax
80101804:	e8 07 fb ff ff       	call   80101310 <bfree>
    ip->addrs[NDIRECT] = 0;
80101809:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101810:	00 00 00 
80101813:	83 c4 10             	add    $0x10,%esp
80101816:	e9 62 ff ff ff       	jmp    8010177d <iput+0xbd>
8010181b:	90                   	nop
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101820 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	83 ec 10             	sub    $0x10,%esp
80101827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010182a:	53                   	push   %ebx
8010182b:	e8 40 fe ff ff       	call   80101670 <iunlock>
  iput(ip);
80101830:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101833:	83 c4 10             	add    $0x10,%esp
}
80101836:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101839:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010183a:	e9 81 fe ff ff       	jmp    801016c0 <iput>
8010183f:	90                   	nop

80101840 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	8b 55 08             	mov    0x8(%ebp),%edx
80101846:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101849:	8b 0a                	mov    (%edx),%ecx
8010184b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010184e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101851:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101854:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101858:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010185b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010185f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101863:	8b 52 58             	mov    0x58(%edx),%edx
80101866:	89 50 10             	mov    %edx,0x10(%eax)
}
80101869:	5d                   	pop    %ebp
8010186a:	c3                   	ret    
8010186b:	90                   	nop
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101870 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	57                   	push   %edi
80101874:	56                   	push   %esi
80101875:	53                   	push   %ebx
80101876:	83 ec 1c             	sub    $0x1c,%esp
80101879:	8b 45 08             	mov    0x8(%ebp),%eax
8010187c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010187f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101882:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101887:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010188a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010188d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101890:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101893:	0f 84 a7 00 00 00    	je     80101940 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101899:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010189c:	8b 40 58             	mov    0x58(%eax),%eax
8010189f:	39 f0                	cmp    %esi,%eax
801018a1:	0f 82 c1 00 00 00    	jb     80101968 <readi+0xf8>
801018a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018aa:	89 fa                	mov    %edi,%edx
801018ac:	01 f2                	add    %esi,%edx
801018ae:	0f 82 b4 00 00 00    	jb     80101968 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801018b4:	89 c1                	mov    %eax,%ecx
801018b6:	29 f1                	sub    %esi,%ecx
801018b8:	39 d0                	cmp    %edx,%eax
801018ba:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018bd:	31 ff                	xor    %edi,%edi
801018bf:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801018c1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018c4:	74 6d                	je     80101933 <readi+0xc3>
801018c6:	8d 76 00             	lea    0x0(%esi),%esi
801018c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801018d3:	89 f2                	mov    %esi,%edx
801018d5:	c1 ea 09             	shr    $0x9,%edx
801018d8:	89 d8                	mov    %ebx,%eax
801018da:	e8 21 f9 ff ff       	call   80101200 <bmap>
801018df:	83 ec 08             	sub    $0x8,%esp
801018e2:	50                   	push   %eax
801018e3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801018e5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018ea:	e8 e1 e7 ff ff       	call   801000d0 <bread>
801018ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801018f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f4:	89 f1                	mov    %esi,%ecx
801018f6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801018fc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801018ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101902:	29 cb                	sub    %ecx,%ebx
80101904:	29 f8                	sub    %edi,%eax
80101906:	39 c3                	cmp    %eax,%ebx
80101908:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010190b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
8010190f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101910:	01 df                	add    %ebx,%edi
80101912:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101914:	50                   	push   %eax
80101915:	ff 75 e0             	pushl  -0x20(%ebp)
80101918:	e8 03 2b 00 00       	call   80104420 <memmove>
    brelse(bp);
8010191d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101920:	89 14 24             	mov    %edx,(%esp)
80101923:	e8 b8 e8 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101928:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010192b:	83 c4 10             	add    $0x10,%esp
8010192e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101931:	77 9d                	ja     801018d0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101936:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101939:	5b                   	pop    %ebx
8010193a:	5e                   	pop    %esi
8010193b:	5f                   	pop    %edi
8010193c:	5d                   	pop    %ebp
8010193d:	c3                   	ret    
8010193e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101940:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101944:	66 83 f8 09          	cmp    $0x9,%ax
80101948:	77 1e                	ja     80101968 <readi+0xf8>
8010194a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101951:	85 c0                	test   %eax,%eax
80101953:	74 13                	je     80101968 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101955:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101958:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010195b:	5b                   	pop    %ebx
8010195c:	5e                   	pop    %esi
8010195d:	5f                   	pop    %edi
8010195e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
8010195f:	ff e0                	jmp    *%eax
80101961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010196d:	eb c7                	jmp    80101936 <readi+0xc6>
8010196f:	90                   	nop

80101970 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101987:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101993:	0f 84 b7 00 00 00    	je     80101a50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	39 70 58             	cmp    %esi,0x58(%eax)
8010199f:	0f 82 eb 00 00 00    	jb     80101a90 <writei+0x120>
801019a5:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019a8:	89 f8                	mov    %edi,%eax
801019aa:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
801019ac:	3d 00 18 01 00       	cmp    $0x11800,%eax
801019b1:	0f 87 d9 00 00 00    	ja     80101a90 <writei+0x120>
801019b7:	39 c6                	cmp    %eax,%esi
801019b9:	0f 87 d1 00 00 00    	ja     80101a90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019bf:	85 ff                	test   %edi,%edi
801019c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801019c8:	74 78                	je     80101a42 <writei+0xd2>
801019ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801019d3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019da:	c1 ea 09             	shr    $0x9,%edx
801019dd:	89 f8                	mov    %edi,%eax
801019df:	e8 1c f8 ff ff       	call   80101200 <bmap>
801019e4:	83 ec 08             	sub    $0x8,%esp
801019e7:	50                   	push   %eax
801019e8:	ff 37                	pushl  (%edi)
801019ea:	e8 e1 e6 ff ff       	call   801000d0 <bread>
801019ef:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
801019f7:	89 f1                	mov    %esi,%ecx
801019f9:	83 c4 0c             	add    $0xc,%esp
801019fc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a02:	29 cb                	sub    %ecx,%ebx
80101a04:	39 c3                	cmp    %eax,%ebx
80101a06:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101a09:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101a0d:	53                   	push   %ebx
80101a0e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a11:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101a13:	50                   	push   %eax
80101a14:	e8 07 2a 00 00       	call   80104420 <memmove>
    log_write(bp);
80101a19:	89 3c 24             	mov    %edi,(%esp)
80101a1c:	e8 2f 12 00 00       	call   80102c50 <log_write>
    brelse(bp);
80101a21:	89 3c 24             	mov    %edi,(%esp)
80101a24:	e8 b7 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101a2c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a35:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101a38:	77 96                	ja     801019d0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101a3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a3d:	3b 70 58             	cmp    0x58(%eax),%esi
80101a40:	77 36                	ja     80101a78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5f                   	pop    %edi
80101a4b:	5d                   	pop    %ebp
80101a4c:	c3                   	ret    
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101a50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 36                	ja     80101a90 <writei+0x120>
80101a5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 2b                	je     80101a90 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101a65:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6b:	5b                   	pop    %ebx
80101a6c:	5e                   	pop    %esi
80101a6d:	5f                   	pop    %edi
80101a6e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101a6f:	ff e0                	jmp    *%eax
80101a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101a78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101a7b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101a7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101a81:	50                   	push   %eax
80101a82:	e8 59 fa ff ff       	call   801014e0 <iupdate>
80101a87:	83 c4 10             	add    $0x10,%esp
80101a8a:	eb b6                	jmp    80101a42 <writei+0xd2>
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a95:	eb ae                	jmp    80101a45 <writei+0xd5>
80101a97:	89 f6                	mov    %esi,%esi
80101a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101aa0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101aa6:	6a 0e                	push   $0xe
80101aa8:	ff 75 0c             	pushl  0xc(%ebp)
80101aab:	ff 75 08             	pushl  0x8(%ebp)
80101aae:	e8 ed 29 00 00       	call   801044a0 <strncmp>
}
80101ab3:	c9                   	leave  
80101ab4:	c3                   	ret    
80101ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ac0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	57                   	push   %edi
80101ac4:	56                   	push   %esi
80101ac5:	53                   	push   %ebx
80101ac6:	83 ec 1c             	sub    $0x1c,%esp
80101ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101acc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ad1:	0f 85 80 00 00 00    	jne    80101b57 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ad7:	8b 53 58             	mov    0x58(%ebx),%edx
80101ada:	31 ff                	xor    %edi,%edi
80101adc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101adf:	85 d2                	test   %edx,%edx
80101ae1:	75 0d                	jne    80101af0 <dirlookup+0x30>
80101ae3:	eb 5b                	jmp    80101b40 <dirlookup+0x80>
80101ae5:	8d 76 00             	lea    0x0(%esi),%esi
80101ae8:	83 c7 10             	add    $0x10,%edi
80101aeb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101aee:	76 50                	jbe    80101b40 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101af0:	6a 10                	push   $0x10
80101af2:	57                   	push   %edi
80101af3:	56                   	push   %esi
80101af4:	53                   	push   %ebx
80101af5:	e8 76 fd ff ff       	call   80101870 <readi>
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	83 f8 10             	cmp    $0x10,%eax
80101b00:	75 48                	jne    80101b4a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101b02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b07:	74 df                	je     80101ae8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101b09:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b0c:	83 ec 04             	sub    $0x4,%esp
80101b0f:	6a 0e                	push   $0xe
80101b11:	50                   	push   %eax
80101b12:	ff 75 0c             	pushl  0xc(%ebp)
80101b15:	e8 86 29 00 00       	call   801044a0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	85 c0                	test   %eax,%eax
80101b1f:	75 c7                	jne    80101ae8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101b21:	8b 45 10             	mov    0x10(%ebp),%eax
80101b24:	85 c0                	test   %eax,%eax
80101b26:	74 05                	je     80101b2d <dirlookup+0x6d>
        *poff = off;
80101b28:	8b 45 10             	mov    0x10(%ebp),%eax
80101b2b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101b2d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101b31:	8b 03                	mov    (%ebx),%eax
80101b33:	e8 f8 f5 ff ff       	call   80101130 <iget>
    }
  }

  return 0;
}
80101b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
80101b3f:	c3                   	ret    
80101b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101b43:	31 c0                	xor    %eax,%eax
}
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101b4a:	83 ec 0c             	sub    $0xc,%esp
80101b4d:	68 19 71 10 80       	push   $0x80107119
80101b52:	e8 19 e8 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101b57:	83 ec 0c             	sub    $0xc,%esp
80101b5a:	68 07 71 10 80       	push   $0x80107107
80101b5f:	e8 0c e8 ff ff       	call   80100370 <panic>
80101b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	57                   	push   %edi
80101b74:	56                   	push   %esi
80101b75:	53                   	push   %ebx
80101b76:	89 cf                	mov    %ecx,%edi
80101b78:	89 c3                	mov    %eax,%ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101b7d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101b80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101b83:	0f 84 53 01 00 00    	je     80101cdc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101b89:	e8 12 1b 00 00       	call   801036a0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101b8e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101b91:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101b94:	68 e0 09 11 80       	push   $0x801109e0
80101b99:	e8 62 26 00 00       	call   80104200 <acquire>
  ip->ref++;
80101b9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ba2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ba9:	e8 72 27 00 00       	call   80104320 <release>
80101bae:	83 c4 10             	add    $0x10,%esp
80101bb1:	eb 08                	jmp    80101bbb <namex+0x4b>
80101bb3:	90                   	nop
80101bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101bb8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101bbb:	0f b6 03             	movzbl (%ebx),%eax
80101bbe:	3c 2f                	cmp    $0x2f,%al
80101bc0:	74 f6                	je     80101bb8 <namex+0x48>
    path++;
  if(*path == 0)
80101bc2:	84 c0                	test   %al,%al
80101bc4:	0f 84 e3 00 00 00    	je     80101cad <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101bca:	0f b6 03             	movzbl (%ebx),%eax
80101bcd:	89 da                	mov    %ebx,%edx
80101bcf:	84 c0                	test   %al,%al
80101bd1:	0f 84 ac 00 00 00    	je     80101c83 <namex+0x113>
80101bd7:	3c 2f                	cmp    $0x2f,%al
80101bd9:	75 09                	jne    80101be4 <namex+0x74>
80101bdb:	e9 a3 00 00 00       	jmp    80101c83 <namex+0x113>
80101be0:	84 c0                	test   %al,%al
80101be2:	74 0a                	je     80101bee <namex+0x7e>
    path++;
80101be4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101be7:	0f b6 02             	movzbl (%edx),%eax
80101bea:	3c 2f                	cmp    $0x2f,%al
80101bec:	75 f2                	jne    80101be0 <namex+0x70>
80101bee:	89 d1                	mov    %edx,%ecx
80101bf0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101bf2:	83 f9 0d             	cmp    $0xd,%ecx
80101bf5:	0f 8e 8d 00 00 00    	jle    80101c88 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101bfb:	83 ec 04             	sub    $0x4,%esp
80101bfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101c01:	6a 0e                	push   $0xe
80101c03:	53                   	push   %ebx
80101c04:	57                   	push   %edi
80101c05:	e8 16 28 00 00       	call   80104420 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101c0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101c0d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101c10:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101c12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101c15:	75 11                	jne    80101c28 <namex+0xb8>
80101c17:	89 f6                	mov    %esi,%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101c20:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101c23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101c26:	74 f8                	je     80101c20 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101c28:	83 ec 0c             	sub    $0xc,%esp
80101c2b:	56                   	push   %esi
80101c2c:	e8 5f f9 ff ff       	call   80101590 <ilock>
    if(ip->type != T_DIR){
80101c31:	83 c4 10             	add    $0x10,%esp
80101c34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101c39:	0f 85 7f 00 00 00    	jne    80101cbe <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101c3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101c42:	85 d2                	test   %edx,%edx
80101c44:	74 09                	je     80101c4f <namex+0xdf>
80101c46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101c49:	0f 84 a3 00 00 00    	je     80101cf2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101c4f:	83 ec 04             	sub    $0x4,%esp
80101c52:	6a 00                	push   $0x0
80101c54:	57                   	push   %edi
80101c55:	56                   	push   %esi
80101c56:	e8 65 fe ff ff       	call   80101ac0 <dirlookup>
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	85 c0                	test   %eax,%eax
80101c60:	74 5c                	je     80101cbe <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101c62:	83 ec 0c             	sub    $0xc,%esp
80101c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101c68:	56                   	push   %esi
80101c69:	e8 02 fa ff ff       	call   80101670 <iunlock>
  iput(ip);
80101c6e:	89 34 24             	mov    %esi,(%esp)
80101c71:	e8 4a fa ff ff       	call   801016c0 <iput>
80101c76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c79:	83 c4 10             	add    $0x10,%esp
80101c7c:	89 c6                	mov    %eax,%esi
80101c7e:	e9 38 ff ff ff       	jmp    80101bbb <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c83:	31 c9                	xor    %ecx,%ecx
80101c85:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101c88:	83 ec 04             	sub    $0x4,%esp
80101c8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101c8e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101c91:	51                   	push   %ecx
80101c92:	53                   	push   %ebx
80101c93:	57                   	push   %edi
80101c94:	e8 87 27 00 00       	call   80104420 <memmove>
    name[len] = 0;
80101c99:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101c9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c9f:	83 c4 10             	add    $0x10,%esp
80101ca2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101ca6:	89 d3                	mov    %edx,%ebx
80101ca8:	e9 65 ff ff ff       	jmp    80101c12 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101cb0:	85 c0                	test   %eax,%eax
80101cb2:	75 54                	jne    80101d08 <namex+0x198>
80101cb4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cb9:	5b                   	pop    %ebx
80101cba:	5e                   	pop    %esi
80101cbb:	5f                   	pop    %edi
80101cbc:	5d                   	pop    %ebp
80101cbd:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
80101cc1:	56                   	push   %esi
80101cc2:	e8 a9 f9 ff ff       	call   80101670 <iunlock>
  iput(ip);
80101cc7:	89 34 24             	mov    %esi,(%esp)
80101cca:	e8 f1 f9 ff ff       	call   801016c0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101ccf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101cd5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101cd7:	5b                   	pop    %ebx
80101cd8:	5e                   	pop    %esi
80101cd9:	5f                   	pop    %edi
80101cda:	5d                   	pop    %ebp
80101cdb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101cdc:	ba 01 00 00 00       	mov    $0x1,%edx
80101ce1:	b8 01 00 00 00       	mov    $0x1,%eax
80101ce6:	e8 45 f4 ff ff       	call   80101130 <iget>
80101ceb:	89 c6                	mov    %eax,%esi
80101ced:	e9 c9 fe ff ff       	jmp    80101bbb <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101cf2:	83 ec 0c             	sub    $0xc,%esp
80101cf5:	56                   	push   %esi
80101cf6:	e8 75 f9 ff ff       	call   80101670 <iunlock>
      return ip;
80101cfb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101d01:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d03:	5b                   	pop    %ebx
80101d04:	5e                   	pop    %esi
80101d05:	5f                   	pop    %edi
80101d06:	5d                   	pop    %ebp
80101d07:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 af f9 ff ff       	call   801016c0 <iput>
    return 0;
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	31 c0                	xor    %eax,%eax
80101d16:	eb 9e                	jmp    80101cb6 <namex+0x146>
80101d18:	90                   	nop
80101d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d20 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	83 ec 20             	sub    $0x20,%esp
80101d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101d2c:	6a 00                	push   $0x0
80101d2e:	ff 75 0c             	pushl  0xc(%ebp)
80101d31:	53                   	push   %ebx
80101d32:	e8 89 fd ff ff       	call   80101ac0 <dirlookup>
80101d37:	83 c4 10             	add    $0x10,%esp
80101d3a:	85 c0                	test   %eax,%eax
80101d3c:	75 67                	jne    80101da5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101d41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d44:	85 ff                	test   %edi,%edi
80101d46:	74 29                	je     80101d71 <dirlink+0x51>
80101d48:	31 ff                	xor    %edi,%edi
80101d4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d4d:	eb 09                	jmp    80101d58 <dirlink+0x38>
80101d4f:	90                   	nop
80101d50:	83 c7 10             	add    $0x10,%edi
80101d53:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101d56:	76 19                	jbe    80101d71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d58:	6a 10                	push   $0x10
80101d5a:	57                   	push   %edi
80101d5b:	56                   	push   %esi
80101d5c:	53                   	push   %ebx
80101d5d:	e8 0e fb ff ff       	call   80101870 <readi>
80101d62:	83 c4 10             	add    $0x10,%esp
80101d65:	83 f8 10             	cmp    $0x10,%eax
80101d68:	75 4e                	jne    80101db8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101d6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d6f:	75 df                	jne    80101d50 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101d71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d74:	83 ec 04             	sub    $0x4,%esp
80101d77:	6a 0e                	push   $0xe
80101d79:	ff 75 0c             	pushl  0xc(%ebp)
80101d7c:	50                   	push   %eax
80101d7d:	e8 8e 27 00 00       	call   80104510 <strncpy>
  de.inum = inum;
80101d82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d85:	6a 10                	push   $0x10
80101d87:	57                   	push   %edi
80101d88:	56                   	push   %esi
80101d89:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101d8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d8e:	e8 dd fb ff ff       	call   80101970 <writei>
80101d93:	83 c4 20             	add    $0x20,%esp
80101d96:	83 f8 10             	cmp    $0x10,%eax
80101d99:	75 2a                	jne    80101dc5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101d9b:	31 c0                	xor    %eax,%eax
}
80101d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101da0:	5b                   	pop    %ebx
80101da1:	5e                   	pop    %esi
80101da2:	5f                   	pop    %edi
80101da3:	5d                   	pop    %ebp
80101da4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101da5:	83 ec 0c             	sub    $0xc,%esp
80101da8:	50                   	push   %eax
80101da9:	e8 12 f9 ff ff       	call   801016c0 <iput>
    return -1;
80101dae:	83 c4 10             	add    $0x10,%esp
80101db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101db6:	eb e5                	jmp    80101d9d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	68 28 71 10 80       	push   $0x80107128
80101dc0:	e8 ab e5 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101dc5:	83 ec 0c             	sub    $0xc,%esp
80101dc8:	68 66 77 10 80       	push   $0x80107766
80101dcd:	e8 9e e5 ff ff       	call   80100370 <panic>
80101dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101de0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101de0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101de1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101de3:	89 e5                	mov    %esp,%ebp
80101de5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101de8:	8b 45 08             	mov    0x8(%ebp),%eax
80101deb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101dee:	e8 7d fd ff ff       	call   80101b70 <namex>
}
80101df3:	c9                   	leave  
80101df4:	c3                   	ret    
80101df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101e00:	55                   	push   %ebp
  return namex(path, 1, name);
80101e01:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101e06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101e0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101e0e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101e0f:	e9 5c fd ff ff       	jmp    80101b70 <namex>
80101e14:	66 90                	xchg   %ax,%ax
80101e16:	66 90                	xchg   %ax,%ax
80101e18:	66 90                	xchg   %ax,%ax
80101e1a:	66 90                	xchg   %ax,%ax
80101e1c:	66 90                	xchg   %ax,%ax
80101e1e:	66 90                	xchg   %ax,%ax

80101e20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e20:	55                   	push   %ebp
  if(b == 0)
80101e21:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e23:	89 e5                	mov    %esp,%ebp
80101e25:	56                   	push   %esi
80101e26:	53                   	push   %ebx
  if(b == 0)
80101e27:	0f 84 ad 00 00 00    	je     80101eda <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101e2d:	8b 58 08             	mov    0x8(%eax),%ebx
80101e30:	89 c1                	mov    %eax,%ecx
80101e32:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101e38:	0f 87 8f 00 00 00    	ja     80101ecd <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e3e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e43:	90                   	nop
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e48:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e49:	83 e0 c0             	and    $0xffffffc0,%eax
80101e4c:	3c 40                	cmp    $0x40,%al
80101e4e:	75 f8                	jne    80101e48 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e50:	31 f6                	xor    %esi,%esi
80101e52:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101e57:	89 f0                	mov    %esi,%eax
80101e59:	ee                   	out    %al,(%dx)
80101e5a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101e5f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e64:	ee                   	out    %al,(%dx)
80101e65:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101e6a:	89 d8                	mov    %ebx,%eax
80101e6c:	ee                   	out    %al,(%dx)
80101e6d:	89 d8                	mov    %ebx,%eax
80101e6f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101e74:	c1 f8 08             	sar    $0x8,%eax
80101e77:	ee                   	out    %al,(%dx)
80101e78:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101e7d:	89 f0                	mov    %esi,%eax
80101e7f:	ee                   	out    %al,(%dx)
80101e80:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101e84:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e89:	83 e0 01             	and    $0x1,%eax
80101e8c:	c1 e0 04             	shl    $0x4,%eax
80101e8f:	83 c8 e0             	or     $0xffffffe0,%eax
80101e92:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101e93:	f6 01 04             	testb  $0x4,(%ecx)
80101e96:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e9b:	75 13                	jne    80101eb0 <idestart+0x90>
80101e9d:	b8 20 00 00 00       	mov    $0x20,%eax
80101ea2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101ea3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ea6:	5b                   	pop    %ebx
80101ea7:	5e                   	pop    %esi
80101ea8:	5d                   	pop    %ebp
80101ea9:	c3                   	ret    
80101eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101eb0:	b8 30 00 00 00       	mov    $0x30,%eax
80101eb5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101eb6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101ebb:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101ebe:	b9 80 00 00 00       	mov    $0x80,%ecx
80101ec3:	fc                   	cld    
80101ec4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101ec6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ec9:	5b                   	pop    %ebx
80101eca:	5e                   	pop    %esi
80101ecb:	5d                   	pop    %ebp
80101ecc:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101ecd:	83 ec 0c             	sub    $0xc,%esp
80101ed0:	68 94 71 10 80       	push   $0x80107194
80101ed5:	e8 96 e4 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101eda:	83 ec 0c             	sub    $0xc,%esp
80101edd:	68 8b 71 10 80       	push   $0x8010718b
80101ee2:	e8 89 e4 ff ff       	call   80100370 <panic>
80101ee7:	89 f6                	mov    %esi,%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101ef6:	68 a6 71 10 80       	push   $0x801071a6
80101efb:	68 80 a5 10 80       	push   $0x8010a580
80101f00:	e8 fb 21 00 00       	call   80104100 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101f05:	58                   	pop    %eax
80101f06:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101f0b:	5a                   	pop    %edx
80101f0c:	83 e8 01             	sub    $0x1,%eax
80101f0f:	50                   	push   %eax
80101f10:	6a 0e                	push   $0xe
80101f12:	e8 a9 02 00 00       	call   801021c0 <ioapicenable>
80101f17:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f1a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f1f:	90                   	nop
80101f20:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f21:	83 e0 c0             	and    $0xffffffc0,%eax
80101f24:	3c 40                	cmp    $0x40,%al
80101f26:	75 f8                	jne    80101f20 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f28:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f2d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101f32:	ee                   	out    %al,(%dx)
80101f33:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f38:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f3d:	eb 06                	jmp    80101f45 <ideinit+0x55>
80101f3f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80101f40:	83 e9 01             	sub    $0x1,%ecx
80101f43:	74 0f                	je     80101f54 <ideinit+0x64>
80101f45:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101f46:	84 c0                	test   %al,%al
80101f48:	74 f6                	je     80101f40 <ideinit+0x50>
      havedisk1 = 1;
80101f4a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101f51:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f59:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101f5e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80101f5f:	c9                   	leave  
80101f60:	c3                   	ret    
80101f61:	eb 0d                	jmp    80101f70 <ideintr>
80101f63:	90                   	nop
80101f64:	90                   	nop
80101f65:	90                   	nop
80101f66:	90                   	nop
80101f67:	90                   	nop
80101f68:	90                   	nop
80101f69:	90                   	nop
80101f6a:	90                   	nop
80101f6b:	90                   	nop
80101f6c:	90                   	nop
80101f6d:	90                   	nop
80101f6e:	90                   	nop
80101f6f:	90                   	nop

80101f70 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	57                   	push   %edi
80101f74:	56                   	push   %esi
80101f75:	53                   	push   %ebx
80101f76:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101f79:	68 80 a5 10 80       	push   $0x8010a580
80101f7e:	e8 7d 22 00 00       	call   80104200 <acquire>

  if((b = idequeue) == 0){
80101f83:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101f89:	83 c4 10             	add    $0x10,%esp
80101f8c:	85 db                	test   %ebx,%ebx
80101f8e:	74 34                	je     80101fc4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101f90:	8b 43 58             	mov    0x58(%ebx),%eax
80101f93:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101f98:	8b 33                	mov    (%ebx),%esi
80101f9a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80101fa0:	74 3e                	je     80101fe0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101fa2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80101fa5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101fa8:	83 ce 02             	or     $0x2,%esi
80101fab:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80101fad:	53                   	push   %ebx
80101fae:	e8 8d 1e 00 00       	call   80103e40 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101fb3:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	85 c0                	test   %eax,%eax
80101fbd:	74 05                	je     80101fc4 <ideintr+0x54>
    idestart(idequeue);
80101fbf:	e8 5c fe ff ff       	call   80101e20 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80101fc4:	83 ec 0c             	sub    $0xc,%esp
80101fc7:	68 80 a5 10 80       	push   $0x8010a580
80101fcc:	e8 4f 23 00 00       	call   80104320 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80101fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd4:	5b                   	pop    %ebx
80101fd5:	5e                   	pop    %esi
80101fd6:	5f                   	pop    %edi
80101fd7:	5d                   	pop    %ebp
80101fd8:	c3                   	ret    
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fe0:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fe5:	8d 76 00             	lea    0x0(%esi),%esi
80101fe8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fe9:	89 c1                	mov    %eax,%ecx
80101feb:	83 e1 c0             	and    $0xffffffc0,%ecx
80101fee:	80 f9 40             	cmp    $0x40,%cl
80101ff1:	75 f5                	jne    80101fe8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101ff3:	a8 21                	test   $0x21,%al
80101ff5:	75 ab                	jne    80101fa2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80101ff7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80101ffa:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fff:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102004:	fc                   	cld    
80102005:	f3 6d                	rep insl (%dx),%es:(%edi)
80102007:	8b 33                	mov    (%ebx),%esi
80102009:	eb 97                	jmp    80101fa2 <ideintr+0x32>
8010200b:	90                   	nop
8010200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102010 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	53                   	push   %ebx
80102014:	83 ec 10             	sub    $0x10,%esp
80102017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010201a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010201d:	50                   	push   %eax
8010201e:	e8 ad 20 00 00       	call   801040d0 <holdingsleep>
80102023:	83 c4 10             	add    $0x10,%esp
80102026:	85 c0                	test   %eax,%eax
80102028:	0f 84 ad 00 00 00    	je     801020db <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010202e:	8b 03                	mov    (%ebx),%eax
80102030:	83 e0 06             	and    $0x6,%eax
80102033:	83 f8 02             	cmp    $0x2,%eax
80102036:	0f 84 b9 00 00 00    	je     801020f5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010203c:	8b 53 04             	mov    0x4(%ebx),%edx
8010203f:	85 d2                	test   %edx,%edx
80102041:	74 0d                	je     80102050 <iderw+0x40>
80102043:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102048:	85 c0                	test   %eax,%eax
8010204a:	0f 84 98 00 00 00    	je     801020e8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102050:	83 ec 0c             	sub    $0xc,%esp
80102053:	68 80 a5 10 80       	push   $0x8010a580
80102058:	e8 a3 21 00 00       	call   80104200 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010205d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102063:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102066:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010206d:	85 d2                	test   %edx,%edx
8010206f:	75 09                	jne    8010207a <iderw+0x6a>
80102071:	eb 58                	jmp    801020cb <iderw+0xbb>
80102073:	90                   	nop
80102074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102078:	89 c2                	mov    %eax,%edx
8010207a:	8b 42 58             	mov    0x58(%edx),%eax
8010207d:	85 c0                	test   %eax,%eax
8010207f:	75 f7                	jne    80102078 <iderw+0x68>
80102081:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102084:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102086:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010208c:	74 44                	je     801020d2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010208e:	8b 03                	mov    (%ebx),%eax
80102090:	83 e0 06             	and    $0x6,%eax
80102093:	83 f8 02             	cmp    $0x2,%eax
80102096:	74 23                	je     801020bb <iderw+0xab>
80102098:	90                   	nop
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801020a0:	83 ec 08             	sub    $0x8,%esp
801020a3:	68 80 a5 10 80       	push   $0x8010a580
801020a8:	53                   	push   %ebx
801020a9:	e8 e2 1b 00 00       	call   80103c90 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801020ae:	8b 03                	mov    (%ebx),%eax
801020b0:	83 c4 10             	add    $0x10,%esp
801020b3:	83 e0 06             	and    $0x6,%eax
801020b6:	83 f8 02             	cmp    $0x2,%eax
801020b9:	75 e5                	jne    801020a0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801020bb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801020c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020c5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801020c6:	e9 55 22 00 00       	jmp    80104320 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020cb:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801020d0:	eb b2                	jmp    80102084 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801020d2:	89 d8                	mov    %ebx,%eax
801020d4:	e8 47 fd ff ff       	call   80101e20 <idestart>
801020d9:	eb b3                	jmp    8010208e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801020db:	83 ec 0c             	sub    $0xc,%esp
801020de:	68 aa 71 10 80       	push   $0x801071aa
801020e3:	e8 88 e2 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801020e8:	83 ec 0c             	sub    $0xc,%esp
801020eb:	68 d5 71 10 80       	push   $0x801071d5
801020f0:	e8 7b e2 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801020f5:	83 ec 0c             	sub    $0xc,%esp
801020f8:	68 c0 71 10 80       	push   $0x801071c0
801020fd:	e8 6e e2 ff ff       	call   80100370 <panic>
80102102:	66 90                	xchg   %ax,%ax
80102104:	66 90                	xchg   %ax,%ax
80102106:	66 90                	xchg   %ax,%ax
80102108:	66 90                	xchg   %ax,%ax
8010210a:	66 90                	xchg   %ax,%ax
8010210c:	66 90                	xchg   %ax,%ax
8010210e:	66 90                	xchg   %ax,%ax

80102110 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102110:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102111:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102118:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010211b:	89 e5                	mov    %esp,%ebp
8010211d:	56                   	push   %esi
8010211e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010211f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102126:	00 00 00 
  return ioapic->data;
80102129:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010212f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102132:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102138:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010213e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102145:	89 f0                	mov    %esi,%eax
80102147:	c1 e8 10             	shr    $0x10,%eax
8010214a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010214d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102150:	c1 e8 18             	shr    $0x18,%eax
80102153:	39 d0                	cmp    %edx,%eax
80102155:	74 16                	je     8010216d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102157:	83 ec 0c             	sub    $0xc,%esp
8010215a:	68 f4 71 10 80       	push   $0x801071f4
8010215f:	e8 fc e4 ff ff       	call   80100660 <cprintf>
80102164:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010216a:	83 c4 10             	add    $0x10,%esp
8010216d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102170:	ba 10 00 00 00       	mov    $0x10,%edx
80102175:	b8 20 00 00 00       	mov    $0x20,%eax
8010217a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102180:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102182:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102188:	89 c3                	mov    %eax,%ebx
8010218a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102190:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102193:	89 59 10             	mov    %ebx,0x10(%ecx)
80102196:	8d 5a 01             	lea    0x1(%edx),%ebx
80102199:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010219c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010219e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801021a0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801021a6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801021ad:	75 d1                	jne    80102180 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801021af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021b2:	5b                   	pop    %ebx
801021b3:	5e                   	pop    %esi
801021b4:	5d                   	pop    %ebp
801021b5:	c3                   	ret    
801021b6:	8d 76 00             	lea    0x0(%esi),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801021c0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801021c1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801021c7:	89 e5                	mov    %esp,%ebp
801021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801021cc:	8d 50 20             	lea    0x20(%eax),%edx
801021cf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801021d3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021d5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801021db:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801021de:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801021e1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801021e4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021e6:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801021eb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801021ee:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801021f1:	5d                   	pop    %ebp
801021f2:	c3                   	ret    
801021f3:	66 90                	xchg   %ax,%ax
801021f5:	66 90                	xchg   %ax,%ax
801021f7:	66 90                	xchg   %ax,%ax
801021f9:	66 90                	xchg   %ax,%ax
801021fb:	66 90                	xchg   %ax,%ax
801021fd:	66 90                	xchg   %ax,%ax
801021ff:	90                   	nop

80102200 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	53                   	push   %ebx
80102204:	83 ec 04             	sub    $0x4,%esp
80102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010220a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102210:	75 70                	jne    80102282 <kfree+0x82>
80102212:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
80102218:	72 68                	jb     80102282 <kfree+0x82>
8010221a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102220:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102225:	77 5b                	ja     80102282 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102227:	83 ec 04             	sub    $0x4,%esp
8010222a:	68 00 10 00 00       	push   $0x1000
8010222f:	6a 01                	push   $0x1
80102231:	53                   	push   %ebx
80102232:	e8 39 21 00 00       	call   80104370 <memset>

  if(kmem.use_lock)
80102237:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010223d:	83 c4 10             	add    $0x10,%esp
80102240:	85 d2                	test   %edx,%edx
80102242:	75 2c                	jne    80102270 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102244:	a1 78 26 11 80       	mov    0x80112678,%eax
80102249:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010224b:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102250:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102256:	85 c0                	test   %eax,%eax
80102258:	75 06                	jne    80102260 <kfree+0x60>
    release(&kmem.lock);
}
8010225a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010225d:	c9                   	leave  
8010225e:	c3                   	ret    
8010225f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102260:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102267:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010226a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010226b:	e9 b0 20 00 00       	jmp    80104320 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102270:	83 ec 0c             	sub    $0xc,%esp
80102273:	68 40 26 11 80       	push   $0x80112640
80102278:	e8 83 1f 00 00       	call   80104200 <acquire>
8010227d:	83 c4 10             	add    $0x10,%esp
80102280:	eb c2                	jmp    80102244 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102282:	83 ec 0c             	sub    $0xc,%esp
80102285:	68 26 72 10 80       	push   $0x80107226
8010228a:	e8 e1 e0 ff ff       	call   80100370 <panic>
8010228f:	90                   	nop

80102290 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	56                   	push   %esi
80102294:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102295:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102298:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010229b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801022a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022ad:	39 de                	cmp    %ebx,%esi
801022af:	72 23                	jb     801022d4 <freerange+0x44>
801022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801022b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801022be:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801022c7:	50                   	push   %eax
801022c8:	e8 33 ff ff ff       	call   80102200 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022cd:	83 c4 10             	add    $0x10,%esp
801022d0:	39 f3                	cmp    %esi,%ebx
801022d2:	76 e4                	jbe    801022b8 <freerange+0x28>
    kfree(p);
}
801022d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d7:	5b                   	pop    %ebx
801022d8:	5e                   	pop    %esi
801022d9:	5d                   	pop    %ebp
801022da:	c3                   	ret    
801022db:	90                   	nop
801022dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022e0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	56                   	push   %esi
801022e4:	53                   	push   %ebx
801022e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801022e8:	83 ec 08             	sub    $0x8,%esp
801022eb:	68 2c 72 10 80       	push   $0x8010722c
801022f0:	68 40 26 11 80       	push   $0x80112640
801022f5:	e8 06 1e 00 00       	call   80104100 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022fd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102300:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102307:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010230a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102310:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102316:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010231c:	39 de                	cmp    %ebx,%esi
8010231e:	72 1c                	jb     8010233c <kinit1+0x5c>
    kfree(p);
80102320:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102326:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102329:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010232f:	50                   	push   %eax
80102330:	e8 cb fe ff ff       	call   80102200 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102335:	83 c4 10             	add    $0x10,%esp
80102338:	39 de                	cmp    %ebx,%esi
8010233a:	73 e4                	jae    80102320 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010233c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010233f:	5b                   	pop    %ebx
80102340:	5e                   	pop    %esi
80102341:	5d                   	pop    %ebp
80102342:	c3                   	ret    
80102343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102350 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	56                   	push   %esi
80102354:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102358:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010235b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102361:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102367:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010236d:	39 de                	cmp    %ebx,%esi
8010236f:	72 23                	jb     80102394 <kinit2+0x44>
80102371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102378:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010237e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102381:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102387:	50                   	push   %eax
80102388:	e8 73 fe ff ff       	call   80102200 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	39 de                	cmp    %ebx,%esi
80102392:	73 e4                	jae    80102378 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102394:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010239b:	00 00 00 
}
8010239e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a1:	5b                   	pop    %ebx
801023a2:	5e                   	pop    %esi
801023a3:	5d                   	pop    %ebp
801023a4:	c3                   	ret    
801023a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	53                   	push   %ebx
801023b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801023b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801023bc:	85 c0                	test   %eax,%eax
801023be:	75 30                	jne    801023f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801023c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801023c6:	85 db                	test   %ebx,%ebx
801023c8:	74 1c                	je     801023e6 <kalloc+0x36>
    kmem.freelist = r->next;
801023ca:	8b 13                	mov    (%ebx),%edx
801023cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801023d2:	85 c0                	test   %eax,%eax
801023d4:	74 10                	je     801023e6 <kalloc+0x36>
    release(&kmem.lock);
801023d6:	83 ec 0c             	sub    $0xc,%esp
801023d9:	68 40 26 11 80       	push   $0x80112640
801023de:	e8 3d 1f 00 00       	call   80104320 <release>
801023e3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801023e6:	89 d8                	mov    %ebx,%eax
801023e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023eb:	c9                   	leave  
801023ec:	c3                   	ret    
801023ed:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023f0:	83 ec 0c             	sub    $0xc,%esp
801023f3:	68 40 26 11 80       	push   $0x80112640
801023f8:	e8 03 1e 00 00       	call   80104200 <acquire>
  r = kmem.freelist;
801023fd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102403:	83 c4 10             	add    $0x10,%esp
80102406:	a1 74 26 11 80       	mov    0x80112674,%eax
8010240b:	85 db                	test   %ebx,%ebx
8010240d:	75 bb                	jne    801023ca <kalloc+0x1a>
8010240f:	eb c1                	jmp    801023d2 <kalloc+0x22>
80102411:	66 90                	xchg   %ax,%ax
80102413:	66 90                	xchg   %ax,%ax
80102415:	66 90                	xchg   %ax,%ax
80102417:	66 90                	xchg   %ax,%ax
80102419:	66 90                	xchg   %ax,%ax
8010241b:	66 90                	xchg   %ax,%ax
8010241d:	66 90                	xchg   %ax,%ax
8010241f:	90                   	nop

80102420 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102420:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102421:	ba 64 00 00 00       	mov    $0x64,%edx
80102426:	89 e5                	mov    %esp,%ebp
80102428:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102429:	a8 01                	test   $0x1,%al
8010242b:	0f 84 af 00 00 00    	je     801024e0 <kbdgetc+0xc0>
80102431:	ba 60 00 00 00       	mov    $0x60,%edx
80102436:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102437:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010243a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102440:	74 7e                	je     801024c0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102442:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102444:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010244a:	79 24                	jns    80102470 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010244c:	f6 c1 40             	test   $0x40,%cl
8010244f:	75 05                	jne    80102456 <kbdgetc+0x36>
80102451:	89 c2                	mov    %eax,%edx
80102453:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102456:	0f b6 82 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%eax
8010245d:	83 c8 40             	or     $0x40,%eax
80102460:	0f b6 c0             	movzbl %al,%eax
80102463:	f7 d0                	not    %eax
80102465:	21 c8                	and    %ecx,%eax
80102467:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010246c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010246e:	5d                   	pop    %ebp
8010246f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102470:	f6 c1 40             	test   $0x40,%cl
80102473:	74 09                	je     8010247e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102475:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102478:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010247b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010247e:	0f b6 82 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%eax
80102485:	09 c1                	or     %eax,%ecx
80102487:	0f b6 82 60 72 10 80 	movzbl -0x7fef8da0(%edx),%eax
8010248e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102490:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102492:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102498:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010249b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010249e:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
801024a5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801024a9:	74 c3                	je     8010246e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801024ab:	8d 50 9f             	lea    -0x61(%eax),%edx
801024ae:	83 fa 19             	cmp    $0x19,%edx
801024b1:	77 1d                	ja     801024d0 <kbdgetc+0xb0>
      c += 'A' - 'a';
801024b3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801024b6:	5d                   	pop    %ebp
801024b7:	c3                   	ret    
801024b8:	90                   	nop
801024b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801024c0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801024c2:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801024c9:	5d                   	pop    %ebp
801024ca:	c3                   	ret    
801024cb:	90                   	nop
801024cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801024d0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801024d3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801024d6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801024d7:	83 f9 19             	cmp    $0x19,%ecx
801024da:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801024dd:	c3                   	ret    
801024de:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801024e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801024e5:	5d                   	pop    %ebp
801024e6:	c3                   	ret    
801024e7:	89 f6                	mov    %esi,%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <kbdintr>:

void
kbdintr(void)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801024f6:	68 20 24 10 80       	push   $0x80102420
801024fb:	e8 f0 e2 ff ff       	call   801007f0 <consoleintr>
}
80102500:	83 c4 10             	add    $0x10,%esp
80102503:	c9                   	leave  
80102504:	c3                   	ret    
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102510:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102515:	55                   	push   %ebp
80102516:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102518:	85 c0                	test   %eax,%eax
8010251a:	0f 84 c8 00 00 00    	je     801025e8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102520:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102527:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010252a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010252d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102534:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102537:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010253a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102541:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102544:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102547:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010254e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102551:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102554:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010255b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010255e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102561:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102568:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010256b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010256e:	8b 50 30             	mov    0x30(%eax),%edx
80102571:	c1 ea 10             	shr    $0x10,%edx
80102574:	80 fa 03             	cmp    $0x3,%dl
80102577:	77 77                	ja     801025f0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102579:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102580:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102583:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102586:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010258d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102590:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102593:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010259a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010259d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801025a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025aa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801025b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025b7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801025c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801025c4:	8b 50 20             	mov    0x20(%eax),%edx
801025c7:	89 f6                	mov    %esi,%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801025d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801025d6:	80 e6 10             	and    $0x10,%dh
801025d9:	75 f5                	jne    801025d0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801025e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025e5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801025e8:	5d                   	pop    %ebp
801025e9:	c3                   	ret    
801025ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801025f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025fa:	8b 50 20             	mov    0x20(%eax),%edx
801025fd:	e9 77 ff ff ff       	jmp    80102579 <lapicinit+0x69>
80102602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102610:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102615:	55                   	push   %ebp
80102616:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102618:	85 c0                	test   %eax,%eax
8010261a:	74 0c                	je     80102628 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010261c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010261f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102620:	c1 e8 18             	shr    $0x18,%eax
}
80102623:	c3                   	ret    
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102628:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010262a:	5d                   	pop    %ebp
8010262b:	c3                   	ret    
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102630:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102638:	85 c0                	test   %eax,%eax
8010263a:	74 0d                	je     80102649 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010263c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102643:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102646:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102649:	5d                   	pop    %ebp
8010264a:	c3                   	ret    
8010264b:	90                   	nop
8010264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102650 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
}
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret    
80102655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102660:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102661:	ba 70 00 00 00       	mov    $0x70,%edx
80102666:	b8 0f 00 00 00       	mov    $0xf,%eax
8010266b:	89 e5                	mov    %esp,%ebp
8010266d:	53                   	push   %ebx
8010266e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102671:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102674:	ee                   	out    %al,(%dx)
80102675:	ba 71 00 00 00       	mov    $0x71,%edx
8010267a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010267f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102680:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102682:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102685:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010268b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010268d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102690:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102693:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102695:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102698:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801026a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026a9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801026b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801026c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026cc:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026d5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026de:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801026ea:	5b                   	pop    %ebx
801026eb:	5d                   	pop    %ebp
801026ec:	c3                   	ret    
801026ed:	8d 76 00             	lea    0x0(%esi),%esi

801026f0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801026f0:	55                   	push   %ebp
801026f1:	ba 70 00 00 00       	mov    $0x70,%edx
801026f6:	b8 0b 00 00 00       	mov    $0xb,%eax
801026fb:	89 e5                	mov    %esp,%ebp
801026fd:	57                   	push   %edi
801026fe:	56                   	push   %esi
801026ff:	53                   	push   %ebx
80102700:	83 ec 4c             	sub    $0x4c,%esp
80102703:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102704:	ba 71 00 00 00       	mov    $0x71,%edx
80102709:	ec                   	in     (%dx),%al
8010270a:	83 e0 04             	and    $0x4,%eax
8010270d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102710:	31 db                	xor    %ebx,%ebx
80102712:	88 45 b7             	mov    %al,-0x49(%ebp)
80102715:	bf 70 00 00 00       	mov    $0x70,%edi
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102720:	89 d8                	mov    %ebx,%eax
80102722:	89 fa                	mov    %edi,%edx
80102724:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102725:	b9 71 00 00 00       	mov    $0x71,%ecx
8010272a:	89 ca                	mov    %ecx,%edx
8010272c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010272d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102730:	89 fa                	mov    %edi,%edx
80102732:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102735:	b8 02 00 00 00       	mov    $0x2,%eax
8010273a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010273b:	89 ca                	mov    %ecx,%edx
8010273d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010273e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102741:	89 fa                	mov    %edi,%edx
80102743:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102746:	b8 04 00 00 00       	mov    $0x4,%eax
8010274b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010274c:	89 ca                	mov    %ecx,%edx
8010274e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010274f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102752:	89 fa                	mov    %edi,%edx
80102754:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102757:	b8 07 00 00 00       	mov    $0x7,%eax
8010275c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010275d:	89 ca                	mov    %ecx,%edx
8010275f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102760:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102763:	89 fa                	mov    %edi,%edx
80102765:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102768:	b8 08 00 00 00       	mov    $0x8,%eax
8010276d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010276e:	89 ca                	mov    %ecx,%edx
80102770:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102771:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102774:	89 fa                	mov    %edi,%edx
80102776:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102779:	b8 09 00 00 00       	mov    $0x9,%eax
8010277e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010277f:	89 ca                	mov    %ecx,%edx
80102781:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102782:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102785:	89 fa                	mov    %edi,%edx
80102787:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010278a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010278f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102790:	89 ca                	mov    %ecx,%edx
80102792:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102793:	84 c0                	test   %al,%al
80102795:	78 89                	js     80102720 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102797:	89 d8                	mov    %ebx,%eax
80102799:	89 fa                	mov    %edi,%edx
8010279b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010279c:	89 ca                	mov    %ecx,%edx
8010279e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010279f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a2:	89 fa                	mov    %edi,%edx
801027a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801027a7:	b8 02 00 00 00       	mov    $0x2,%eax
801027ac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027ad:	89 ca                	mov    %ecx,%edx
801027af:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801027b0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b3:	89 fa                	mov    %edi,%edx
801027b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801027b8:	b8 04 00 00 00       	mov    $0x4,%eax
801027bd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027be:	89 ca                	mov    %ecx,%edx
801027c0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801027c1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c4:	89 fa                	mov    %edi,%edx
801027c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801027c9:	b8 07 00 00 00       	mov    $0x7,%eax
801027ce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027cf:	89 ca                	mov    %ecx,%edx
801027d1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801027d2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d5:	89 fa                	mov    %edi,%edx
801027d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801027da:	b8 08 00 00 00       	mov    $0x8,%eax
801027df:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e0:	89 ca                	mov    %ecx,%edx
801027e2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801027e3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e6:	89 fa                	mov    %edi,%edx
801027e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801027eb:	b8 09 00 00 00       	mov    $0x9,%eax
801027f0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f1:	89 ca                	mov    %ecx,%edx
801027f3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801027f4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801027f7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801027fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801027fd:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102800:	6a 18                	push   $0x18
80102802:	56                   	push   %esi
80102803:	50                   	push   %eax
80102804:	e8 b7 1b 00 00       	call   801043c0 <memcmp>
80102809:	83 c4 10             	add    $0x10,%esp
8010280c:	85 c0                	test   %eax,%eax
8010280e:	0f 85 0c ff ff ff    	jne    80102720 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102814:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102818:	75 78                	jne    80102892 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010281a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010281d:	89 c2                	mov    %eax,%edx
8010281f:	83 e0 0f             	and    $0xf,%eax
80102822:	c1 ea 04             	shr    $0x4,%edx
80102825:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102828:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010282b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010282e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102831:	89 c2                	mov    %eax,%edx
80102833:	83 e0 0f             	and    $0xf,%eax
80102836:	c1 ea 04             	shr    $0x4,%edx
80102839:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010283c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010283f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102842:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102845:	89 c2                	mov    %eax,%edx
80102847:	83 e0 0f             	and    $0xf,%eax
8010284a:	c1 ea 04             	shr    $0x4,%edx
8010284d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102850:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102853:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102856:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102859:	89 c2                	mov    %eax,%edx
8010285b:	83 e0 0f             	and    $0xf,%eax
8010285e:	c1 ea 04             	shr    $0x4,%edx
80102861:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102864:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102867:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010286a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010286d:	89 c2                	mov    %eax,%edx
8010286f:	83 e0 0f             	and    $0xf,%eax
80102872:	c1 ea 04             	shr    $0x4,%edx
80102875:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102878:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010287b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010287e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102881:	89 c2                	mov    %eax,%edx
80102883:	83 e0 0f             	and    $0xf,%eax
80102886:	c1 ea 04             	shr    $0x4,%edx
80102889:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010288c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010288f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102892:	8b 75 08             	mov    0x8(%ebp),%esi
80102895:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102898:	89 06                	mov    %eax,(%esi)
8010289a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010289d:	89 46 04             	mov    %eax,0x4(%esi)
801028a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028a3:	89 46 08             	mov    %eax,0x8(%esi)
801028a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028a9:	89 46 0c             	mov    %eax,0xc(%esi)
801028ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028af:	89 46 10             	mov    %eax,0x10(%esi)
801028b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801028b5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801028b8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801028bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028c2:	5b                   	pop    %ebx
801028c3:	5e                   	pop    %esi
801028c4:	5f                   	pop    %edi
801028c5:	5d                   	pop    %ebp
801028c6:	c3                   	ret    
801028c7:	66 90                	xchg   %ax,%ax
801028c9:	66 90                	xchg   %ax,%ax
801028cb:	66 90                	xchg   %ax,%ax
801028cd:	66 90                	xchg   %ax,%ax
801028cf:	90                   	nop

801028d0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801028d0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801028d6:	85 c9                	test   %ecx,%ecx
801028d8:	0f 8e 85 00 00 00    	jle    80102963 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801028de:	55                   	push   %ebp
801028df:	89 e5                	mov    %esp,%ebp
801028e1:	57                   	push   %edi
801028e2:	56                   	push   %esi
801028e3:	53                   	push   %ebx
801028e4:	31 db                	xor    %ebx,%ebx
801028e6:	83 ec 0c             	sub    $0xc,%esp
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801028f0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801028f5:	83 ec 08             	sub    $0x8,%esp
801028f8:	01 d8                	add    %ebx,%eax
801028fa:	83 c0 01             	add    $0x1,%eax
801028fd:	50                   	push   %eax
801028fe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102904:	e8 c7 d7 ff ff       	call   801000d0 <bread>
80102909:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010290b:	58                   	pop    %eax
8010290c:	5a                   	pop    %edx
8010290d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102914:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010291a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010291d:	e8 ae d7 ff ff       	call   801000d0 <bread>
80102922:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102924:	8d 47 5c             	lea    0x5c(%edi),%eax
80102927:	83 c4 0c             	add    $0xc,%esp
8010292a:	68 00 02 00 00       	push   $0x200
8010292f:	50                   	push   %eax
80102930:	8d 46 5c             	lea    0x5c(%esi),%eax
80102933:	50                   	push   %eax
80102934:	e8 e7 1a 00 00       	call   80104420 <memmove>
    bwrite(dbuf);  // write dst to disk
80102939:	89 34 24             	mov    %esi,(%esp)
8010293c:	e8 5f d8 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102941:	89 3c 24             	mov    %edi,(%esp)
80102944:	e8 97 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102949:	89 34 24             	mov    %esi,(%esp)
8010294c:	e8 8f d8 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102951:	83 c4 10             	add    $0x10,%esp
80102954:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
8010295a:	7f 94                	jg     801028f0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
8010295c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010295f:	5b                   	pop    %ebx
80102960:	5e                   	pop    %esi
80102961:	5f                   	pop    %edi
80102962:	5d                   	pop    %ebp
80102963:	f3 c3                	repz ret 
80102965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	53                   	push   %ebx
80102974:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102977:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010297d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102983:	e8 48 d7 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102988:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
8010298e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102991:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102993:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102995:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102998:	7e 1f                	jle    801029b9 <write_head+0x49>
8010299a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
801029a1:	31 d2                	xor    %edx,%edx
801029a3:	90                   	nop
801029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
801029a8:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
801029ae:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
801029b2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801029b5:	39 c2                	cmp    %eax,%edx
801029b7:	75 ef                	jne    801029a8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801029b9:	83 ec 0c             	sub    $0xc,%esp
801029bc:	53                   	push   %ebx
801029bd:	e8 de d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801029c2:	89 1c 24             	mov    %ebx,(%esp)
801029c5:	e8 16 d8 ff ff       	call   801001e0 <brelse>
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	53                   	push   %ebx
801029d4:	83 ec 2c             	sub    $0x2c,%esp
801029d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801029da:	68 60 74 10 80       	push   $0x80107460
801029df:	68 80 26 11 80       	push   $0x80112680
801029e4:	e8 17 17 00 00       	call   80104100 <initlock>
  readsb(dev, &sb);
801029e9:	58                   	pop    %eax
801029ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
801029ed:	5a                   	pop    %edx
801029ee:	50                   	push   %eax
801029ef:	53                   	push   %ebx
801029f0:	e8 db e8 ff ff       	call   801012d0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
801029f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
801029f8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
801029fb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
801029fc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102a02:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102a08:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a0d:	5a                   	pop    %edx
80102a0e:	50                   	push   %eax
80102a0f:	53                   	push   %ebx
80102a10:	e8 bb d6 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102a15:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a18:	83 c4 10             	add    $0x10,%esp
80102a1b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102a1d:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102a23:	7e 1c                	jle    80102a41 <initlog+0x71>
80102a25:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102a2c:	31 d2                	xor    %edx,%edx
80102a2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102a30:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102a34:	83 c2 04             	add    $0x4,%edx
80102a37:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102a3d:	39 da                	cmp    %ebx,%edx
80102a3f:	75 ef                	jne    80102a30 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102a41:	83 ec 0c             	sub    $0xc,%esp
80102a44:	50                   	push   %eax
80102a45:	e8 96 d7 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102a4a:	e8 81 fe ff ff       	call   801028d0 <install_trans>
  log.lh.n = 0;
80102a4f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102a56:	00 00 00 
  write_head(); // clear the log
80102a59:	e8 12 ff ff ff       	call   80102970 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a61:	c9                   	leave  
80102a62:	c3                   	ret    
80102a63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102a76:	68 80 26 11 80       	push   $0x80112680
80102a7b:	e8 80 17 00 00       	call   80104200 <acquire>
80102a80:	83 c4 10             	add    $0x10,%esp
80102a83:	eb 18                	jmp    80102a9d <begin_op+0x2d>
80102a85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102a88:	83 ec 08             	sub    $0x8,%esp
80102a8b:	68 80 26 11 80       	push   $0x80112680
80102a90:	68 80 26 11 80       	push   $0x80112680
80102a95:	e8 f6 11 00 00       	call   80103c90 <sleep>
80102a9a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102a9d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102aa2:	85 c0                	test   %eax,%eax
80102aa4:	75 e2                	jne    80102a88 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102aa6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102aab:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ab1:	83 c0 01             	add    $0x1,%eax
80102ab4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ab7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102aba:	83 fa 1e             	cmp    $0x1e,%edx
80102abd:	7f c9                	jg     80102a88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102abf:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102ac2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102ac7:	68 80 26 11 80       	push   $0x80112680
80102acc:	e8 4f 18 00 00       	call   80104320 <release>
      break;
    }
  }
}
80102ad1:	83 c4 10             	add    $0x10,%esp
80102ad4:	c9                   	leave  
80102ad5:	c3                   	ret    
80102ad6:	8d 76 00             	lea    0x0(%esi),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	57                   	push   %edi
80102ae4:	56                   	push   %esi
80102ae5:	53                   	push   %ebx
80102ae6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ae9:	68 80 26 11 80       	push   $0x80112680
80102aee:	e8 0d 17 00 00       	call   80104200 <acquire>
  log.outstanding -= 1;
80102af3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102af8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102afe:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102b01:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102b04:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102b06:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102b0b:	0f 85 23 01 00 00    	jne    80102c34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102b11:	85 c0                	test   %eax,%eax
80102b13:	0f 85 f7 00 00 00    	jne    80102c10 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102b19:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102b1c:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102b23:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b26:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102b28:	68 80 26 11 80       	push   $0x80112680
80102b2d:	e8 ee 17 00 00       	call   80104320 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102b32:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b38:	83 c4 10             	add    $0x10,%esp
80102b3b:	85 c9                	test   %ecx,%ecx
80102b3d:	0f 8e 8a 00 00 00    	jle    80102bcd <end_op+0xed>
80102b43:	90                   	nop
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102b48:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b4d:	83 ec 08             	sub    $0x8,%esp
80102b50:	01 d8                	add    %ebx,%eax
80102b52:	83 c0 01             	add    $0x1,%eax
80102b55:	50                   	push   %eax
80102b56:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b5c:	e8 6f d5 ff ff       	call   801000d0 <bread>
80102b61:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b63:	58                   	pop    %eax
80102b64:	5a                   	pop    %edx
80102b65:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b6c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b72:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102b75:	e8 56 d5 ff ff       	call   801000d0 <bread>
80102b7a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102b7c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102b7f:	83 c4 0c             	add    $0xc,%esp
80102b82:	68 00 02 00 00       	push   $0x200
80102b87:	50                   	push   %eax
80102b88:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b8b:	50                   	push   %eax
80102b8c:	e8 8f 18 00 00       	call   80104420 <memmove>
    bwrite(to);  // write the log
80102b91:	89 34 24             	mov    %esi,(%esp)
80102b94:	e8 07 d6 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102b99:	89 3c 24             	mov    %edi,(%esp)
80102b9c:	e8 3f d6 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ba1:	89 34 24             	mov    %esi,(%esp)
80102ba4:	e8 37 d6 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba9:	83 c4 10             	add    $0x10,%esp
80102bac:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102bb2:	7c 94                	jl     80102b48 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102bb4:	e8 b7 fd ff ff       	call   80102970 <write_head>
    install_trans(); // Now install writes to home locations
80102bb9:	e8 12 fd ff ff       	call   801028d0 <install_trans>
    log.lh.n = 0;
80102bbe:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102bc5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102bc8:	e8 a3 fd ff ff       	call   80102970 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102bcd:	83 ec 0c             	sub    $0xc,%esp
80102bd0:	68 80 26 11 80       	push   $0x80112680
80102bd5:	e8 26 16 00 00       	call   80104200 <acquire>
    log.committing = 0;
    wakeup(&log);
80102bda:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102be1:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102be8:	00 00 00 
    wakeup(&log);
80102beb:	e8 50 12 00 00       	call   80103e40 <wakeup>
    release(&log.lock);
80102bf0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bf7:	e8 24 17 00 00       	call   80104320 <release>
80102bfc:	83 c4 10             	add    $0x10,%esp
  }
}
80102bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c02:	5b                   	pop    %ebx
80102c03:	5e                   	pop    %esi
80102c04:	5f                   	pop    %edi
80102c05:	5d                   	pop    %ebp
80102c06:	c3                   	ret    
80102c07:	89 f6                	mov    %esi,%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102c10:	83 ec 0c             	sub    $0xc,%esp
80102c13:	68 80 26 11 80       	push   $0x80112680
80102c18:	e8 23 12 00 00       	call   80103e40 <wakeup>
  }
  release(&log.lock);
80102c1d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c24:	e8 f7 16 00 00       	call   80104320 <release>
80102c29:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102c34:	83 ec 0c             	sub    $0xc,%esp
80102c37:	68 64 74 10 80       	push   $0x80107464
80102c3c:	e8 2f d7 ff ff       	call   80100370 <panic>
80102c41:	eb 0d                	jmp    80102c50 <log_write>
80102c43:	90                   	nop
80102c44:	90                   	nop
80102c45:	90                   	nop
80102c46:	90                   	nop
80102c47:	90                   	nop
80102c48:	90                   	nop
80102c49:	90                   	nop
80102c4a:	90                   	nop
80102c4b:	90                   	nop
80102c4c:	90                   	nop
80102c4d:	90                   	nop
80102c4e:	90                   	nop
80102c4f:	90                   	nop

80102c50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	53                   	push   %ebx
80102c54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c57:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102c5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102c60:	83 fa 1d             	cmp    $0x1d,%edx
80102c63:	0f 8f 97 00 00 00    	jg     80102d00 <log_write+0xb0>
80102c69:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102c6e:	83 e8 01             	sub    $0x1,%eax
80102c71:	39 c2                	cmp    %eax,%edx
80102c73:	0f 8d 87 00 00 00    	jge    80102d00 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102c79:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c7e:	85 c0                	test   %eax,%eax
80102c80:	0f 8e 87 00 00 00    	jle    80102d0d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102c86:	83 ec 0c             	sub    $0xc,%esp
80102c89:	68 80 26 11 80       	push   $0x80112680
80102c8e:	e8 6d 15 00 00       	call   80104200 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102c93:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c99:	83 c4 10             	add    $0x10,%esp
80102c9c:	83 fa 00             	cmp    $0x0,%edx
80102c9f:	7e 50                	jle    80102cf1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ca1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102ca4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ca6:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102cac:	75 0b                	jne    80102cb9 <log_write+0x69>
80102cae:	eb 38                	jmp    80102ce8 <log_write+0x98>
80102cb0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102cb7:	74 2f                	je     80102ce8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102cb9:	83 c0 01             	add    $0x1,%eax
80102cbc:	39 d0                	cmp    %edx,%eax
80102cbe:	75 f0                	jne    80102cb0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102cc0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102cc7:	83 c2 01             	add    $0x1,%edx
80102cca:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102cd0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102cd3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102cda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cdd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102cde:	e9 3d 16 00 00       	jmp    80104320 <release>
80102ce3:	90                   	nop
80102ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102ce8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102cef:	eb df                	jmp    80102cd0 <log_write+0x80>
80102cf1:	8b 43 08             	mov    0x8(%ebx),%eax
80102cf4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102cf9:	75 d5                	jne    80102cd0 <log_write+0x80>
80102cfb:	eb ca                	jmp    80102cc7 <log_write+0x77>
80102cfd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d00:	83 ec 0c             	sub    $0xc,%esp
80102d03:	68 73 74 10 80       	push   $0x80107473
80102d08:	e8 63 d6 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d0d:	83 ec 0c             	sub    $0xc,%esp
80102d10:	68 89 74 10 80       	push   $0x80107489
80102d15:	e8 56 d6 ff ff       	call   80100370 <panic>
80102d1a:	66 90                	xchg   %ax,%ax
80102d1c:	66 90                	xchg   %ax,%ax
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d27:	e8 54 09 00 00       	call   80103680 <cpuid>
80102d2c:	89 c3                	mov    %eax,%ebx
80102d2e:	e8 4d 09 00 00       	call   80103680 <cpuid>
80102d33:	83 ec 04             	sub    $0x4,%esp
80102d36:	53                   	push   %ebx
80102d37:	50                   	push   %eax
80102d38:	68 a4 74 10 80       	push   $0x801074a4
80102d3d:	e8 1e d9 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102d42:	e8 79 28 00 00       	call   801055c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d47:	e8 b4 08 00 00       	call   80103600 <mycpu>
80102d4c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102d4e:	b8 01 00 00 00       	mov    $0x1,%eax
80102d53:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102d5a:	e8 41 0c 00 00       	call   801039a0 <scheduler>
80102d5f:	90                   	nop

80102d60 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102d66:	e8 f5 39 00 00       	call   80106760 <switchkvm>
  seginit();
80102d6b:	e8 60 38 00 00       	call   801065d0 <seginit>
  lapicinit();
80102d70:	e8 9b f7 ff ff       	call   80102510 <lapicinit>
  mpmain();
80102d75:	e8 a6 ff ff ff       	call   80102d20 <mpmain>
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102d80:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102d84:	83 e4 f0             	and    $0xfffffff0,%esp
80102d87:	ff 71 fc             	pushl  -0x4(%ecx)
80102d8a:	55                   	push   %ebp
80102d8b:	89 e5                	mov    %esp,%ebp
80102d8d:	53                   	push   %ebx
80102d8e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102d8f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102d94:	83 ec 08             	sub    $0x8,%esp
80102d97:	68 00 00 40 80       	push   $0x80400000
80102d9c:	68 f4 58 11 80       	push   $0x801158f4
80102da1:	e8 3a f5 ff ff       	call   801022e0 <kinit1>
  kvmalloc();      // kernel page table
80102da6:	e8 55 3e 00 00       	call   80106c00 <kvmalloc>
  mpinit();        // detect other processors
80102dab:	e8 70 01 00 00       	call   80102f20 <mpinit>
  lapicinit();     // interrupt controller
80102db0:	e8 5b f7 ff ff       	call   80102510 <lapicinit>
  seginit();       // segment descriptors
80102db5:	e8 16 38 00 00       	call   801065d0 <seginit>
  picinit();       // disable pic
80102dba:	e8 31 03 00 00       	call   801030f0 <picinit>
  ioapicinit();    // another interrupt controller
80102dbf:	e8 4c f3 ff ff       	call   80102110 <ioapicinit>
  consoleinit();   // console hardware
80102dc4:	e8 d7 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102dc9:	e8 62 2b 00 00       	call   80105930 <uartinit>
  pinit();         // process table
80102dce:	e8 0d 08 00 00       	call   801035e0 <pinit>
  shminit();       // shared memory
80102dd3:	e8 58 41 00 00       	call   80106f30 <shminit>
  tvinit();        // trap vectors
80102dd8:	e8 43 27 00 00       	call   80105520 <tvinit>
  binit();         // buffer cache
80102ddd:	e8 5e d2 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102de2:	e8 89 de ff ff       	call   80100c70 <fileinit>
  ideinit();       // disk 
80102de7:	e8 04 f1 ff ff       	call   80101ef0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102dec:	83 c4 0c             	add    $0xc,%esp
80102def:	68 8a 00 00 00       	push   $0x8a
80102df4:	68 8c a4 10 80       	push   $0x8010a48c
80102df9:	68 00 70 00 80       	push   $0x80007000
80102dfe:	e8 1d 16 00 00       	call   80104420 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e03:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e0a:	00 00 00 
80102e0d:	83 c4 10             	add    $0x10,%esp
80102e10:	05 80 27 11 80       	add    $0x80112780,%eax
80102e15:	39 d8                	cmp    %ebx,%eax
80102e17:	76 6a                	jbe    80102e83 <main+0x103>
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102e20:	e8 db 07 00 00       	call   80103600 <mycpu>
80102e25:	39 d8                	cmp    %ebx,%eax
80102e27:	74 41                	je     80102e6a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e29:	e8 82 f5 ff ff       	call   801023b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e2e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102e33:	c7 05 f8 6f 00 80 60 	movl   $0x80102d60,0x80006ff8
80102e3a:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e3d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e44:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e47:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102e4c:	0f b6 03             	movzbl (%ebx),%eax
80102e4f:	83 ec 08             	sub    $0x8,%esp
80102e52:	68 00 70 00 00       	push   $0x7000
80102e57:	50                   	push   %eax
80102e58:	e8 03 f8 ff ff       	call   80102660 <lapicstartap>
80102e5d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102e60:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102e66:	85 c0                	test   %eax,%eax
80102e68:	74 f6                	je     80102e60 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e6a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e71:	00 00 00 
80102e74:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102e7a:	05 80 27 11 80       	add    $0x80112780,%eax
80102e7f:	39 c3                	cmp    %eax,%ebx
80102e81:	72 9d                	jb     80102e20 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102e83:	83 ec 08             	sub    $0x8,%esp
80102e86:	68 00 00 00 8e       	push   $0x8e000000
80102e8b:	68 00 00 40 80       	push   $0x80400000
80102e90:	e8 bb f4 ff ff       	call   80102350 <kinit2>
  userinit();      // first user process
80102e95:	e8 36 08 00 00       	call   801036d0 <userinit>
  mpmain();        // finish this processor's setup
80102e9a:	e8 81 fe ff ff       	call   80102d20 <mpmain>
80102e9f:	90                   	nop

80102ea0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	57                   	push   %edi
80102ea4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102ea5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102eab:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102eac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102eaf:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102eb2:	39 de                	cmp    %ebx,%esi
80102eb4:	73 48                	jae    80102efe <mpsearch1+0x5e>
80102eb6:	8d 76 00             	lea    0x0(%esi),%esi
80102eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ec0:	83 ec 04             	sub    $0x4,%esp
80102ec3:	8d 7e 10             	lea    0x10(%esi),%edi
80102ec6:	6a 04                	push   $0x4
80102ec8:	68 b8 74 10 80       	push   $0x801074b8
80102ecd:	56                   	push   %esi
80102ece:	e8 ed 14 00 00       	call   801043c0 <memcmp>
80102ed3:	83 c4 10             	add    $0x10,%esp
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	75 1e                	jne    80102ef8 <mpsearch1+0x58>
80102eda:	8d 7e 10             	lea    0x10(%esi),%edi
80102edd:	89 f2                	mov    %esi,%edx
80102edf:	31 c9                	xor    %ecx,%ecx
80102ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102ee8:	0f b6 02             	movzbl (%edx),%eax
80102eeb:	83 c2 01             	add    $0x1,%edx
80102eee:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102ef0:	39 fa                	cmp    %edi,%edx
80102ef2:	75 f4                	jne    80102ee8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ef4:	84 c9                	test   %cl,%cl
80102ef6:	74 10                	je     80102f08 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102ef8:	39 fb                	cmp    %edi,%ebx
80102efa:	89 fe                	mov    %edi,%esi
80102efc:	77 c2                	ja     80102ec0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f01:	31 c0                	xor    %eax,%eax
}
80102f03:	5b                   	pop    %ebx
80102f04:	5e                   	pop    %esi
80102f05:	5f                   	pop    %edi
80102f06:	5d                   	pop    %ebp
80102f07:	c3                   	ret    
80102f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f0b:	89 f0                	mov    %esi,%eax
80102f0d:	5b                   	pop    %ebx
80102f0e:	5e                   	pop    %esi
80102f0f:	5f                   	pop    %edi
80102f10:	5d                   	pop    %ebp
80102f11:	c3                   	ret    
80102f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f20 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	57                   	push   %edi
80102f24:	56                   	push   %esi
80102f25:	53                   	push   %ebx
80102f26:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f29:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f30:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f37:	c1 e0 08             	shl    $0x8,%eax
80102f3a:	09 d0                	or     %edx,%eax
80102f3c:	c1 e0 04             	shl    $0x4,%eax
80102f3f:	85 c0                	test   %eax,%eax
80102f41:	75 1b                	jne    80102f5e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80102f43:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102f4a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102f51:	c1 e0 08             	shl    $0x8,%eax
80102f54:	09 d0                	or     %edx,%eax
80102f56:	c1 e0 0a             	shl    $0xa,%eax
80102f59:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102f5e:	ba 00 04 00 00       	mov    $0x400,%edx
80102f63:	e8 38 ff ff ff       	call   80102ea0 <mpsearch1>
80102f68:	85 c0                	test   %eax,%eax
80102f6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102f6d:	0f 84 37 01 00 00    	je     801030aa <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102f76:	8b 58 04             	mov    0x4(%eax),%ebx
80102f79:	85 db                	test   %ebx,%ebx
80102f7b:	0f 84 43 01 00 00    	je     801030c4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102f81:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102f87:	83 ec 04             	sub    $0x4,%esp
80102f8a:	6a 04                	push   $0x4
80102f8c:	68 bd 74 10 80       	push   $0x801074bd
80102f91:	56                   	push   %esi
80102f92:	e8 29 14 00 00       	call   801043c0 <memcmp>
80102f97:	83 c4 10             	add    $0x10,%esp
80102f9a:	85 c0                	test   %eax,%eax
80102f9c:	0f 85 22 01 00 00    	jne    801030c4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102fa2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102fa9:	3c 01                	cmp    $0x1,%al
80102fab:	74 08                	je     80102fb5 <mpinit+0x95>
80102fad:	3c 04                	cmp    $0x4,%al
80102faf:	0f 85 0f 01 00 00    	jne    801030c4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102fb5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fbc:	85 ff                	test   %edi,%edi
80102fbe:	74 21                	je     80102fe1 <mpinit+0xc1>
80102fc0:	31 d2                	xor    %edx,%edx
80102fc2:	31 c0                	xor    %eax,%eax
80102fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80102fc8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
80102fcf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fd0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80102fd3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fd5:	39 c7                	cmp    %eax,%edi
80102fd7:	75 ef                	jne    80102fc8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102fd9:	84 d2                	test   %dl,%dl
80102fdb:	0f 85 e3 00 00 00    	jne    801030c4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102fe1:	85 f6                	test   %esi,%esi
80102fe3:	0f 84 db 00 00 00    	je     801030c4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102fe9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102fef:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ff4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102ffb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103001:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103006:	01 d6                	add    %edx,%esi
80103008:	90                   	nop
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103010:	39 c6                	cmp    %eax,%esi
80103012:	76 23                	jbe    80103037 <mpinit+0x117>
80103014:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103017:	80 fa 04             	cmp    $0x4,%dl
8010301a:	0f 87 c0 00 00 00    	ja     801030e0 <mpinit+0x1c0>
80103020:	ff 24 95 fc 74 10 80 	jmp    *-0x7fef8b04(,%edx,4)
80103027:	89 f6                	mov    %esi,%esi
80103029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103030:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103033:	39 c6                	cmp    %eax,%esi
80103035:	77 dd                	ja     80103014 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103037:	85 db                	test   %ebx,%ebx
80103039:	0f 84 92 00 00 00    	je     801030d1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010303f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103042:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103046:	74 15                	je     8010305d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103048:	ba 22 00 00 00       	mov    $0x22,%edx
8010304d:	b8 70 00 00 00       	mov    $0x70,%eax
80103052:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103053:	ba 23 00 00 00       	mov    $0x23,%edx
80103058:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103059:	83 c8 01             	or     $0x1,%eax
8010305c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010305d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103060:	5b                   	pop    %ebx
80103061:	5e                   	pop    %esi
80103062:	5f                   	pop    %edi
80103063:	5d                   	pop    %ebp
80103064:	c3                   	ret    
80103065:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103068:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010306e:	83 f9 07             	cmp    $0x7,%ecx
80103071:	7f 19                	jg     8010308c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103073:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103077:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010307d:	83 c1 01             	add    $0x1,%ecx
80103080:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103086:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010308c:	83 c0 14             	add    $0x14,%eax
      continue;
8010308f:	e9 7c ff ff ff       	jmp    80103010 <mpinit+0xf0>
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103098:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010309c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010309f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
801030a5:	e9 66 ff ff ff       	jmp    80103010 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801030aa:	ba 00 00 01 00       	mov    $0x10000,%edx
801030af:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030b4:	e8 e7 fd ff ff       	call   80102ea0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030b9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801030bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030be:	0f 85 af fe ff ff    	jne    80102f73 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801030c4:	83 ec 0c             	sub    $0xc,%esp
801030c7:	68 c2 74 10 80       	push   $0x801074c2
801030cc:	e8 9f d2 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801030d1:	83 ec 0c             	sub    $0xc,%esp
801030d4:	68 dc 74 10 80       	push   $0x801074dc
801030d9:	e8 92 d2 ff ff       	call   80100370 <panic>
801030de:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801030e0:	31 db                	xor    %ebx,%ebx
801030e2:	e9 30 ff ff ff       	jmp    80103017 <mpinit+0xf7>
801030e7:	66 90                	xchg   %ax,%ax
801030e9:	66 90                	xchg   %ax,%ax
801030eb:	66 90                	xchg   %ax,%ax
801030ed:	66 90                	xchg   %ax,%ax
801030ef:	90                   	nop

801030f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801030f0:	55                   	push   %ebp
801030f1:	ba 21 00 00 00       	mov    $0x21,%edx
801030f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801030fb:	89 e5                	mov    %esp,%ebp
801030fd:	ee                   	out    %al,(%dx)
801030fe:	ba a1 00 00 00       	mov    $0xa1,%edx
80103103:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103104:	5d                   	pop    %ebp
80103105:	c3                   	ret    
80103106:	66 90                	xchg   %ax,%ax
80103108:	66 90                	xchg   %ax,%ax
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	57                   	push   %edi
80103114:	56                   	push   %esi
80103115:	53                   	push   %ebx
80103116:	83 ec 0c             	sub    $0xc,%esp
80103119:	8b 75 08             	mov    0x8(%ebp),%esi
8010311c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010311f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103125:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010312b:	e8 60 db ff ff       	call   80100c90 <filealloc>
80103130:	85 c0                	test   %eax,%eax
80103132:	89 06                	mov    %eax,(%esi)
80103134:	0f 84 a8 00 00 00    	je     801031e2 <pipealloc+0xd2>
8010313a:	e8 51 db ff ff       	call   80100c90 <filealloc>
8010313f:	85 c0                	test   %eax,%eax
80103141:	89 03                	mov    %eax,(%ebx)
80103143:	0f 84 87 00 00 00    	je     801031d0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103149:	e8 62 f2 ff ff       	call   801023b0 <kalloc>
8010314e:	85 c0                	test   %eax,%eax
80103150:	89 c7                	mov    %eax,%edi
80103152:	0f 84 b0 00 00 00    	je     80103208 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103158:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010315b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103162:	00 00 00 
  p->writeopen = 1;
80103165:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010316c:	00 00 00 
  p->nwrite = 0;
8010316f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103176:	00 00 00 
  p->nread = 0;
80103179:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103180:	00 00 00 
  initlock(&p->lock, "pipe");
80103183:	68 10 75 10 80       	push   $0x80107510
80103188:	50                   	push   %eax
80103189:	e8 72 0f 00 00       	call   80104100 <initlock>
  (*f0)->type = FD_PIPE;
8010318e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103190:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103193:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103199:	8b 06                	mov    (%esi),%eax
8010319b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010319f:	8b 06                	mov    (%esi),%eax
801031a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031a5:	8b 06                	mov    (%esi),%eax
801031a7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031aa:	8b 03                	mov    (%ebx),%eax
801031ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031b2:	8b 03                	mov    (%ebx),%eax
801031b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801031b8:	8b 03                	mov    (%ebx),%eax
801031ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801031be:	8b 03                	mov    (%ebx),%eax
801031c0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801031c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801031c6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801031c8:	5b                   	pop    %ebx
801031c9:	5e                   	pop    %esi
801031ca:	5f                   	pop    %edi
801031cb:	5d                   	pop    %ebp
801031cc:	c3                   	ret    
801031cd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801031d0:	8b 06                	mov    (%esi),%eax
801031d2:	85 c0                	test   %eax,%eax
801031d4:	74 1e                	je     801031f4 <pipealloc+0xe4>
    fileclose(*f0);
801031d6:	83 ec 0c             	sub    $0xc,%esp
801031d9:	50                   	push   %eax
801031da:	e8 71 db ff ff       	call   80100d50 <fileclose>
801031df:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801031e2:	8b 03                	mov    (%ebx),%eax
801031e4:	85 c0                	test   %eax,%eax
801031e6:	74 0c                	je     801031f4 <pipealloc+0xe4>
    fileclose(*f1);
801031e8:	83 ec 0c             	sub    $0xc,%esp
801031eb:	50                   	push   %eax
801031ec:	e8 5f db ff ff       	call   80100d50 <fileclose>
801031f1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801031f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801031f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801031fc:	5b                   	pop    %ebx
801031fd:	5e                   	pop    %esi
801031fe:	5f                   	pop    %edi
801031ff:	5d                   	pop    %ebp
80103200:	c3                   	ret    
80103201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103208:	8b 06                	mov    (%esi),%eax
8010320a:	85 c0                	test   %eax,%eax
8010320c:	75 c8                	jne    801031d6 <pipealloc+0xc6>
8010320e:	eb d2                	jmp    801031e2 <pipealloc+0xd2>

80103210 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	56                   	push   %esi
80103214:	53                   	push   %ebx
80103215:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103218:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010321b:	83 ec 0c             	sub    $0xc,%esp
8010321e:	53                   	push   %ebx
8010321f:	e8 dc 0f 00 00       	call   80104200 <acquire>
  if(writable){
80103224:	83 c4 10             	add    $0x10,%esp
80103227:	85 f6                	test   %esi,%esi
80103229:	74 45                	je     80103270 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010322b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103231:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103234:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010323b:	00 00 00 
    wakeup(&p->nread);
8010323e:	50                   	push   %eax
8010323f:	e8 fc 0b 00 00       	call   80103e40 <wakeup>
80103244:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103247:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010324d:	85 d2                	test   %edx,%edx
8010324f:	75 0a                	jne    8010325b <pipeclose+0x4b>
80103251:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103257:	85 c0                	test   %eax,%eax
80103259:	74 35                	je     80103290 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010325b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010325e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103261:	5b                   	pop    %ebx
80103262:	5e                   	pop    %esi
80103263:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103264:	e9 b7 10 00 00       	jmp    80104320 <release>
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103270:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103276:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103279:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103280:	00 00 00 
    wakeup(&p->nwrite);
80103283:	50                   	push   %eax
80103284:	e8 b7 0b 00 00       	call   80103e40 <wakeup>
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	eb b9                	jmp    80103247 <pipeclose+0x37>
8010328e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103290:	83 ec 0c             	sub    $0xc,%esp
80103293:	53                   	push   %ebx
80103294:	e8 87 10 00 00       	call   80104320 <release>
    kfree((char*)p);
80103299:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010329c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010329f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032a5:	e9 56 ef ff ff       	jmp    80102200 <kfree>
801032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801032b0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 28             	sub    $0x28,%esp
801032b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032bc:	53                   	push   %ebx
801032bd:	e8 3e 0f 00 00       	call   80104200 <acquire>
  for(i = 0; i < n; i++){
801032c2:	8b 45 10             	mov    0x10(%ebp),%eax
801032c5:	83 c4 10             	add    $0x10,%esp
801032c8:	85 c0                	test   %eax,%eax
801032ca:	0f 8e b9 00 00 00    	jle    80103389 <pipewrite+0xd9>
801032d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801032d3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801032d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801032df:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801032e5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801032e8:	03 4d 10             	add    0x10(%ebp),%ecx
801032eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801032ee:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801032f4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801032fa:	39 d0                	cmp    %edx,%eax
801032fc:	74 38                	je     80103336 <pipewrite+0x86>
801032fe:	eb 59                	jmp    80103359 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103300:	e8 9b 03 00 00       	call   801036a0 <myproc>
80103305:	8b 48 24             	mov    0x24(%eax),%ecx
80103308:	85 c9                	test   %ecx,%ecx
8010330a:	75 34                	jne    80103340 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010330c:	83 ec 0c             	sub    $0xc,%esp
8010330f:	57                   	push   %edi
80103310:	e8 2b 0b 00 00       	call   80103e40 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103315:	58                   	pop    %eax
80103316:	5a                   	pop    %edx
80103317:	53                   	push   %ebx
80103318:	56                   	push   %esi
80103319:	e8 72 09 00 00       	call   80103c90 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010331e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103324:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010332a:	83 c4 10             	add    $0x10,%esp
8010332d:	05 00 02 00 00       	add    $0x200,%eax
80103332:	39 c2                	cmp    %eax,%edx
80103334:	75 2a                	jne    80103360 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103336:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010333c:	85 c0                	test   %eax,%eax
8010333e:	75 c0                	jne    80103300 <pipewrite+0x50>
        release(&p->lock);
80103340:	83 ec 0c             	sub    $0xc,%esp
80103343:	53                   	push   %ebx
80103344:	e8 d7 0f 00 00       	call   80104320 <release>
        return -1;
80103349:	83 c4 10             	add    $0x10,%esp
8010334c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103354:	5b                   	pop    %ebx
80103355:	5e                   	pop    %esi
80103356:	5f                   	pop    %edi
80103357:	5d                   	pop    %ebp
80103358:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103359:	89 c2                	mov    %eax,%edx
8010335b:	90                   	nop
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103360:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103363:	8d 42 01             	lea    0x1(%edx),%eax
80103366:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010336a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103370:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103376:	0f b6 09             	movzbl (%ecx),%ecx
80103379:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010337d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103380:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103383:	0f 85 65 ff ff ff    	jne    801032ee <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103389:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010338f:	83 ec 0c             	sub    $0xc,%esp
80103392:	50                   	push   %eax
80103393:	e8 a8 0a 00 00       	call   80103e40 <wakeup>
  release(&p->lock);
80103398:	89 1c 24             	mov    %ebx,(%esp)
8010339b:	e8 80 0f 00 00       	call   80104320 <release>
  return n;
801033a0:	83 c4 10             	add    $0x10,%esp
801033a3:	8b 45 10             	mov    0x10(%ebp),%eax
801033a6:	eb a9                	jmp    80103351 <pipewrite+0xa1>
801033a8:	90                   	nop
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033b0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	57                   	push   %edi
801033b4:	56                   	push   %esi
801033b5:	53                   	push   %ebx
801033b6:	83 ec 18             	sub    $0x18,%esp
801033b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033bf:	53                   	push   %ebx
801033c0:	e8 3b 0e 00 00       	call   80104200 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033c5:	83 c4 10             	add    $0x10,%esp
801033c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033ce:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801033d4:	75 6a                	jne    80103440 <piperead+0x90>
801033d6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801033dc:	85 f6                	test   %esi,%esi
801033de:	0f 84 cc 00 00 00    	je     801034b0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033e4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801033ea:	eb 2d                	jmp    80103419 <piperead+0x69>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033f0:	83 ec 08             	sub    $0x8,%esp
801033f3:	53                   	push   %ebx
801033f4:	56                   	push   %esi
801033f5:	e8 96 08 00 00       	call   80103c90 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033fa:	83 c4 10             	add    $0x10,%esp
801033fd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103403:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103409:	75 35                	jne    80103440 <piperead+0x90>
8010340b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103411:	85 d2                	test   %edx,%edx
80103413:	0f 84 97 00 00 00    	je     801034b0 <piperead+0x100>
    if(myproc()->killed){
80103419:	e8 82 02 00 00       	call   801036a0 <myproc>
8010341e:	8b 48 24             	mov    0x24(%eax),%ecx
80103421:	85 c9                	test   %ecx,%ecx
80103423:	74 cb                	je     801033f0 <piperead+0x40>
      release(&p->lock);
80103425:	83 ec 0c             	sub    $0xc,%esp
80103428:	53                   	push   %ebx
80103429:	e8 f2 0e 00 00       	call   80104320 <release>
      return -1;
8010342e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103431:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103439:	5b                   	pop    %ebx
8010343a:	5e                   	pop    %esi
8010343b:	5f                   	pop    %edi
8010343c:	5d                   	pop    %ebp
8010343d:	c3                   	ret    
8010343e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103440:	8b 45 10             	mov    0x10(%ebp),%eax
80103443:	85 c0                	test   %eax,%eax
80103445:	7e 69                	jle    801034b0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103447:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010344d:	31 c9                	xor    %ecx,%ecx
8010344f:	eb 15                	jmp    80103466 <piperead+0xb6>
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103458:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010345e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103464:	74 5a                	je     801034c0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103466:	8d 70 01             	lea    0x1(%eax),%esi
80103469:	25 ff 01 00 00       	and    $0x1ff,%eax
8010346e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103474:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103479:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010347c:	83 c1 01             	add    $0x1,%ecx
8010347f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103482:	75 d4                	jne    80103458 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103484:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010348a:	83 ec 0c             	sub    $0xc,%esp
8010348d:	50                   	push   %eax
8010348e:	e8 ad 09 00 00       	call   80103e40 <wakeup>
  release(&p->lock);
80103493:	89 1c 24             	mov    %ebx,(%esp)
80103496:	e8 85 0e 00 00       	call   80104320 <release>
  return i;
8010349b:	8b 45 10             	mov    0x10(%ebp),%eax
8010349e:	83 c4 10             	add    $0x10,%esp
}
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801034b7:	eb cb                	jmp    80103484 <piperead+0xd4>
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034c0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801034c3:	eb bf                	jmp    80103484 <piperead+0xd4>
801034c5:	66 90                	xchg   %ax,%ax
801034c7:	66 90                	xchg   %ax,%ax
801034c9:	66 90                	xchg   %ax,%ax
801034cb:	66 90                	xchg   %ax,%ax
801034cd:	66 90                	xchg   %ax,%ax
801034cf:	90                   	nop

801034d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801034dc:	68 20 2d 11 80       	push   $0x80112d20
801034e1:	e8 1a 0d 00 00       	call   80104200 <acquire>
801034e6:	83 c4 10             	add    $0x10,%esp
801034e9:	eb 10                	jmp    801034fb <allocproc+0x2b>
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f0:	83 eb 80             	sub    $0xffffff80,%ebx
801034f3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801034f9:	74 75                	je     80103570 <allocproc+0xa0>
    if(p->state == UNUSED)
801034fb:	8b 43 0c             	mov    0xc(%ebx),%eax
801034fe:	85 c0                	test   %eax,%eax
80103500:	75 ee                	jne    801034f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103502:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103507:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010350a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103511:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103516:	8d 50 01             	lea    0x1(%eax),%edx
80103519:	89 43 10             	mov    %eax,0x10(%ebx)
8010351c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
80103522:	e8 f9 0d 00 00       	call   80104320 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103527:	e8 84 ee ff ff       	call   801023b0 <kalloc>
8010352c:	83 c4 10             	add    $0x10,%esp
8010352f:	85 c0                	test   %eax,%eax
80103531:	89 43 08             	mov    %eax,0x8(%ebx)
80103534:	74 51                	je     80103587 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103536:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010353c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010353f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103544:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103547:	c7 40 14 12 55 10 80 	movl   $0x80105512,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010354e:	6a 14                	push   $0x14
80103550:	6a 00                	push   $0x0
80103552:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103553:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103556:	e8 15 0e 00 00       	call   80104370 <memset>
  p->context->eip = (uint)forkret;
8010355b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010355e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103561:	c7 40 10 90 35 10 80 	movl   $0x80103590,0x10(%eax)

  return p;
80103568:	89 d8                	mov    %ebx,%eax
}
8010356a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010356d:	c9                   	leave  
8010356e:	c3                   	ret    
8010356f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	68 20 2d 11 80       	push   $0x80112d20
80103578:	e8 a3 0d 00 00       	call   80104320 <release>
  return 0;
8010357d:	83 c4 10             	add    $0x10,%esp
80103580:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103585:	c9                   	leave  
80103586:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103587:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010358e:	eb da                	jmp    8010356a <allocproc+0x9a>

80103590 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103596:	68 20 2d 11 80       	push   $0x80112d20
8010359b:	e8 80 0d 00 00       	call   80104320 <release>

  if (first) {
801035a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035a5:	83 c4 10             	add    $0x10,%esp
801035a8:	85 c0                	test   %eax,%eax
801035aa:	75 04                	jne    801035b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035ac:	c9                   	leave  
801035ad:	c3                   	ret    
801035ae:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035b0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035b3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ba:	00 00 00 
    iinit(ROOTDEV);
801035bd:	6a 01                	push   $0x1
801035bf:	e8 cc dd ff ff       	call   80101390 <iinit>
    initlog(ROOTDEV);
801035c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035cb:	e8 00 f4 ff ff       	call   801029d0 <initlog>
801035d0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035d3:	c9                   	leave  
801035d4:	c3                   	ret    
801035d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035e0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801035e6:	68 15 75 10 80       	push   $0x80107515
801035eb:	68 20 2d 11 80       	push   $0x80112d20
801035f0:	e8 0b 0b 00 00       	call   80104100 <initlock>
}
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	c9                   	leave  
801035f9:	c3                   	ret    
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103600 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	56                   	push   %esi
80103604:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103605:	9c                   	pushf  
80103606:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103607:	f6 c4 02             	test   $0x2,%ah
8010360a:	75 5b                	jne    80103667 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010360c:	e8 ff ef ff ff       	call   80102610 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103611:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103617:	85 f6                	test   %esi,%esi
80103619:	7e 3f                	jle    8010365a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010361b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103622:	39 d0                	cmp    %edx,%eax
80103624:	74 30                	je     80103656 <mycpu+0x56>
80103626:	b9 30 28 11 80       	mov    $0x80112830,%ecx
8010362b:	31 d2                	xor    %edx,%edx
8010362d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103630:	83 c2 01             	add    $0x1,%edx
80103633:	39 f2                	cmp    %esi,%edx
80103635:	74 23                	je     8010365a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103637:	0f b6 19             	movzbl (%ecx),%ebx
8010363a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103640:	39 d8                	cmp    %ebx,%eax
80103642:	75 ec                	jne    80103630 <mycpu+0x30>
      return &cpus[i];
80103644:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010364a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010364d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010364e:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103653:	5e                   	pop    %esi
80103654:	5d                   	pop    %ebp
80103655:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103656:	31 d2                	xor    %edx,%edx
80103658:	eb ea                	jmp    80103644 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010365a:	83 ec 0c             	sub    $0xc,%esp
8010365d:	68 1c 75 10 80       	push   $0x8010751c
80103662:	e8 09 cd ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103667:	83 ec 0c             	sub    $0xc,%esp
8010366a:	68 f8 75 10 80       	push   $0x801075f8
8010366f:	e8 fc cc ff ff       	call   80100370 <panic>
80103674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010367a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103680 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103686:	e8 75 ff ff ff       	call   80103600 <mycpu>
8010368b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103690:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103691:	c1 f8 04             	sar    $0x4,%eax
80103694:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010369a:	c3                   	ret    
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036a0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	53                   	push   %ebx
801036a4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801036a7:	e8 14 0b 00 00       	call   801041c0 <pushcli>
  c = mycpu();
801036ac:	e8 4f ff ff ff       	call   80103600 <mycpu>
  p = c->proc;
801036b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036b7:	e8 f4 0b 00 00       	call   801042b0 <popcli>
  return p;
}
801036bc:	83 c4 04             	add    $0x4,%esp
801036bf:	89 d8                	mov    %ebx,%eax
801036c1:	5b                   	pop    %ebx
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
801036c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036d0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801036d7:	e8 f4 fd ff ff       	call   801034d0 <allocproc>
801036dc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801036de:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036e3:	e8 98 34 00 00       	call   80106b80 <setupkvm>
801036e8:	85 c0                	test   %eax,%eax
801036ea:	89 43 04             	mov    %eax,0x4(%ebx)
801036ed:	0f 84 ed 00 00 00    	je     801037e0 <userinit+0x110>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036f3:	83 ec 04             	sub    $0x4,%esp
801036f6:	68 2c 00 00 00       	push   $0x2c
801036fb:	68 60 a4 10 80       	push   $0x8010a460
80103700:	50                   	push   %eax
80103701:	e8 8a 31 00 00       	call   80106890 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103706:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103709:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010370f:	6a 4c                	push   $0x4c
80103711:	6a 00                	push   $0x0
80103713:	ff 73 18             	pushl  0x18(%ebx)
80103716:	e8 55 0c 00 00       	call   80104370 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010371b:	8b 43 18             	mov    0x18(%ebx),%eax
8010371e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103723:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  p->tf->esp = STACKBASE;
  p->tf->ebp = STACKBASE;

  if(allocuvm(p->pgdir, PGROUNDDOWN(STACKBASE), STACKBASE) == 0)
80103728:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010372b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010372f:	8b 43 18             	mov    0x18(%ebx),%eax
80103732:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103736:	8b 43 18             	mov    0x18(%ebx),%eax
80103739:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010373d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103741:	8b 43 18             	mov    0x18(%ebx),%eax
80103744:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103748:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010374c:	8b 43 18             	mov    0x18(%ebx),%eax
8010374f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103756:	8b 43 18             	mov    0x18(%ebx),%eax
80103759:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103760:	8b 43 18             	mov    0x18(%ebx),%eax
80103763:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->tf->esp = STACKBASE;
8010376a:	8b 43 18             	mov    0x18(%ebx),%eax
8010376d:	c7 40 44 ff ff ff 7f 	movl   $0x7fffffff,0x44(%eax)
  p->tf->ebp = STACKBASE;
80103774:	8b 43 18             	mov    0x18(%ebx),%eax
80103777:	c7 40 08 ff ff ff 7f 	movl   $0x7fffffff,0x8(%eax)

  if(allocuvm(p->pgdir, PGROUNDDOWN(STACKBASE), STACKBASE) == 0)
8010377e:	68 ff ff ff 7f       	push   $0x7fffffff
80103783:	68 00 f0 ff 7f       	push   $0x7ffff000
80103788:	ff 73 04             	pushl  0x4(%ebx)
8010378b:	e8 40 32 00 00       	call   801069d0 <allocuvm>
80103790:	83 c4 10             	add    $0x10,%esp
80103793:	85 c0                	test   %eax,%eax
80103795:	74 56                	je     801037ed <userinit+0x11d>
    panic("There are problems setting up first user process (defs.h)");

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103797:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010379a:	83 ec 04             	sub    $0x4,%esp
8010379d:	6a 10                	push   $0x10
8010379f:	68 45 75 10 80       	push   $0x80107545
801037a4:	50                   	push   %eax
801037a5:	e8 c6 0d 00 00       	call   80104570 <safestrcpy>
  p->cwd = namei("/");
801037aa:	c7 04 24 4e 75 10 80 	movl   $0x8010754e,(%esp)
801037b1:	e8 2a e6 ff ff       	call   80101de0 <namei>
801037b6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801037b9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037c0:	e8 3b 0a 00 00       	call   80104200 <acquire>

  p->state = RUNNABLE;
801037c5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801037cc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037d3:	e8 48 0b 00 00       	call   80104320 <release>
}
801037d8:	83 c4 10             	add    $0x10,%esp
801037db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037de:	c9                   	leave  
801037df:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	68 2c 75 10 80       	push   $0x8010752c
801037e8:	e8 83 cb ff ff       	call   80100370 <panic>
  p->tf->eip = 0;  // beginning of initcode.S
  p->tf->esp = STACKBASE;
  p->tf->ebp = STACKBASE;

  if(allocuvm(p->pgdir, PGROUNDDOWN(STACKBASE), STACKBASE) == 0)
    panic("There are problems setting up first user process (defs.h)");
801037ed:	83 ec 0c             	sub    $0xc,%esp
801037f0:	68 20 76 10 80       	push   $0x80107620
801037f5:	e8 76 cb ff ff       	call   80100370 <panic>
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103800 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103808:	e8 b3 09 00 00       	call   801041c0 <pushcli>
  c = mycpu();
8010380d:	e8 ee fd ff ff       	call   80103600 <mycpu>
  p = c->proc;
80103812:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103818:	e8 93 0a 00 00       	call   801042b0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010381d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103820:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103822:	7e 34                	jle    80103858 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103824:	83 ec 04             	sub    $0x4,%esp
80103827:	01 c6                	add    %eax,%esi
80103829:	56                   	push   %esi
8010382a:	50                   	push   %eax
8010382b:	ff 73 04             	pushl  0x4(%ebx)
8010382e:	e8 9d 31 00 00       	call   801069d0 <allocuvm>
80103833:	83 c4 10             	add    $0x10,%esp
80103836:	85 c0                	test   %eax,%eax
80103838:	74 36                	je     80103870 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010383a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010383d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010383f:	53                   	push   %ebx
80103840:	e8 3b 2f 00 00       	call   80106780 <switchuvm>
  return 0;
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	31 c0                	xor    %eax,%eax
}
8010384a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010384d:	5b                   	pop    %ebx
8010384e:	5e                   	pop    %esi
8010384f:	5d                   	pop    %ebp
80103850:	c3                   	ret    
80103851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103858:	74 e0                	je     8010383a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010385a:	83 ec 04             	sub    $0x4,%esp
8010385d:	01 c6                	add    %eax,%esi
8010385f:	56                   	push   %esi
80103860:	50                   	push   %eax
80103861:	ff 73 04             	pushl  0x4(%ebx)
80103864:	e8 67 32 00 00       	call   80106ad0 <deallocuvm>
80103869:	83 c4 10             	add    $0x10,%esp
8010386c:	85 c0                	test   %eax,%eax
8010386e:	75 ca                	jne    8010383a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103875:	eb d3                	jmp    8010384a <growproc+0x4a>
80103877:	89 f6                	mov    %esi,%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103889:	e8 32 09 00 00       	call   801041c0 <pushcli>
  c = mycpu();
8010388e:	e8 6d fd ff ff       	call   80103600 <mycpu>
  p = c->proc;
80103893:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103899:	e8 12 0a 00 00       	call   801042b0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010389e:	e8 2d fc ff ff       	call   801034d0 <allocproc>
801038a3:	85 c0                	test   %eax,%eax
801038a5:	89 c7                	mov    %eax,%edi
801038a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038aa:	0f 84 b5 00 00 00    	je     80103965 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  //if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
  if ( (np->pgdir = copyuvm(curproc)) == 0 ) {
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	53                   	push   %ebx
801038b4:	e8 97 33 00 00       	call   80106c50 <copyuvm>
801038b9:	83 c4 10             	add    $0x10,%esp
801038bc:	85 c0                	test   %eax,%eax
801038be:	89 47 04             	mov    %eax,0x4(%edi)
801038c1:	0f 84 a5 00 00 00    	je     8010396c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801038c7:	8b 03                	mov    (%ebx),%eax
801038c9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038cc:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801038ce:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038d1:	89 c8                	mov    %ecx,%eax
801038d3:	8b 79 18             	mov    0x18(%ecx),%edi
801038d6:	8b 73 18             	mov    0x18(%ebx),%esi
801038d9:	b9 13 00 00 00       	mov    $0x13,%ecx
801038de:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038e0:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801038e2:	8b 40 18             	mov    0x18(%eax),%eax
801038e5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801038f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038f4:	85 c0                	test   %eax,%eax
801038f6:	74 13                	je     8010390b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038f8:	83 ec 0c             	sub    $0xc,%esp
801038fb:	50                   	push   %eax
801038fc:	e8 ff d3 ff ff       	call   80100d00 <filedup>
80103901:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103904:	83 c4 10             	add    $0x10,%esp
80103907:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010390b:	83 c6 01             	add    $0x1,%esi
8010390e:	83 fe 10             	cmp    $0x10,%esi
80103911:	75 dd                	jne    801038f0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103913:	83 ec 0c             	sub    $0xc,%esp
80103916:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103919:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010391c:	e8 3f dc ff ff       	call   80101560 <idup>
80103921:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103924:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103927:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010392a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010392d:	6a 10                	push   $0x10
8010392f:	53                   	push   %ebx
80103930:	50                   	push   %eax
80103931:	e8 3a 0c 00 00       	call   80104570 <safestrcpy>

  pid = np->pid;
80103936:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103939:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103940:	e8 bb 08 00 00       	call   80104200 <acquire>

  np->state = RUNNABLE;
80103945:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
8010394c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103953:	e8 c8 09 00 00       	call   80104320 <release>

  return pid;
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	89 d8                	mov    %ebx,%eax
}
8010395d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103960:	5b                   	pop    %ebx
80103961:	5e                   	pop    %esi
80103962:	5f                   	pop    %edi
80103963:	5d                   	pop    %ebp
80103964:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010396a:	eb f1                	jmp    8010395d <fork+0xdd>
  }

  // Copy process state from proc.
  //if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
  if ( (np->pgdir = copyuvm(curproc)) == 0 ) {
    kfree(np->kstack);
8010396c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010396f:	83 ec 0c             	sub    $0xc,%esp
80103972:	ff 77 08             	pushl  0x8(%edi)
80103975:	e8 86 e8 ff ff       	call   80102200 <kfree>
    np->kstack = 0;
8010397a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103981:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103988:	83 c4 10             	add    $0x10,%esp
8010398b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103990:	eb cb                	jmp    8010395d <fork+0xdd>
80103992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
801039a6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801039a9:	e8 52 fc ff ff       	call   80103600 <mycpu>
801039ae:	8d 78 04             	lea    0x4(%eax),%edi
801039b1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039b3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039ba:	00 00 00 
801039bd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801039c0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039c1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039c9:	68 20 2d 11 80       	push   $0x80112d20
801039ce:	e8 2d 08 00 00       	call   80104200 <acquire>
801039d3:	83 c4 10             	add    $0x10,%esp
801039d6:	eb 13                	jmp    801039eb <scheduler+0x4b>
801039d8:	90                   	nop
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e0:	83 eb 80             	sub    $0xffffff80,%ebx
801039e3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801039e9:	74 45                	je     80103a30 <scheduler+0x90>
      if(p->state != RUNNABLE)
801039eb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039ef:	75 ef                	jne    801039e0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
801039f1:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801039f4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039fa:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039fb:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
801039fe:	e8 7d 2d 00 00       	call   80106780 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a03:	58                   	pop    %eax
80103a04:	5a                   	pop    %edx
80103a05:	ff 73 9c             	pushl  -0x64(%ebx)
80103a08:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a09:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)

      swtch(&(c->scheduler), p->context);
80103a10:	e8 b6 0b 00 00       	call   801045cb <swtch>
      switchkvm();
80103a15:	e8 46 2d 00 00       	call   80106760 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a1a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a1d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a23:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a2a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a2d:	75 bc                	jne    801039eb <scheduler+0x4b>
80103a2f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	68 20 2d 11 80       	push   $0x80112d20
80103a38:	e8 e3 08 00 00       	call   80104320 <release>

  }
80103a3d:	83 c4 10             	add    $0x10,%esp
80103a40:	e9 7b ff ff ff       	jmp    801039c0 <scheduler+0x20>
80103a45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a50 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a55:	e8 66 07 00 00       	call   801041c0 <pushcli>
  c = mycpu();
80103a5a:	e8 a1 fb ff ff       	call   80103600 <mycpu>
  p = c->proc;
80103a5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a65:	e8 46 08 00 00       	call   801042b0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103a6a:	83 ec 0c             	sub    $0xc,%esp
80103a6d:	68 20 2d 11 80       	push   $0x80112d20
80103a72:	e8 09 07 00 00       	call   80104180 <holding>
80103a77:	83 c4 10             	add    $0x10,%esp
80103a7a:	85 c0                	test   %eax,%eax
80103a7c:	74 4f                	je     80103acd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103a7e:	e8 7d fb ff ff       	call   80103600 <mycpu>
80103a83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a8a:	75 68                	jne    80103af4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103a8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a90:	74 55                	je     80103ae7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a92:	9c                   	pushf  
80103a93:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103a94:	f6 c4 02             	test   $0x2,%ah
80103a97:	75 41                	jne    80103ada <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a99:	e8 62 fb ff ff       	call   80103600 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a9e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103aa1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103aa7:	e8 54 fb ff ff       	call   80103600 <mycpu>
80103aac:	83 ec 08             	sub    $0x8,%esp
80103aaf:	ff 70 04             	pushl  0x4(%eax)
80103ab2:	53                   	push   %ebx
80103ab3:	e8 13 0b 00 00       	call   801045cb <swtch>
  mycpu()->intena = intena;
80103ab8:	e8 43 fb ff ff       	call   80103600 <mycpu>
}
80103abd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103ac0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac9:	5b                   	pop    %ebx
80103aca:	5e                   	pop    %esi
80103acb:	5d                   	pop    %ebp
80103acc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103acd:	83 ec 0c             	sub    $0xc,%esp
80103ad0:	68 50 75 10 80       	push   $0x80107550
80103ad5:	e8 96 c8 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	68 7c 75 10 80       	push   $0x8010757c
80103ae2:	e8 89 c8 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103ae7:	83 ec 0c             	sub    $0xc,%esp
80103aea:	68 6e 75 10 80       	push   $0x8010756e
80103aef:	e8 7c c8 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103af4:	83 ec 0c             	sub    $0xc,%esp
80103af7:	68 62 75 10 80       	push   $0x80107562
80103afc:	e8 6f c8 ff ff       	call   80100370 <panic>
80103b01:	eb 0d                	jmp    80103b10 <exit>
80103b03:	90                   	nop
80103b04:	90                   	nop
80103b05:	90                   	nop
80103b06:	90                   	nop
80103b07:	90                   	nop
80103b08:	90                   	nop
80103b09:	90                   	nop
80103b0a:	90                   	nop
80103b0b:	90                   	nop
80103b0c:	90                   	nop
80103b0d:	90                   	nop
80103b0e:	90                   	nop
80103b0f:	90                   	nop

80103b10 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b19:	e8 a2 06 00 00       	call   801041c0 <pushcli>
  c = mycpu();
80103b1e:	e8 dd fa ff ff       	call   80103600 <mycpu>
  p = c->proc;
80103b23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103b29:	e8 82 07 00 00       	call   801042b0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b2e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103b34:	8d 5e 28             	lea    0x28(%esi),%ebx
80103b37:	8d 7e 68             	lea    0x68(%esi),%edi
80103b3a:	0f 84 e7 00 00 00    	je     80103c27 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103b40:	8b 03                	mov    (%ebx),%eax
80103b42:	85 c0                	test   %eax,%eax
80103b44:	74 12                	je     80103b58 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103b46:	83 ec 0c             	sub    $0xc,%esp
80103b49:	50                   	push   %eax
80103b4a:	e8 01 d2 ff ff       	call   80100d50 <fileclose>
      curproc->ofile[fd] = 0;
80103b4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103b55:	83 c4 10             	add    $0x10,%esp
80103b58:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103b5b:	39 df                	cmp    %ebx,%edi
80103b5d:	75 e1                	jne    80103b40 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b5f:	e8 0c ef ff ff       	call   80102a70 <begin_op>
  iput(curproc->cwd);
80103b64:	83 ec 0c             	sub    $0xc,%esp
80103b67:	ff 76 68             	pushl  0x68(%esi)
80103b6a:	e8 51 db ff ff       	call   801016c0 <iput>
  end_op();
80103b6f:	e8 6c ef ff ff       	call   80102ae0 <end_op>
  curproc->cwd = 0;
80103b74:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103b7b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b82:	e8 79 06 00 00       	call   80104200 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103b87:	8b 56 14             	mov    0x14(%esi),%edx
80103b8a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b8d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103b92:	eb 0e                	jmp    80103ba2 <exit+0x92>
80103b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b98:	83 e8 80             	sub    $0xffffff80,%eax
80103b9b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ba0:	74 1c                	je     80103bbe <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103ba2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ba6:	75 f0                	jne    80103b98 <exit+0x88>
80103ba8:	3b 50 20             	cmp    0x20(%eax),%edx
80103bab:	75 eb                	jne    80103b98 <exit+0x88>
      p->state = RUNNABLE;
80103bad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb4:	83 e8 80             	sub    $0xffffff80,%eax
80103bb7:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103bbc:	75 e4                	jne    80103ba2 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103bbe:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103bc4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bc9:	eb 10                	jmp    80103bdb <exit+0xcb>
80103bcb:	90                   	nop
80103bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bd0:	83 ea 80             	sub    $0xffffff80,%edx
80103bd3:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103bd9:	74 33                	je     80103c0e <exit+0xfe>
    if(p->parent == curproc){
80103bdb:	39 72 14             	cmp    %esi,0x14(%edx)
80103bde:	75 f0                	jne    80103bd0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103be0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103be4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103be7:	75 e7                	jne    80103bd0 <exit+0xc0>
80103be9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103bee:	eb 0a                	jmp    80103bfa <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bf0:	83 e8 80             	sub    $0xffffff80,%eax
80103bf3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103bf8:	74 d6                	je     80103bd0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103bfa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103bfe:	75 f0                	jne    80103bf0 <exit+0xe0>
80103c00:	3b 48 20             	cmp    0x20(%eax),%ecx
80103c03:	75 eb                	jne    80103bf0 <exit+0xe0>
      p->state = RUNNABLE;
80103c05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103c0c:	eb e2                	jmp    80103bf0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c0e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103c15:	e8 36 fe ff ff       	call   80103a50 <sched>
  panic("zombie exit");
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 9d 75 10 80       	push   $0x8010759d
80103c22:	e8 49 c7 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	68 90 75 10 80       	push   $0x80107590
80103c2f:	e8 3c c7 ff ff       	call   80100370 <panic>
80103c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c40 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	53                   	push   %ebx
80103c44:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c47:	68 20 2d 11 80       	push   $0x80112d20
80103c4c:	e8 af 05 00 00       	call   80104200 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c51:	e8 6a 05 00 00       	call   801041c0 <pushcli>
  c = mycpu();
80103c56:	e8 a5 f9 ff ff       	call   80103600 <mycpu>
  p = c->proc;
80103c5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c61:	e8 4a 06 00 00       	call   801042b0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103c66:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103c6d:	e8 de fd ff ff       	call   80103a50 <sched>
  release(&ptable.lock);
80103c72:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c79:	e8 a2 06 00 00       	call   80104320 <release>
}
80103c7e:	83 c4 10             	add    $0x10,%esp
80103c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c84:	c9                   	leave  
80103c85:	c3                   	ret    
80103c86:	8d 76 00             	lea    0x0(%esi),%esi
80103c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c90 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	83 ec 0c             	sub    $0xc,%esp
80103c99:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c9f:	e8 1c 05 00 00       	call   801041c0 <pushcli>
  c = mycpu();
80103ca4:	e8 57 f9 ff ff       	call   80103600 <mycpu>
  p = c->proc;
80103ca9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103caf:	e8 fc 05 00 00       	call   801042b0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103cb4:	85 db                	test   %ebx,%ebx
80103cb6:	0f 84 87 00 00 00    	je     80103d43 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103cbc:	85 f6                	test   %esi,%esi
80103cbe:	74 76                	je     80103d36 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103cc0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103cc6:	74 50                	je     80103d18 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	68 20 2d 11 80       	push   $0x80112d20
80103cd0:	e8 2b 05 00 00       	call   80104200 <acquire>
    release(lk);
80103cd5:	89 34 24             	mov    %esi,(%esp)
80103cd8:	e8 43 06 00 00       	call   80104320 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103cdd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ce0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103ce7:	e8 64 fd ff ff       	call   80103a50 <sched>

  // Tidy up.
  p->chan = 0;
80103cec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103cf3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cfa:	e8 21 06 00 00       	call   80104320 <release>
    acquire(lk);
80103cff:	89 75 08             	mov    %esi,0x8(%ebp)
80103d02:	83 c4 10             	add    $0x10,%esp
  }
}
80103d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d08:	5b                   	pop    %ebx
80103d09:	5e                   	pop    %esi
80103d0a:	5f                   	pop    %edi
80103d0b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d0c:	e9 ef 04 00 00       	jmp    80104200 <acquire>
80103d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d18:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d1b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d22:	e8 29 fd ff ff       	call   80103a50 <sched>

  // Tidy up.
  p->chan = 0;
80103d27:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d31:	5b                   	pop    %ebx
80103d32:	5e                   	pop    %esi
80103d33:	5f                   	pop    %edi
80103d34:	5d                   	pop    %ebp
80103d35:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	68 af 75 10 80       	push   $0x801075af
80103d3e:	e8 2d c6 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d43:	83 ec 0c             	sub    $0xc,%esp
80103d46:	68 a9 75 10 80       	push   $0x801075a9
80103d4b:	e8 20 c6 ff ff       	call   80100370 <panic>

80103d50 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	56                   	push   %esi
80103d54:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d55:	e8 66 04 00 00       	call   801041c0 <pushcli>
  c = mycpu();
80103d5a:	e8 a1 f8 ff ff       	call   80103600 <mycpu>
  p = c->proc;
80103d5f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d65:	e8 46 05 00 00       	call   801042b0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	68 20 2d 11 80       	push   $0x80112d20
80103d72:	e8 89 04 00 00       	call   80104200 <acquire>
80103d77:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103d7a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d7c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d81:	eb 10                	jmp    80103d93 <wait+0x43>
80103d83:	90                   	nop
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d88:	83 eb 80             	sub    $0xffffff80,%ebx
80103d8b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d91:	74 1d                	je     80103db0 <wait+0x60>
      if(p->parent != curproc)
80103d93:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d96:	75 f0                	jne    80103d88 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103d98:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d9c:	74 30                	je     80103dce <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d9e:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103da1:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da6:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103dac:	75 e5                	jne    80103d93 <wait+0x43>
80103dae:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103db0:	85 c0                	test   %eax,%eax
80103db2:	74 70                	je     80103e24 <wait+0xd4>
80103db4:	8b 46 24             	mov    0x24(%esi),%eax
80103db7:	85 c0                	test   %eax,%eax
80103db9:	75 69                	jne    80103e24 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103dbb:	83 ec 08             	sub    $0x8,%esp
80103dbe:	68 20 2d 11 80       	push   $0x80112d20
80103dc3:	56                   	push   %esi
80103dc4:	e8 c7 fe ff ff       	call   80103c90 <sleep>
  }
80103dc9:	83 c4 10             	add    $0x10,%esp
80103dcc:	eb ac                	jmp    80103d7a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103dd4:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103dd7:	e8 24 e4 ff ff       	call   80102200 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103ddc:	5a                   	pop    %edx
80103ddd:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103de0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103de7:	e8 14 2d 00 00       	call   80106b00 <freevm>
        p->pid = 0;
80103dec:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103df3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103dfa:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103dfe:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e05:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e13:	e8 08 05 00 00       	call   80104320 <release>
        return pid;
80103e18:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e1e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e20:	5b                   	pop    %ebx
80103e21:	5e                   	pop    %esi
80103e22:	5d                   	pop    %ebp
80103e23:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e24:	83 ec 0c             	sub    $0xc,%esp
80103e27:	68 20 2d 11 80       	push   $0x80112d20
80103e2c:	e8 ef 04 00 00       	call   80104320 <release>
      return -1;
80103e31:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e34:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e3c:	5b                   	pop    %ebx
80103e3d:	5e                   	pop    %esi
80103e3e:	5d                   	pop    %ebp
80103e3f:	c3                   	ret    

80103e40 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 10             	sub    $0x10,%esp
80103e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e4a:	68 20 2d 11 80       	push   $0x80112d20
80103e4f:	e8 ac 03 00 00       	call   80104200 <acquire>
80103e54:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e57:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e5c:	eb 0c                	jmp    80103e6a <wakeup+0x2a>
80103e5e:	66 90                	xchg   %ax,%ax
80103e60:	83 e8 80             	sub    $0xffffff80,%eax
80103e63:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e68:	74 1c                	je     80103e86 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103e6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e6e:	75 f0                	jne    80103e60 <wakeup+0x20>
80103e70:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e73:	75 eb                	jne    80103e60 <wakeup+0x20>
      p->state = RUNNABLE;
80103e75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7c:	83 e8 80             	sub    $0xffffff80,%eax
80103e7f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e84:	75 e4                	jne    80103e6a <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e86:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e90:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e91:	e9 8a 04 00 00       	jmp    80104320 <release>
80103e96:	8d 76 00             	lea    0x0(%esi),%esi
80103e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ea0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 10             	sub    $0x10,%esp
80103ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103eaa:	68 20 2d 11 80       	push   $0x80112d20
80103eaf:	e8 4c 03 00 00       	call   80104200 <acquire>
80103eb4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ebc:	eb 0c                	jmp    80103eca <kill+0x2a>
80103ebe:	66 90                	xchg   %ax,%ax
80103ec0:	83 e8 80             	sub    $0xffffff80,%eax
80103ec3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ec8:	74 3e                	je     80103f08 <kill+0x68>
    if(p->pid == pid){
80103eca:	39 58 10             	cmp    %ebx,0x10(%eax)
80103ecd:	75 f1                	jne    80103ec0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103ecf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103ed3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103eda:	74 1c                	je     80103ef8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103edc:	83 ec 0c             	sub    $0xc,%esp
80103edf:	68 20 2d 11 80       	push   $0x80112d20
80103ee4:	e8 37 04 00 00       	call   80104320 <release>
      return 0;
80103ee9:	83 c4 10             	add    $0x10,%esp
80103eec:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef1:	c9                   	leave  
80103ef2:	c3                   	ret    
80103ef3:	90                   	nop
80103ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103ef8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eff:	eb db                	jmp    80103edc <kill+0x3c>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	68 20 2d 11 80       	push   $0x80112d20
80103f10:	e8 0b 04 00 00       	call   80104320 <release>
  return -1;
80103f15:	83 c4 10             	add    $0x10,%esp
80103f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f20:	c9                   	leave  
80103f21:	c3                   	ret    
80103f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f30 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f39:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103f3e:	83 ec 3c             	sub    $0x3c,%esp
80103f41:	eb 24                	jmp    80103f67 <procdump+0x37>
80103f43:	90                   	nop
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	68 6b 7a 10 80       	push   $0x80107a6b
80103f50:	e8 0b c7 ff ff       	call   80100660 <cprintf>
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5b:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103f61:	0f 84 81 00 00 00    	je     80103fe8 <procdump+0xb8>
    if(p->state == UNUSED)
80103f67:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	74 ea                	je     80103f58 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f6e:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103f71:	ba c0 75 10 80       	mov    $0x801075c0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f76:	77 11                	ja     80103f89 <procdump+0x59>
80103f78:	8b 14 85 5c 76 10 80 	mov    -0x7fef89a4(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103f7f:	b8 c0 75 10 80       	mov    $0x801075c0,%eax
80103f84:	85 d2                	test   %edx,%edx
80103f86:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f89:	53                   	push   %ebx
80103f8a:	52                   	push   %edx
80103f8b:	ff 73 a4             	pushl  -0x5c(%ebx)
80103f8e:	68 c4 75 10 80       	push   $0x801075c4
80103f93:	e8 c8 c6 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80103f98:	83 c4 10             	add    $0x10,%esp
80103f9b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f9f:	75 a7                	jne    80103f48 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fa1:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103fa4:	83 ec 08             	sub    $0x8,%esp
80103fa7:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103faa:	50                   	push   %eax
80103fab:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103fae:	8b 40 0c             	mov    0xc(%eax),%eax
80103fb1:	83 c0 08             	add    $0x8,%eax
80103fb4:	50                   	push   %eax
80103fb5:	e8 66 01 00 00       	call   80104120 <getcallerpcs>
80103fba:	83 c4 10             	add    $0x10,%esp
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103fc0:	8b 17                	mov    (%edi),%edx
80103fc2:	85 d2                	test   %edx,%edx
80103fc4:	74 82                	je     80103f48 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103fc6:	83 ec 08             	sub    $0x8,%esp
80103fc9:	83 c7 04             	add    $0x4,%edi
80103fcc:	52                   	push   %edx
80103fcd:	68 01 70 10 80       	push   $0x80107001
80103fd2:	e8 89 c6 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103fd7:	83 c4 10             	add    $0x10,%esp
80103fda:	39 f7                	cmp    %esi,%edi
80103fdc:	75 e2                	jne    80103fc0 <procdump+0x90>
80103fde:	e9 65 ff ff ff       	jmp    80103f48 <procdump+0x18>
80103fe3:	90                   	nop
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103feb:	5b                   	pop    %ebx
80103fec:	5e                   	pop    %esi
80103fed:	5f                   	pop    %edi
80103fee:	5d                   	pop    %ebp
80103fef:	c3                   	ret    

80103ff0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103ffa:	68 74 76 10 80       	push   $0x80107674
80103fff:	8d 43 04             	lea    0x4(%ebx),%eax
80104002:	50                   	push   %eax
80104003:	e8 f8 00 00 00       	call   80104100 <initlock>
  lk->name = name;
80104008:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010400b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104011:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104014:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010401b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010401e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104021:	c9                   	leave  
80104022:	c3                   	ret    
80104023:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104030 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
80104035:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	8d 73 04             	lea    0x4(%ebx),%esi
8010403e:	56                   	push   %esi
8010403f:	e8 bc 01 00 00       	call   80104200 <acquire>
  while (lk->locked) {
80104044:	8b 13                	mov    (%ebx),%edx
80104046:	83 c4 10             	add    $0x10,%esp
80104049:	85 d2                	test   %edx,%edx
8010404b:	74 16                	je     80104063 <acquiresleep+0x33>
8010404d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104050:	83 ec 08             	sub    $0x8,%esp
80104053:	56                   	push   %esi
80104054:	53                   	push   %ebx
80104055:	e8 36 fc ff ff       	call   80103c90 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010405a:	8b 03                	mov    (%ebx),%eax
8010405c:	83 c4 10             	add    $0x10,%esp
8010405f:	85 c0                	test   %eax,%eax
80104061:	75 ed                	jne    80104050 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104063:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104069:	e8 32 f6 ff ff       	call   801036a0 <myproc>
8010406e:	8b 40 10             	mov    0x10(%eax),%eax
80104071:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104074:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104077:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010407a:	5b                   	pop    %ebx
8010407b:	5e                   	pop    %esi
8010407c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010407d:	e9 9e 02 00 00       	jmp    80104320 <release>
80104082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
80104095:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	8d 73 04             	lea    0x4(%ebx),%esi
8010409e:	56                   	push   %esi
8010409f:	e8 5c 01 00 00       	call   80104200 <acquire>
  lk->locked = 0;
801040a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801040b1:	89 1c 24             	mov    %ebx,(%esp)
801040b4:	e8 87 fd ff ff       	call   80103e40 <wakeup>
  release(&lk->lk);
801040b9:	89 75 08             	mov    %esi,0x8(%ebp)
801040bc:	83 c4 10             	add    $0x10,%esp
}
801040bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040c2:	5b                   	pop    %ebx
801040c3:	5e                   	pop    %esi
801040c4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801040c5:	e9 56 02 00 00       	jmp    80104320 <release>
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040d0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	8d 5e 04             	lea    0x4(%esi),%ebx
801040de:	53                   	push   %ebx
801040df:	e8 1c 01 00 00       	call   80104200 <acquire>
  r = lk->locked;
801040e4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801040e6:	89 1c 24             	mov    %ebx,(%esp)
801040e9:	e8 32 02 00 00       	call   80104320 <release>
  return r;
}
801040ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f1:	89 f0                	mov    %esi,%eax
801040f3:	5b                   	pop    %ebx
801040f4:	5e                   	pop    %esi
801040f5:	5d                   	pop    %ebp
801040f6:	c3                   	ret    
801040f7:	66 90                	xchg   %ax,%ax
801040f9:	66 90                	xchg   %ax,%ax
801040fb:	66 90                	xchg   %ax,%ax
801040fd:	66 90                	xchg   %ax,%ax
801040ff:	90                   	nop

80104100 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104106:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010410f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104112:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104119:	5d                   	pop    %ebp
8010411a:	c3                   	ret    
8010411b:	90                   	nop
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104120 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104124:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010412a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010412d:	31 c0                	xor    %eax,%eax
8010412f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104130:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104136:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010413c:	77 1a                	ja     80104158 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010413e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104141:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104144:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104147:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104149:	83 f8 0a             	cmp    $0xa,%eax
8010414c:	75 e2                	jne    80104130 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010414e:	5b                   	pop    %ebx
8010414f:	5d                   	pop    %ebp
80104150:	c3                   	ret    
80104151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104158:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010415f:	83 c0 01             	add    $0x1,%eax
80104162:	83 f8 0a             	cmp    $0xa,%eax
80104165:	74 e7                	je     8010414e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104167:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010416e:	83 c0 01             	add    $0x1,%eax
80104171:	83 f8 0a             	cmp    $0xa,%eax
80104174:	75 e2                	jne    80104158 <getcallerpcs+0x38>
80104176:	eb d6                	jmp    8010414e <getcallerpcs+0x2e>
80104178:	90                   	nop
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104180 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 04             	sub    $0x4,%esp
80104187:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010418a:	8b 02                	mov    (%edx),%eax
8010418c:	85 c0                	test   %eax,%eax
8010418e:	75 10                	jne    801041a0 <holding+0x20>
}
80104190:	83 c4 04             	add    $0x4,%esp
80104193:	31 c0                	xor    %eax,%eax
80104195:	5b                   	pop    %ebx
80104196:	5d                   	pop    %ebp
80104197:	c3                   	ret    
80104198:	90                   	nop
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041a0:	8b 5a 08             	mov    0x8(%edx),%ebx
801041a3:	e8 58 f4 ff ff       	call   80103600 <mycpu>
801041a8:	39 c3                	cmp    %eax,%ebx
801041aa:	0f 94 c0             	sete   %al
}
801041ad:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041b0:	0f b6 c0             	movzbl %al,%eax
}
801041b3:	5b                   	pop    %ebx
801041b4:	5d                   	pop    %ebp
801041b5:	c3                   	ret    
801041b6:	8d 76 00             	lea    0x0(%esi),%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 04             	sub    $0x4,%esp
801041c7:	9c                   	pushf  
801041c8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801041c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801041ca:	e8 31 f4 ff ff       	call   80103600 <mycpu>
801041cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041d5:	85 c0                	test   %eax,%eax
801041d7:	75 11                	jne    801041ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801041d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801041df:	e8 1c f4 ff ff       	call   80103600 <mycpu>
801041e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801041ea:	e8 11 f4 ff ff       	call   80103600 <mycpu>
801041ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801041f6:	83 c4 04             	add    $0x4,%esp
801041f9:	5b                   	pop    %ebx
801041fa:	5d                   	pop    %ebp
801041fb:	c3                   	ret    
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	56                   	push   %esi
80104204:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104205:	e8 b6 ff ff ff       	call   801041c0 <pushcli>
  if(holding(lk))
8010420a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010420d:	8b 03                	mov    (%ebx),%eax
8010420f:	85 c0                	test   %eax,%eax
80104211:	75 7d                	jne    80104290 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104213:	ba 01 00 00 00       	mov    $0x1,%edx
80104218:	eb 09                	jmp    80104223 <acquire+0x23>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104220:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104223:	89 d0                	mov    %edx,%eax
80104225:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104228:	85 c0                	test   %eax,%eax
8010422a:	75 f4                	jne    80104220 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010422c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104231:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104234:	e8 c7 f3 ff ff       	call   80103600 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104239:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010423b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010423e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104241:	31 c0                	xor    %eax,%eax
80104243:	90                   	nop
80104244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104248:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010424e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104254:	77 1a                	ja     80104270 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104256:	8b 5a 04             	mov    0x4(%edx),%ebx
80104259:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010425c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010425f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104261:	83 f8 0a             	cmp    $0xa,%eax
80104264:	75 e2                	jne    80104248 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104269:	5b                   	pop    %ebx
8010426a:	5e                   	pop    %esi
8010426b:	5d                   	pop    %ebp
8010426c:	c3                   	ret    
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104270:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104277:	83 c0 01             	add    $0x1,%eax
8010427a:	83 f8 0a             	cmp    $0xa,%eax
8010427d:	74 e7                	je     80104266 <acquire+0x66>
    pcs[i] = 0;
8010427f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104286:	83 c0 01             	add    $0x1,%eax
80104289:	83 f8 0a             	cmp    $0xa,%eax
8010428c:	75 e2                	jne    80104270 <acquire+0x70>
8010428e:	eb d6                	jmp    80104266 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104290:	8b 73 08             	mov    0x8(%ebx),%esi
80104293:	e8 68 f3 ff ff       	call   80103600 <mycpu>
80104298:	39 c6                	cmp    %eax,%esi
8010429a:	0f 85 73 ff ff ff    	jne    80104213 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801042a0:	83 ec 0c             	sub    $0xc,%esp
801042a3:	68 7f 76 10 80       	push   $0x8010767f
801042a8:	e8 c3 c0 ff ff       	call   80100370 <panic>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi

801042b0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042b6:	9c                   	pushf  
801042b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042b8:	f6 c4 02             	test   $0x2,%ah
801042bb:	75 52                	jne    8010430f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801042bd:	e8 3e f3 ff ff       	call   80103600 <mycpu>
801042c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801042c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801042cb:	85 d2                	test   %edx,%edx
801042cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801042d3:	78 2d                	js     80104302 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042d5:	e8 26 f3 ff ff       	call   80103600 <mycpu>
801042da:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801042e0:	85 d2                	test   %edx,%edx
801042e2:	74 0c                	je     801042f0 <popcli+0x40>
    sti();
}
801042e4:	c9                   	leave  
801042e5:	c3                   	ret    
801042e6:	8d 76 00             	lea    0x0(%esi),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042f0:	e8 0b f3 ff ff       	call   80103600 <mycpu>
801042f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042fb:	85 c0                	test   %eax,%eax
801042fd:	74 e5                	je     801042e4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801042ff:	fb                   	sti    
    sti();
}
80104300:	c9                   	leave  
80104301:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104302:	83 ec 0c             	sub    $0xc,%esp
80104305:	68 9e 76 10 80       	push   $0x8010769e
8010430a:	e8 61 c0 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	68 87 76 10 80       	push   $0x80107687
80104317:	e8 54 c0 ff ff       	call   80100370 <panic>
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104320 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104328:	8b 03                	mov    (%ebx),%eax
8010432a:	85 c0                	test   %eax,%eax
8010432c:	75 12                	jne    80104340 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010432e:	83 ec 0c             	sub    $0xc,%esp
80104331:	68 a5 76 10 80       	push   $0x801076a5
80104336:	e8 35 c0 ff ff       	call   80100370 <panic>
8010433b:	90                   	nop
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104340:	8b 73 08             	mov    0x8(%ebx),%esi
80104343:	e8 b8 f2 ff ff       	call   80103600 <mycpu>
80104348:	39 c6                	cmp    %eax,%esi
8010434a:	75 e2                	jne    8010432e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
8010434c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104353:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010435a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010435f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104365:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104368:	5b                   	pop    %ebx
80104369:	5e                   	pop    %esi
8010436a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010436b:	e9 40 ff ff ff       	jmp    801042b0 <popcli>

80104370 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	57                   	push   %edi
80104374:	53                   	push   %ebx
80104375:	8b 55 08             	mov    0x8(%ebp),%edx
80104378:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010437b:	f6 c2 03             	test   $0x3,%dl
8010437e:	75 05                	jne    80104385 <memset+0x15>
80104380:	f6 c1 03             	test   $0x3,%cl
80104383:	74 13                	je     80104398 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104385:	89 d7                	mov    %edx,%edi
80104387:	8b 45 0c             	mov    0xc(%ebp),%eax
8010438a:	fc                   	cld    
8010438b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010438d:	5b                   	pop    %ebx
8010438e:	89 d0                	mov    %edx,%eax
80104390:	5f                   	pop    %edi
80104391:	5d                   	pop    %ebp
80104392:	c3                   	ret    
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104398:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010439c:	c1 e9 02             	shr    $0x2,%ecx
8010439f:	89 fb                	mov    %edi,%ebx
801043a1:	89 f8                	mov    %edi,%eax
801043a3:	c1 e3 18             	shl    $0x18,%ebx
801043a6:	c1 e0 10             	shl    $0x10,%eax
801043a9:	09 d8                	or     %ebx,%eax
801043ab:	09 f8                	or     %edi,%eax
801043ad:	c1 e7 08             	shl    $0x8,%edi
801043b0:	09 f8                	or     %edi,%eax
801043b2:	89 d7                	mov    %edx,%edi
801043b4:	fc                   	cld    
801043b5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043b7:	5b                   	pop    %ebx
801043b8:	89 d0                	mov    %edx,%eax
801043ba:	5f                   	pop    %edi
801043bb:	5d                   	pop    %ebp
801043bc:	c3                   	ret    
801043bd:	8d 76 00             	lea    0x0(%esi),%esi

801043c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	56                   	push   %esi
801043c5:	8b 45 10             	mov    0x10(%ebp),%eax
801043c8:	53                   	push   %ebx
801043c9:	8b 75 0c             	mov    0xc(%ebp),%esi
801043cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043cf:	85 c0                	test   %eax,%eax
801043d1:	74 29                	je     801043fc <memcmp+0x3c>
    if(*s1 != *s2)
801043d3:	0f b6 13             	movzbl (%ebx),%edx
801043d6:	0f b6 0e             	movzbl (%esi),%ecx
801043d9:	38 d1                	cmp    %dl,%cl
801043db:	75 2b                	jne    80104408 <memcmp+0x48>
801043dd:	8d 78 ff             	lea    -0x1(%eax),%edi
801043e0:	31 c0                	xor    %eax,%eax
801043e2:	eb 14                	jmp    801043f8 <memcmp+0x38>
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801043ed:	83 c0 01             	add    $0x1,%eax
801043f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801043f4:	38 ca                	cmp    %cl,%dl
801043f6:	75 10                	jne    80104408 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043f8:	39 f8                	cmp    %edi,%eax
801043fa:	75 ec                	jne    801043e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801043fc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801043fd:	31 c0                	xor    %eax,%eax
}
801043ff:	5e                   	pop    %esi
80104400:	5f                   	pop    %edi
80104401:	5d                   	pop    %ebp
80104402:	c3                   	ret    
80104403:	90                   	nop
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104408:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010440b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010440c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010440e:	5e                   	pop    %esi
8010440f:	5f                   	pop    %edi
80104410:	5d                   	pop    %ebp
80104411:	c3                   	ret    
80104412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104420 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	8b 45 08             	mov    0x8(%ebp),%eax
80104428:	8b 75 0c             	mov    0xc(%ebp),%esi
8010442b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010442e:	39 c6                	cmp    %eax,%esi
80104430:	73 2e                	jae    80104460 <memmove+0x40>
80104432:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104435:	39 c8                	cmp    %ecx,%eax
80104437:	73 27                	jae    80104460 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104439:	85 db                	test   %ebx,%ebx
8010443b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010443e:	74 17                	je     80104457 <memmove+0x37>
      *--d = *--s;
80104440:	29 d9                	sub    %ebx,%ecx
80104442:	89 cb                	mov    %ecx,%ebx
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010444c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010444f:	83 ea 01             	sub    $0x1,%edx
80104452:	83 fa ff             	cmp    $0xffffffff,%edx
80104455:	75 f1                	jne    80104448 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104457:	5b                   	pop    %ebx
80104458:	5e                   	pop    %esi
80104459:	5d                   	pop    %ebp
8010445a:	c3                   	ret    
8010445b:	90                   	nop
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104460:	31 d2                	xor    %edx,%edx
80104462:	85 db                	test   %ebx,%ebx
80104464:	74 f1                	je     80104457 <memmove+0x37>
80104466:	8d 76 00             	lea    0x0(%esi),%esi
80104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104470:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104474:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104477:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010447a:	39 d3                	cmp    %edx,%ebx
8010447c:	75 f2                	jne    80104470 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010447e:	5b                   	pop    %ebx
8010447f:	5e                   	pop    %esi
80104480:	5d                   	pop    %ebp
80104481:	c3                   	ret    
80104482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104493:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104494:	eb 8a                	jmp    80104420 <memmove>
80104496:	8d 76 00             	lea    0x0(%esi),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044a8:	53                   	push   %ebx
801044a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801044ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801044af:	85 c9                	test   %ecx,%ecx
801044b1:	74 37                	je     801044ea <strncmp+0x4a>
801044b3:	0f b6 17             	movzbl (%edi),%edx
801044b6:	0f b6 1e             	movzbl (%esi),%ebx
801044b9:	84 d2                	test   %dl,%dl
801044bb:	74 3f                	je     801044fc <strncmp+0x5c>
801044bd:	38 d3                	cmp    %dl,%bl
801044bf:	75 3b                	jne    801044fc <strncmp+0x5c>
801044c1:	8d 47 01             	lea    0x1(%edi),%eax
801044c4:	01 cf                	add    %ecx,%edi
801044c6:	eb 1b                	jmp    801044e3 <strncmp+0x43>
801044c8:	90                   	nop
801044c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044d0:	0f b6 10             	movzbl (%eax),%edx
801044d3:	84 d2                	test   %dl,%dl
801044d5:	74 21                	je     801044f8 <strncmp+0x58>
801044d7:	0f b6 19             	movzbl (%ecx),%ebx
801044da:	83 c0 01             	add    $0x1,%eax
801044dd:	89 ce                	mov    %ecx,%esi
801044df:	38 da                	cmp    %bl,%dl
801044e1:	75 19                	jne    801044fc <strncmp+0x5c>
801044e3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801044e5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044e8:	75 e6                	jne    801044d0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801044ea:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801044eb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801044ed:	5e                   	pop    %esi
801044ee:	5f                   	pop    %edi
801044ef:	5d                   	pop    %ebp
801044f0:	c3                   	ret    
801044f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044f8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801044fc:	0f b6 c2             	movzbl %dl,%eax
801044ff:	29 d8                	sub    %ebx,%eax
}
80104501:	5b                   	pop    %ebx
80104502:	5e                   	pop    %esi
80104503:	5f                   	pop    %edi
80104504:	5d                   	pop    %ebp
80104505:	c3                   	ret    
80104506:	8d 76 00             	lea    0x0(%esi),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 45 08             	mov    0x8(%ebp),%eax
80104518:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010451b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010451e:	89 c2                	mov    %eax,%edx
80104520:	eb 19                	jmp    8010453b <strncpy+0x2b>
80104522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104528:	83 c3 01             	add    $0x1,%ebx
8010452b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010452f:	83 c2 01             	add    $0x1,%edx
80104532:	84 c9                	test   %cl,%cl
80104534:	88 4a ff             	mov    %cl,-0x1(%edx)
80104537:	74 09                	je     80104542 <strncpy+0x32>
80104539:	89 f1                	mov    %esi,%ecx
8010453b:	85 c9                	test   %ecx,%ecx
8010453d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104540:	7f e6                	jg     80104528 <strncpy+0x18>
    ;
  while(n-- > 0)
80104542:	31 c9                	xor    %ecx,%ecx
80104544:	85 f6                	test   %esi,%esi
80104546:	7e 17                	jle    8010455f <strncpy+0x4f>
80104548:	90                   	nop
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104550:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104554:	89 f3                	mov    %esi,%ebx
80104556:	83 c1 01             	add    $0x1,%ecx
80104559:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010455b:	85 db                	test   %ebx,%ebx
8010455d:	7f f1                	jg     80104550 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010455f:	5b                   	pop    %ebx
80104560:	5e                   	pop    %esi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret    
80104563:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104578:	8b 45 08             	mov    0x8(%ebp),%eax
8010457b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010457e:	85 c9                	test   %ecx,%ecx
80104580:	7e 26                	jle    801045a8 <safestrcpy+0x38>
80104582:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104586:	89 c1                	mov    %eax,%ecx
80104588:	eb 17                	jmp    801045a1 <safestrcpy+0x31>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104590:	83 c2 01             	add    $0x1,%edx
80104593:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104597:	83 c1 01             	add    $0x1,%ecx
8010459a:	84 db                	test   %bl,%bl
8010459c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010459f:	74 04                	je     801045a5 <safestrcpy+0x35>
801045a1:	39 f2                	cmp    %esi,%edx
801045a3:	75 eb                	jne    80104590 <safestrcpy+0x20>
    ;
  *s = 0;
801045a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801045a8:	5b                   	pop    %ebx
801045a9:	5e                   	pop    %esi
801045aa:	5d                   	pop    %ebp
801045ab:	c3                   	ret    
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <strlen>:

int
strlen(const char *s)
{
801045b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045b1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801045b3:	89 e5                	mov    %esp,%ebp
801045b5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801045b8:	80 3a 00             	cmpb   $0x0,(%edx)
801045bb:	74 0c                	je     801045c9 <strlen+0x19>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
801045c0:	83 c0 01             	add    $0x1,%eax
801045c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045c7:	75 f7                	jne    801045c0 <strlen+0x10>
    ;
  return n;
}
801045c9:	5d                   	pop    %ebp
801045ca:	c3                   	ret    

801045cb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801045d3:	55                   	push   %ebp
  pushl %ebx
801045d4:	53                   	push   %ebx
  pushl %esi
801045d5:	56                   	push   %esi
  pushl %edi
801045d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045d9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801045db:	5f                   	pop    %edi
  popl %esi
801045dc:	5e                   	pop    %esi
  popl %ebx
801045dd:	5b                   	pop    %ebx
  popl %ebp
801045de:	5d                   	pop    %ebp
  ret
801045df:	c3                   	ret    

801045e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
//  struct proc *curproc = myproc();

 //  if(addr >= curproc->sz || addr+4 > curproc->sz)
 //  return -1;

  *ip = *(int*)(addr);
801045e3:	8b 45 08             	mov    0x8(%ebp),%eax
801045e6:	8b 10                	mov    (%eax),%edx
801045e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801045eb:	89 10                	mov    %edx,(%eax)
  return 0;
}
801045ed:	31 c0                	xor    %eax,%eax
801045ef:	5d                   	pop    %ebp
801045f0:	c3                   	ret    
801045f1:	eb 0d                	jmp    80104600 <fetchstr>
801045f3:	90                   	nop
801045f4:	90                   	nop
801045f5:	90                   	nop
801045f6:	90                   	nop
801045f7:	90                   	nop
801045f8:	90                   	nop
801045f9:	90                   	nop
801045fa:	90                   	nop
801045fb:	90                   	nop
801045fc:	90                   	nop
801045fd:	90                   	nop
801045fe:	90                   	nop
801045ff:	90                   	nop

80104600 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	8b 55 08             	mov    0x8(%ebp),%edx
//  struct proc *curproc = myproc();

//  if(addr >= curproc->sz)
//    return -1;

  *pp = (char*)addr;
80104606:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104609:	89 11                	mov    %edx,(%ecx)
//  ep = (char*)curproc->sz;
  s = *pp; 
  while(*s != 0){
8010460b:	80 3a 00             	cmpb   $0x0,(%edx)
//  struct proc *curproc = myproc();

//  if(addr >= curproc->sz)
//    return -1;

  *pp = (char*)addr;
8010460e:	89 d0                	mov    %edx,%eax
//  ep = (char*)curproc->sz;
  s = *pp; 
  while(*s != 0){
80104610:	74 0e                	je     80104620 <fetchstr+0x20>
80104612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
80104618:	83 c0 01             	add    $0x1,%eax
//    return -1;

  *pp = (char*)addr;
//  ep = (char*)curproc->sz;
  s = *pp; 
  while(*s != 0){
8010461b:	80 38 00             	cmpb   $0x0,(%eax)
8010461e:	75 f8                	jne    80104618 <fetchstr+0x18>
    s++;
  }
  return (s - *pp) -1;
80104620:	29 d0                	sub    %edx,%eax
80104622:	83 e8 01             	sub    $0x1,%eax
}
80104625:	5d                   	pop    %ebp
80104626:	c3                   	ret    
80104627:	89 f6                	mov    %esi,%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104636:	e8 65 f0 ff ff       	call   801036a0 <myproc>
8010463b:	8b 40 18             	mov    0x18(%eax),%eax
//  struct proc *curproc = myproc();

 //  if(addr >= curproc->sz || addr+4 > curproc->sz)
 //  return -1;

  *ip = *(int*)(addr);
8010463e:	8b 55 08             	mov    0x8(%ebp),%edx
80104641:	8b 40 44             	mov    0x44(%eax),%eax
80104644:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104648:	8b 45 0c             	mov    0xc(%ebp),%eax
8010464b:	89 10                	mov    %edx,(%eax)
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
8010464d:	31 c0                	xor    %eax,%eax
8010464f:	c9                   	leave  
80104650:	c3                   	ret    
80104651:	eb 0d                	jmp    80104660 <argptr>
80104653:	90                   	nop
80104654:	90                   	nop
80104655:	90                   	nop
80104656:	90                   	nop
80104657:	90                   	nop
80104658:	90                   	nop
80104659:	90                   	nop
8010465a:	90                   	nop
8010465b:	90                   	nop
8010465c:	90                   	nop
8010465d:	90                   	nop
8010465e:	90                   	nop
8010465f:	90                   	nop

80104660 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 08             	sub    $0x8,%esp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104666:	e8 35 f0 ff ff       	call   801036a0 <myproc>
8010466b:	8b 40 18             	mov    0x18(%eax),%eax
    return -1;
  //if(size < 0 || (uint)i >= (STACKBASE - ((curproc->pages)*PGSIZE)) ||
  //        (uint)i+size > (STACKBASE - ((curproc->pages)*PGSIZE)) )
  //  return -1;

  *pp = (char*)i;
8010466e:	8b 55 08             	mov    0x8(%ebp),%edx
//  struct proc *curproc = myproc();

 //  if(addr >= curproc->sz || addr+4 > curproc->sz)
 //  return -1;

  *ip = *(int*)(addr);
80104671:	8b 40 44             	mov    0x44(%eax),%eax
    return -1;
  //if(size < 0 || (uint)i >= (STACKBASE - ((curproc->pages)*PGSIZE)) ||
  //        (uint)i+size > (STACKBASE - ((curproc->pages)*PGSIZE)) )
  //  return -1;

  *pp = (char*)i;
80104674:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104678:	8b 45 0c             	mov    0xc(%ebp),%eax
8010467b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010467d:	31 c0                	xor    %eax,%eax
8010467f:	c9                   	leave  
80104680:	c3                   	ret    
80104681:	eb 0d                	jmp    80104690 <argstr>
80104683:	90                   	nop
80104684:	90                   	nop
80104685:	90                   	nop
80104686:	90                   	nop
80104687:	90                   	nop
80104688:	90                   	nop
80104689:	90                   	nop
8010468a:	90                   	nop
8010468b:	90                   	nop
8010468c:	90                   	nop
8010468d:	90                   	nop
8010468e:	90                   	nop
8010468f:	90                   	nop

80104690 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	83 ec 08             	sub    $0x8,%esp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104696:	e8 05 f0 ff ff       	call   801036a0 <myproc>
8010469b:	8b 40 18             	mov    0x18(%eax),%eax
//  struct proc *curproc = myproc();

 //  if(addr >= curproc->sz || addr+4 > curproc->sz)
 //  return -1;

  *ip = *(int*)(addr);
8010469e:	8b 55 08             	mov    0x8(%ebp),%edx
//  struct proc *curproc = myproc();

//  if(addr >= curproc->sz)
//    return -1;

  *pp = (char*)addr;
801046a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
//  struct proc *curproc = myproc();

 //  if(addr >= curproc->sz || addr+4 > curproc->sz)
 //  return -1;

  *ip = *(int*)(addr);
801046a4:	8b 40 44             	mov    0x44(%eax),%eax
801046a7:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
//  struct proc *curproc = myproc();

//  if(addr >= curproc->sz)
//    return -1;

  *pp = (char*)addr;
801046ab:	89 11                	mov    %edx,(%ecx)
//  ep = (char*)curproc->sz;
  s = *pp; 
  while(*s != 0){
801046ad:	80 3a 00             	cmpb   $0x0,(%edx)
//  struct proc *curproc = myproc();

//  if(addr >= curproc->sz)
//    return -1;

  *pp = (char*)addr;
801046b0:	89 d0                	mov    %edx,%eax
//  ep = (char*)curproc->sz;
  s = *pp; 
  while(*s != 0){
801046b2:	74 0c                	je     801046c0 <argstr+0x30>
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s++;
801046b8:	83 c0 01             	add    $0x1,%eax
//    return -1;

  *pp = (char*)addr;
//  ep = (char*)curproc->sz;
  s = *pp; 
  while(*s != 0){
801046bb:	80 38 00             	cmpb   $0x0,(%eax)
801046be:	75 f8                	jne    801046b8 <argstr+0x28>
{
  int addr;
  argint(n, &addr); 
//  if(argint(n, &addr) < 0)
//    return -1;
  return fetchstr(addr, pp);
801046c0:	29 d0                	sub    %edx,%eax
}
801046c2:	c9                   	leave  
{
  int addr;
  argint(n, &addr); 
//  if(argint(n, &addr) < 0)
//    return -1;
  return fetchstr(addr, pp);
801046c3:	83 e8 01             	sub    $0x1,%eax
}
801046c6:	c3                   	ret    
801046c7:	89 f6                	mov    %esi,%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801046d5:	e8 c6 ef ff ff       	call   801036a0 <myproc>

  num = curproc->tf->eax;
801046da:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801046dd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801046df:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801046e2:	8d 50 ff             	lea    -0x1(%eax),%edx
801046e5:	83 fa 16             	cmp    $0x16,%edx
801046e8:	77 1e                	ja     80104708 <syscall+0x38>
801046ea:	8b 14 85 e0 76 10 80 	mov    -0x7fef8920(,%eax,4),%edx
801046f1:	85 d2                	test   %edx,%edx
801046f3:	74 13                	je     80104708 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801046f5:	ff d2                	call   *%edx
801046f7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801046fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046fd:	5b                   	pop    %ebx
801046fe:	5e                   	pop    %esi
801046ff:	5d                   	pop    %ebp
80104700:	c3                   	ret    
80104701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104708:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104709:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010470c:	50                   	push   %eax
8010470d:	ff 73 10             	pushl  0x10(%ebx)
80104710:	68 ad 76 10 80       	push   $0x801076ad
80104715:	e8 46 bf ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010471a:	8b 43 18             	mov    0x18(%ebx),%eax
8010471d:	83 c4 10             	add    $0x10,%esp
80104720:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104727:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010472a:	5b                   	pop    %ebx
8010472b:	5e                   	pop    %esi
8010472c:	5d                   	pop    %ebp
8010472d:	c3                   	ret    
8010472e:	66 90                	xchg   %ax,%ax

80104730 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104736:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104739:	83 ec 44             	sub    $0x44,%esp
8010473c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010473f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104742:	56                   	push   %esi
80104743:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104744:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104747:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010474a:	e8 b1 d6 ff ff       	call   80101e00 <nameiparent>
8010474f:	83 c4 10             	add    $0x10,%esp
80104752:	85 c0                	test   %eax,%eax
80104754:	0f 84 f6 00 00 00    	je     80104850 <create+0x120>
    return 0;
  ilock(dp);
8010475a:	83 ec 0c             	sub    $0xc,%esp
8010475d:	89 c7                	mov    %eax,%edi
8010475f:	50                   	push   %eax
80104760:	e8 2b ce ff ff       	call   80101590 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104765:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104768:	83 c4 0c             	add    $0xc,%esp
8010476b:	50                   	push   %eax
8010476c:	56                   	push   %esi
8010476d:	57                   	push   %edi
8010476e:	e8 4d d3 ff ff       	call   80101ac0 <dirlookup>
80104773:	83 c4 10             	add    $0x10,%esp
80104776:	85 c0                	test   %eax,%eax
80104778:	89 c3                	mov    %eax,%ebx
8010477a:	74 54                	je     801047d0 <create+0xa0>
    iunlockput(dp);
8010477c:	83 ec 0c             	sub    $0xc,%esp
8010477f:	57                   	push   %edi
80104780:	e8 9b d0 ff ff       	call   80101820 <iunlockput>
    ilock(ip);
80104785:	89 1c 24             	mov    %ebx,(%esp)
80104788:	e8 03 ce ff ff       	call   80101590 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010478d:	83 c4 10             	add    $0x10,%esp
80104790:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104795:	75 19                	jne    801047b0 <create+0x80>
80104797:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010479c:	89 d8                	mov    %ebx,%eax
8010479e:	75 10                	jne    801047b0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801047a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047a3:	5b                   	pop    %ebx
801047a4:	5e                   	pop    %esi
801047a5:	5f                   	pop    %edi
801047a6:	5d                   	pop    %ebp
801047a7:	c3                   	ret    
801047a8:	90                   	nop
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801047b0:	83 ec 0c             	sub    $0xc,%esp
801047b3:	53                   	push   %ebx
801047b4:	e8 67 d0 ff ff       	call   80101820 <iunlockput>
    return 0;
801047b9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801047bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801047bf:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801047c1:	5b                   	pop    %ebx
801047c2:	5e                   	pop    %esi
801047c3:	5f                   	pop    %edi
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
801047c6:	8d 76 00             	lea    0x0(%esi),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801047d0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047d4:	83 ec 08             	sub    $0x8,%esp
801047d7:	50                   	push   %eax
801047d8:	ff 37                	pushl  (%edi)
801047da:	e8 41 cc ff ff       	call   80101420 <ialloc>
801047df:	83 c4 10             	add    $0x10,%esp
801047e2:	85 c0                	test   %eax,%eax
801047e4:	89 c3                	mov    %eax,%ebx
801047e6:	0f 84 cc 00 00 00    	je     801048b8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	50                   	push   %eax
801047f0:	e8 9b cd ff ff       	call   80101590 <ilock>
  ip->major = major;
801047f5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047f9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801047fd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104801:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104805:	b8 01 00 00 00       	mov    $0x1,%eax
8010480a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010480e:	89 1c 24             	mov    %ebx,(%esp)
80104811:	e8 ca cc ff ff       	call   801014e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010481e:	74 40                	je     80104860 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104820:	83 ec 04             	sub    $0x4,%esp
80104823:	ff 73 04             	pushl  0x4(%ebx)
80104826:	56                   	push   %esi
80104827:	57                   	push   %edi
80104828:	e8 f3 d4 ff ff       	call   80101d20 <dirlink>
8010482d:	83 c4 10             	add    $0x10,%esp
80104830:	85 c0                	test   %eax,%eax
80104832:	78 77                	js     801048ab <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104834:	83 ec 0c             	sub    $0xc,%esp
80104837:	57                   	push   %edi
80104838:	e8 e3 cf ff ff       	call   80101820 <iunlockput>

  return ip;
8010483d:	83 c4 10             	add    $0x10,%esp
}
80104840:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104843:	89 d8                	mov    %ebx,%eax
}
80104845:	5b                   	pop    %ebx
80104846:	5e                   	pop    %esi
80104847:	5f                   	pop    %edi
80104848:	5d                   	pop    %ebp
80104849:	c3                   	ret    
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104850:	31 c0                	xor    %eax,%eax
80104852:	e9 49 ff ff ff       	jmp    801047a0 <create+0x70>
80104857:	89 f6                	mov    %esi,%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104860:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104865:	83 ec 0c             	sub    $0xc,%esp
80104868:	57                   	push   %edi
80104869:	e8 72 cc ff ff       	call   801014e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010486e:	83 c4 0c             	add    $0xc,%esp
80104871:	ff 73 04             	pushl  0x4(%ebx)
80104874:	68 5c 77 10 80       	push   $0x8010775c
80104879:	53                   	push   %ebx
8010487a:	e8 a1 d4 ff ff       	call   80101d20 <dirlink>
8010487f:	83 c4 10             	add    $0x10,%esp
80104882:	85 c0                	test   %eax,%eax
80104884:	78 18                	js     8010489e <create+0x16e>
80104886:	83 ec 04             	sub    $0x4,%esp
80104889:	ff 77 04             	pushl  0x4(%edi)
8010488c:	68 5b 77 10 80       	push   $0x8010775b
80104891:	53                   	push   %ebx
80104892:	e8 89 d4 ff ff       	call   80101d20 <dirlink>
80104897:	83 c4 10             	add    $0x10,%esp
8010489a:	85 c0                	test   %eax,%eax
8010489c:	79 82                	jns    80104820 <create+0xf0>
      panic("create dots");
8010489e:	83 ec 0c             	sub    $0xc,%esp
801048a1:	68 4f 77 10 80       	push   $0x8010774f
801048a6:	e8 c5 ba ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801048ab:	83 ec 0c             	sub    $0xc,%esp
801048ae:	68 5e 77 10 80       	push   $0x8010775e
801048b3:	e8 b8 ba ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	68 40 77 10 80       	push   $0x80107740
801048c0:	e8 ab ba ff ff       	call   80100370 <panic>
801048c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
801048d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801048d8:	31 db                	xor    %ebx,%ebx
  return -1;
}

int
sys_dup(void)
{
801048da:	83 ec 18             	sub    $0x18,%esp
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
801048dd:	50                   	push   %eax
801048de:	6a 00                	push   $0x0
801048e0:	e8 4b fd ff ff       	call   80104630 <argint>
  f=myproc()->ofile[fd];
801048e5:	e8 b6 ed ff ff       	call   801036a0 <myproc>
801048ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048ed:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801048f1:	e8 aa ed ff ff       	call   801036a0 <myproc>
801048f6:	83 c4 10             	add    $0x10,%esp
801048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104900:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104904:	85 d2                	test   %edx,%edx
80104906:	74 18                	je     80104920 <sys_dup+0x50>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104908:	83 c3 01             	add    $0x1,%ebx
8010490b:	83 fb 10             	cmp    $0x10,%ebx
8010490e:	75 f0                	jne    80104900 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104910:	8d 65 f8             	lea    -0x8(%ebp),%esp
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
80104913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  filedup(f);
  return fd;
}
80104918:	5b                   	pop    %ebx
80104919:	5e                   	pop    %esi
8010491a:	5d                   	pop    %ebp
8010491b:	c3                   	ret    
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104920:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104923:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104927:	56                   	push   %esi
80104928:	e8 d3 c3 ff ff       	call   80100d00 <filedup>
  return fd;
8010492d:	83 c4 10             	add    $0x10,%esp
}
80104930:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104933:	89 d8                	mov    %ebx,%eax
}
80104935:	5b                   	pop    %ebx
80104936:	5e                   	pop    %esi
80104937:	5d                   	pop    %ebp
80104938:	c3                   	ret    
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104940 <sys_read>:

int
sys_read(void)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
80104945:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  return fd;
}

int
sys_read(void)
{
80104948:	83 ec 18             	sub    $0x18,%esp
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
8010494b:	53                   	push   %ebx
8010494c:	6a 00                	push   $0x0
8010494e:	e8 dd fc ff ff       	call   80104630 <argint>
  f=myproc()->ofile[fd];
80104953:	e8 48 ed ff ff       	call   801036a0 <myproc>
80104958:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010495b:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010495f:	58                   	pop    %eax
80104960:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104963:	5a                   	pop    %edx
80104964:	50                   	push   %eax
80104965:	6a 02                	push   $0x2
80104967:	e8 c4 fc ff ff       	call   80104630 <argint>
8010496c:	83 c4 10             	add    $0x10,%esp
8010496f:	85 c0                	test   %eax,%eax
80104971:	78 35                	js     801049a8 <sys_read+0x68>
80104973:	83 ec 04             	sub    $0x4,%esp
80104976:	ff 75 f0             	pushl  -0x10(%ebp)
80104979:	53                   	push   %ebx
8010497a:	6a 01                	push   $0x1
8010497c:	e8 df fc ff ff       	call   80104660 <argptr>
80104981:	83 c4 10             	add    $0x10,%esp
80104984:	85 c0                	test   %eax,%eax
80104986:	78 20                	js     801049a8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104988:	83 ec 04             	sub    $0x4,%esp
8010498b:	ff 75 f0             	pushl  -0x10(%ebp)
8010498e:	ff 75 f4             	pushl  -0xc(%ebp)
80104991:	56                   	push   %esi
80104992:	e8 d9 c4 ff ff       	call   80100e70 <fileread>
80104997:	83 c4 10             	add    $0x10,%esp
}
8010499a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010499d:	5b                   	pop    %ebx
8010499e:	5e                   	pop    %esi
8010499f:	5d                   	pop    %ebp
801049a0:	c3                   	ret    
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801049a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ad:	eb eb                	jmp    8010499a <sys_read+0x5a>
801049af:	90                   	nop

801049b0 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
801049b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  return fileread(f, p, n);
}

int
sys_write(void)
{
801049b8:	83 ec 18             	sub    $0x18,%esp
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
801049bb:	53                   	push   %ebx
801049bc:	6a 00                	push   $0x0
801049be:	e8 6d fc ff ff       	call   80104630 <argint>
  f=myproc()->ofile[fd];
801049c3:	e8 d8 ec ff ff       	call   801036a0 <myproc>
801049c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049cb:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049cf:	58                   	pop    %eax
801049d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049d3:	5a                   	pop    %edx
801049d4:	50                   	push   %eax
801049d5:	6a 02                	push   $0x2
801049d7:	e8 54 fc ff ff       	call   80104630 <argint>
801049dc:	83 c4 10             	add    $0x10,%esp
801049df:	85 c0                	test   %eax,%eax
801049e1:	78 35                	js     80104a18 <sys_write+0x68>
801049e3:	83 ec 04             	sub    $0x4,%esp
801049e6:	ff 75 f0             	pushl  -0x10(%ebp)
801049e9:	53                   	push   %ebx
801049ea:	6a 01                	push   $0x1
801049ec:	e8 6f fc ff ff       	call   80104660 <argptr>
801049f1:	83 c4 10             	add    $0x10,%esp
801049f4:	85 c0                	test   %eax,%eax
801049f6:	78 20                	js     80104a18 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
801049f8:	83 ec 04             	sub    $0x4,%esp
801049fb:	ff 75 f0             	pushl  -0x10(%ebp)
801049fe:	ff 75 f4             	pushl  -0xc(%ebp)
80104a01:	56                   	push   %esi
80104a02:	e8 f9 c4 ff ff       	call   80100f00 <filewrite>
80104a07:	83 c4 10             	add    $0x10,%esp
}
80104a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a0d:	5b                   	pop    %ebx
80104a0e:	5e                   	pop    %esi
80104a0f:	5d                   	pop    %ebp
80104a10:	c3                   	ret    
80104a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a1d:	eb eb                	jmp    80104a0a <sys_write+0x5a>
80104a1f:	90                   	nop

80104a20 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
80104a25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return filewrite(f, p, n);
}

int
sys_close(void)
{
80104a28:	83 ec 18             	sub    $0x18,%esp
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
80104a2b:	50                   	push   %eax
80104a2c:	6a 00                	push   $0x0
80104a2e:	e8 fd fb ff ff       	call   80104630 <argint>
  f=myproc()->ofile[fd];
80104a33:	e8 68 ec ff ff       	call   801036a0 <myproc>
80104a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a3b:	8d 5a 08             	lea    0x8(%edx),%ebx
80104a3e:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104a42:	e8 59 ec ff ff       	call   801036a0 <myproc>
80104a47:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104a4e:	00 
  fileclose(f);
80104a4f:	89 34 24             	mov    %esi,(%esp)
80104a52:	e8 f9 c2 ff ff       	call   80100d50 <fileclose>
  return 0;
}
80104a57:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a5a:	31 c0                	xor    %eax,%eax
80104a5c:	5b                   	pop    %ebx
80104a5d:	5e                   	pop    %esi
80104a5e:	5d                   	pop    %ebp
80104a5f:	c3                   	ret    

80104a60 <sys_fstat>:

int
sys_fstat(void)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
80104a65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  return 0;
}

int
sys_fstat(void)
{
80104a68:	83 ec 18             	sub    $0x18,%esp
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
80104a6b:	53                   	push   %ebx
80104a6c:	6a 00                	push   $0x0
80104a6e:	e8 bd fb ff ff       	call   80104630 <argint>
  f=myproc()->ofile[fd];
80104a73:	e8 28 ec ff ff       	call   801036a0 <myproc>
80104a78:	8b 55 f4             	mov    -0xc(%ebp),%edx
sys_fstat(void)
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a7b:	83 c4 0c             	add    $0xc,%esp
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;
  argint(n, &fd);
  f=myproc()->ofile[fd];
80104a7e:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a82:	6a 14                	push   $0x14
80104a84:	53                   	push   %ebx
80104a85:	6a 01                	push   $0x1
80104a87:	e8 d4 fb ff ff       	call   80104660 <argptr>
80104a8c:	83 c4 10             	add    $0x10,%esp
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	78 1d                	js     80104ab0 <sys_fstat+0x50>
    return -1;
  return filestat(f, st);
80104a93:	83 ec 08             	sub    $0x8,%esp
80104a96:	ff 75 f4             	pushl  -0xc(%ebp)
80104a99:	56                   	push   %esi
80104a9a:	e8 81 c3 ff ff       	call   80100e20 <filestat>
80104a9f:	83 c4 10             	add    $0x10,%esp
}
80104aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ab5:	eb eb                	jmp    80104aa2 <sys_fstat+0x42>
80104ab7:	89 f6                	mov    %esi,%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ac6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ac9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104acc:	50                   	push   %eax
80104acd:	6a 00                	push   $0x0
80104acf:	e8 bc fb ff ff       	call   80104690 <argstr>
80104ad4:	83 c4 10             	add    $0x10,%esp
80104ad7:	85 c0                	test   %eax,%eax
80104ad9:	0f 88 fb 00 00 00    	js     80104bda <sys_link+0x11a>
80104adf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ae2:	83 ec 08             	sub    $0x8,%esp
80104ae5:	50                   	push   %eax
80104ae6:	6a 01                	push   $0x1
80104ae8:	e8 a3 fb ff ff       	call   80104690 <argstr>
80104aed:	83 c4 10             	add    $0x10,%esp
80104af0:	85 c0                	test   %eax,%eax
80104af2:	0f 88 e2 00 00 00    	js     80104bda <sys_link+0x11a>
    return -1;

  begin_op();
80104af8:	e8 73 df ff ff       	call   80102a70 <begin_op>
  if((ip = namei(old)) == 0){
80104afd:	83 ec 0c             	sub    $0xc,%esp
80104b00:	ff 75 d4             	pushl  -0x2c(%ebp)
80104b03:	e8 d8 d2 ff ff       	call   80101de0 <namei>
80104b08:	83 c4 10             	add    $0x10,%esp
80104b0b:	85 c0                	test   %eax,%eax
80104b0d:	89 c3                	mov    %eax,%ebx
80104b0f:	0f 84 f3 00 00 00    	je     80104c08 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	50                   	push   %eax
80104b19:	e8 72 ca ff ff       	call   80101590 <ilock>
  if(ip->type == T_DIR){
80104b1e:	83 c4 10             	add    $0x10,%esp
80104b21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b26:	0f 84 c4 00 00 00    	je     80104bf0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104b2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b31:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104b34:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104b37:	53                   	push   %ebx
80104b38:	e8 a3 c9 ff ff       	call   801014e0 <iupdate>
  iunlock(ip);
80104b3d:	89 1c 24             	mov    %ebx,(%esp)
80104b40:	e8 2b cb ff ff       	call   80101670 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104b45:	58                   	pop    %eax
80104b46:	5a                   	pop    %edx
80104b47:	57                   	push   %edi
80104b48:	ff 75 d0             	pushl  -0x30(%ebp)
80104b4b:	e8 b0 d2 ff ff       	call   80101e00 <nameiparent>
80104b50:	83 c4 10             	add    $0x10,%esp
80104b53:	85 c0                	test   %eax,%eax
80104b55:	89 c6                	mov    %eax,%esi
80104b57:	74 5b                	je     80104bb4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104b59:	83 ec 0c             	sub    $0xc,%esp
80104b5c:	50                   	push   %eax
80104b5d:	e8 2e ca ff ff       	call   80101590 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b62:	83 c4 10             	add    $0x10,%esp
80104b65:	8b 03                	mov    (%ebx),%eax
80104b67:	39 06                	cmp    %eax,(%esi)
80104b69:	75 3d                	jne    80104ba8 <sys_link+0xe8>
80104b6b:	83 ec 04             	sub    $0x4,%esp
80104b6e:	ff 73 04             	pushl  0x4(%ebx)
80104b71:	57                   	push   %edi
80104b72:	56                   	push   %esi
80104b73:	e8 a8 d1 ff ff       	call   80101d20 <dirlink>
80104b78:	83 c4 10             	add    $0x10,%esp
80104b7b:	85 c0                	test   %eax,%eax
80104b7d:	78 29                	js     80104ba8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	56                   	push   %esi
80104b83:	e8 98 cc ff ff       	call   80101820 <iunlockput>
  iput(ip);
80104b88:	89 1c 24             	mov    %ebx,(%esp)
80104b8b:	e8 30 cb ff ff       	call   801016c0 <iput>

  end_op();
80104b90:	e8 4b df ff ff       	call   80102ae0 <end_op>

  return 0;
80104b95:	83 c4 10             	add    $0x10,%esp
80104b98:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b9d:	5b                   	pop    %ebx
80104b9e:	5e                   	pop    %esi
80104b9f:	5f                   	pop    %edi
80104ba0:	5d                   	pop    %ebp
80104ba1:	c3                   	ret    
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104ba8:	83 ec 0c             	sub    $0xc,%esp
80104bab:	56                   	push   %esi
80104bac:	e8 6f cc ff ff       	call   80101820 <iunlockput>
    goto bad;
80104bb1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	53                   	push   %ebx
80104bb8:	e8 d3 c9 ff ff       	call   80101590 <ilock>
  ip->nlink--;
80104bbd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104bc2:	89 1c 24             	mov    %ebx,(%esp)
80104bc5:	e8 16 c9 ff ff       	call   801014e0 <iupdate>
  iunlockput(ip);
80104bca:	89 1c 24             	mov    %ebx,(%esp)
80104bcd:	e8 4e cc ff ff       	call   80101820 <iunlockput>
  end_op();
80104bd2:	e8 09 df ff ff       	call   80102ae0 <end_op>
  return -1;
80104bd7:	83 c4 10             	add    $0x10,%esp
}
80104bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5f                   	pop    %edi
80104be5:	5d                   	pop    %ebp
80104be6:	c3                   	ret    
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104bf0:	83 ec 0c             	sub    $0xc,%esp
80104bf3:	53                   	push   %ebx
80104bf4:	e8 27 cc ff ff       	call   80101820 <iunlockput>
    end_op();
80104bf9:	e8 e2 de ff ff       	call   80102ae0 <end_op>
    return -1;
80104bfe:	83 c4 10             	add    $0x10,%esp
80104c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c06:	eb 92                	jmp    80104b9a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104c08:	e8 d3 de ff ff       	call   80102ae0 <end_op>
    return -1;
80104c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c12:	eb 86                	jmp    80104b9a <sys_link+0xda>
80104c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c20 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
80104c25:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104c26:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104c29:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104c2c:	50                   	push   %eax
80104c2d:	6a 00                	push   $0x0
80104c2f:	e8 5c fa ff ff       	call   80104690 <argstr>
80104c34:	83 c4 10             	add    $0x10,%esp
80104c37:	85 c0                	test   %eax,%eax
80104c39:	0f 88 82 01 00 00    	js     80104dc1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104c3f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104c42:	e8 29 de ff ff       	call   80102a70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104c47:	83 ec 08             	sub    $0x8,%esp
80104c4a:	53                   	push   %ebx
80104c4b:	ff 75 c0             	pushl  -0x40(%ebp)
80104c4e:	e8 ad d1 ff ff       	call   80101e00 <nameiparent>
80104c53:	83 c4 10             	add    $0x10,%esp
80104c56:	85 c0                	test   %eax,%eax
80104c58:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c5b:	0f 84 6a 01 00 00    	je     80104dcb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104c61:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104c64:	83 ec 0c             	sub    $0xc,%esp
80104c67:	56                   	push   %esi
80104c68:	e8 23 c9 ff ff       	call   80101590 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c6d:	58                   	pop    %eax
80104c6e:	5a                   	pop    %edx
80104c6f:	68 5c 77 10 80       	push   $0x8010775c
80104c74:	53                   	push   %ebx
80104c75:	e8 26 ce ff ff       	call   80101aa0 <namecmp>
80104c7a:	83 c4 10             	add    $0x10,%esp
80104c7d:	85 c0                	test   %eax,%eax
80104c7f:	0f 84 fc 00 00 00    	je     80104d81 <sys_unlink+0x161>
80104c85:	83 ec 08             	sub    $0x8,%esp
80104c88:	68 5b 77 10 80       	push   $0x8010775b
80104c8d:	53                   	push   %ebx
80104c8e:	e8 0d ce ff ff       	call   80101aa0 <namecmp>
80104c93:	83 c4 10             	add    $0x10,%esp
80104c96:	85 c0                	test   %eax,%eax
80104c98:	0f 84 e3 00 00 00    	je     80104d81 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104c9e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ca1:	83 ec 04             	sub    $0x4,%esp
80104ca4:	50                   	push   %eax
80104ca5:	53                   	push   %ebx
80104ca6:	56                   	push   %esi
80104ca7:	e8 14 ce ff ff       	call   80101ac0 <dirlookup>
80104cac:	83 c4 10             	add    $0x10,%esp
80104caf:	85 c0                	test   %eax,%eax
80104cb1:	89 c3                	mov    %eax,%ebx
80104cb3:	0f 84 c8 00 00 00    	je     80104d81 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104cb9:	83 ec 0c             	sub    $0xc,%esp
80104cbc:	50                   	push   %eax
80104cbd:	e8 ce c8 ff ff       	call   80101590 <ilock>

  if(ip->nlink < 1)
80104cc2:	83 c4 10             	add    $0x10,%esp
80104cc5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104cca:	0f 8e 24 01 00 00    	jle    80104df4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cd5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104cd8:	74 66                	je     80104d40 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104cda:	83 ec 04             	sub    $0x4,%esp
80104cdd:	6a 10                	push   $0x10
80104cdf:	6a 00                	push   $0x0
80104ce1:	56                   	push   %esi
80104ce2:	e8 89 f6 ff ff       	call   80104370 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ce7:	6a 10                	push   $0x10
80104ce9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104cec:	56                   	push   %esi
80104ced:	ff 75 b4             	pushl  -0x4c(%ebp)
80104cf0:	e8 7b cc ff ff       	call   80101970 <writei>
80104cf5:	83 c4 20             	add    $0x20,%esp
80104cf8:	83 f8 10             	cmp    $0x10,%eax
80104cfb:	0f 85 e6 00 00 00    	jne    80104de7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104d01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d06:	0f 84 9c 00 00 00    	je     80104da8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104d12:	e8 09 cb ff ff       	call   80101820 <iunlockput>

  ip->nlink--;
80104d17:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d1c:	89 1c 24             	mov    %ebx,(%esp)
80104d1f:	e8 bc c7 ff ff       	call   801014e0 <iupdate>
  iunlockput(ip);
80104d24:	89 1c 24             	mov    %ebx,(%esp)
80104d27:	e8 f4 ca ff ff       	call   80101820 <iunlockput>

  end_op();
80104d2c:	e8 af dd ff ff       	call   80102ae0 <end_op>

  return 0;
80104d31:	83 c4 10             	add    $0x10,%esp
80104d34:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d39:	5b                   	pop    %ebx
80104d3a:	5e                   	pop    %esi
80104d3b:	5f                   	pop    %edi
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret    
80104d3e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104d40:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d44:	76 94                	jbe    80104cda <sys_unlink+0xba>
80104d46:	bf 20 00 00 00       	mov    $0x20,%edi
80104d4b:	eb 0f                	jmp    80104d5c <sys_unlink+0x13c>
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
80104d50:	83 c7 10             	add    $0x10,%edi
80104d53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104d56:	0f 83 7e ff ff ff    	jae    80104cda <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d5c:	6a 10                	push   $0x10
80104d5e:	57                   	push   %edi
80104d5f:	56                   	push   %esi
80104d60:	53                   	push   %ebx
80104d61:	e8 0a cb ff ff       	call   80101870 <readi>
80104d66:	83 c4 10             	add    $0x10,%esp
80104d69:	83 f8 10             	cmp    $0x10,%eax
80104d6c:	75 6c                	jne    80104dda <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104d6e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d73:	74 db                	je     80104d50 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104d75:	83 ec 0c             	sub    $0xc,%esp
80104d78:	53                   	push   %ebx
80104d79:	e8 a2 ca ff ff       	call   80101820 <iunlockput>
    goto bad;
80104d7e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104d81:	83 ec 0c             	sub    $0xc,%esp
80104d84:	ff 75 b4             	pushl  -0x4c(%ebp)
80104d87:	e8 94 ca ff ff       	call   80101820 <iunlockput>
  end_op();
80104d8c:	e8 4f dd ff ff       	call   80102ae0 <end_op>
  return -1;
80104d91:	83 c4 10             	add    $0x10,%esp
}
80104d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104d97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d9c:	5b                   	pop    %ebx
80104d9d:	5e                   	pop    %esi
80104d9e:	5f                   	pop    %edi
80104d9f:	5d                   	pop    %ebp
80104da0:	c3                   	ret    
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104da8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104dab:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104dae:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104db3:	50                   	push   %eax
80104db4:	e8 27 c7 ff ff       	call   801014e0 <iupdate>
80104db9:	83 c4 10             	add    $0x10,%esp
80104dbc:	e9 4b ff ff ff       	jmp    80104d0c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc6:	e9 6b ff ff ff       	jmp    80104d36 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104dcb:	e8 10 dd ff ff       	call   80102ae0 <end_op>
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd5:	e9 5c ff ff ff       	jmp    80104d36 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104dda:	83 ec 0c             	sub    $0xc,%esp
80104ddd:	68 80 77 10 80       	push   $0x80107780
80104de2:	e8 89 b5 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104de7:	83 ec 0c             	sub    $0xc,%esp
80104dea:	68 92 77 10 80       	push   $0x80107792
80104def:	e8 7c b5 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104df4:	83 ec 0c             	sub    $0xc,%esp
80104df7:	68 6e 77 10 80       	push   $0x8010776e
80104dfc:	e8 6f b5 ff ff       	call   80100370 <panic>
80104e01:	eb 0d                	jmp    80104e10 <sys_open>
80104e03:	90                   	nop
80104e04:	90                   	nop
80104e05:	90                   	nop
80104e06:	90                   	nop
80104e07:	90                   	nop
80104e08:	90                   	nop
80104e09:	90                   	nop
80104e0a:	90                   	nop
80104e0b:	90                   	nop
80104e0c:	90                   	nop
80104e0d:	90                   	nop
80104e0e:	90                   	nop
80104e0f:	90                   	nop

80104e10 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e16:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80104e19:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e1c:	50                   	push   %eax
80104e1d:	6a 00                	push   $0x0
80104e1f:	e8 6c f8 ff ff       	call   80104690 <argstr>
80104e24:	83 c4 10             	add    $0x10,%esp
80104e27:	85 c0                	test   %eax,%eax
80104e29:	0f 88 9e 00 00 00    	js     80104ecd <sys_open+0xbd>
80104e2f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e32:	83 ec 08             	sub    $0x8,%esp
80104e35:	50                   	push   %eax
80104e36:	6a 01                	push   $0x1
80104e38:	e8 f3 f7 ff ff       	call   80104630 <argint>
80104e3d:	83 c4 10             	add    $0x10,%esp
80104e40:	85 c0                	test   %eax,%eax
80104e42:	0f 88 85 00 00 00    	js     80104ecd <sys_open+0xbd>
    return -1;

  begin_op();
80104e48:	e8 23 dc ff ff       	call   80102a70 <begin_op>

  if(omode & O_CREATE){
80104e4d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e51:	0f 85 89 00 00 00    	jne    80104ee0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104e57:	83 ec 0c             	sub    $0xc,%esp
80104e5a:	ff 75 e0             	pushl  -0x20(%ebp)
80104e5d:	e8 7e cf ff ff       	call   80101de0 <namei>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	85 c0                	test   %eax,%eax
80104e67:	89 c6                	mov    %eax,%esi
80104e69:	0f 84 8e 00 00 00    	je     80104efd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80104e6f:	83 ec 0c             	sub    $0xc,%esp
80104e72:	50                   	push   %eax
80104e73:	e8 18 c7 ff ff       	call   80101590 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e78:	83 c4 10             	add    $0x10,%esp
80104e7b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e80:	0f 84 d2 00 00 00    	je     80104f58 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e86:	e8 05 be ff ff       	call   80100c90 <filealloc>
80104e8b:	85 c0                	test   %eax,%eax
80104e8d:	89 c7                	mov    %eax,%edi
80104e8f:	74 2b                	je     80104ebc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104e91:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104e93:	e8 08 e8 ff ff       	call   801036a0 <myproc>
80104e98:	90                   	nop
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104ea0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ea4:	85 d2                	test   %edx,%edx
80104ea6:	74 68                	je     80104f10 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104ea8:	83 c3 01             	add    $0x1,%ebx
80104eab:	83 fb 10             	cmp    $0x10,%ebx
80104eae:	75 f0                	jne    80104ea0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
80104eb3:	57                   	push   %edi
80104eb4:	e8 97 be ff ff       	call   80100d50 <fileclose>
80104eb9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	56                   	push   %esi
80104ec0:	e8 5b c9 ff ff       	call   80101820 <iunlockput>
    end_op();
80104ec5:	e8 16 dc ff ff       	call   80102ae0 <end_op>
    return -1;
80104eca:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5f                   	pop    %edi
80104ed8:	5d                   	pop    %ebp
80104ed9:	c3                   	ret    
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
80104ee3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ee6:	31 c9                	xor    %ecx,%ecx
80104ee8:	6a 00                	push   $0x0
80104eea:	ba 02 00 00 00       	mov    $0x2,%edx
80104eef:	e8 3c f8 ff ff       	call   80104730 <create>
    if(ip == 0){
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104ef9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104efb:	75 89                	jne    80104e86 <sys_open+0x76>
      end_op();
80104efd:	e8 de db ff ff       	call   80102ae0 <end_op>
      return -1;
80104f02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f07:	eb 43                	jmp    80104f4c <sys_open+0x13c>
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f10:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104f13:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f17:	56                   	push   %esi
80104f18:	e8 53 c7 ff ff       	call   80101670 <iunlock>
  end_op();
80104f1d:	e8 be db ff ff       	call   80102ae0 <end_op>

  f->type = FD_INODE;
80104f22:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f2b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104f2e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80104f31:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80104f38:	89 d0                	mov    %edx,%eax
80104f3a:	83 e0 01             	and    $0x1,%eax
80104f3d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f40:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f43:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f46:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80104f4a:	89 d8                	mov    %ebx,%eax
}
80104f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f4f:	5b                   	pop    %ebx
80104f50:	5e                   	pop    %esi
80104f51:	5f                   	pop    %edi
80104f52:	5d                   	pop    %ebp
80104f53:	c3                   	ret    
80104f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f58:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104f5b:	85 c9                	test   %ecx,%ecx
80104f5d:	0f 84 23 ff ff ff    	je     80104e86 <sys_open+0x76>
80104f63:	e9 54 ff ff ff       	jmp    80104ebc <sys_open+0xac>
80104f68:	90                   	nop
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f70 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104f76:	e8 f5 da ff ff       	call   80102a70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7e:	83 ec 08             	sub    $0x8,%esp
80104f81:	50                   	push   %eax
80104f82:	6a 00                	push   $0x0
80104f84:	e8 07 f7 ff ff       	call   80104690 <argstr>
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	85 c0                	test   %eax,%eax
80104f8e:	78 30                	js     80104fc0 <sys_mkdir+0x50>
80104f90:	83 ec 0c             	sub    $0xc,%esp
80104f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f96:	31 c9                	xor    %ecx,%ecx
80104f98:	6a 00                	push   $0x0
80104f9a:	ba 01 00 00 00       	mov    $0x1,%edx
80104f9f:	e8 8c f7 ff ff       	call   80104730 <create>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	74 15                	je     80104fc0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fab:	83 ec 0c             	sub    $0xc,%esp
80104fae:	50                   	push   %eax
80104faf:	e8 6c c8 ff ff       	call   80101820 <iunlockput>
  end_op();
80104fb4:	e8 27 db ff ff       	call   80102ae0 <end_op>
  return 0;
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	31 c0                	xor    %eax,%eax
}
80104fbe:	c9                   	leave  
80104fbf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80104fc0:	e8 1b db ff ff       	call   80102ae0 <end_op>
    return -1;
80104fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104fca:	c9                   	leave  
80104fcb:	c3                   	ret    
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <sys_mknod>:

int
sys_mknod(void)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104fd6:	e8 95 da ff ff       	call   80102a70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104fdb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104fde:	83 ec 08             	sub    $0x8,%esp
80104fe1:	50                   	push   %eax
80104fe2:	6a 00                	push   $0x0
80104fe4:	e8 a7 f6 ff ff       	call   80104690 <argstr>
80104fe9:	83 c4 10             	add    $0x10,%esp
80104fec:	85 c0                	test   %eax,%eax
80104fee:	78 60                	js     80105050 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104ff0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ff3:	83 ec 08             	sub    $0x8,%esp
80104ff6:	50                   	push   %eax
80104ff7:	6a 01                	push   $0x1
80104ff9:	e8 32 f6 ff ff       	call   80104630 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104ffe:	83 c4 10             	add    $0x10,%esp
80105001:	85 c0                	test   %eax,%eax
80105003:	78 4b                	js     80105050 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105005:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105008:	83 ec 08             	sub    $0x8,%esp
8010500b:	50                   	push   %eax
8010500c:	6a 02                	push   $0x2
8010500e:	e8 1d f6 ff ff       	call   80104630 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 36                	js     80105050 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010501a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010501e:	83 ec 0c             	sub    $0xc,%esp
80105021:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105025:	ba 03 00 00 00       	mov    $0x3,%edx
8010502a:	50                   	push   %eax
8010502b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010502e:	e8 fd f6 ff ff       	call   80104730 <create>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	74 16                	je     80105050 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010503a:	83 ec 0c             	sub    $0xc,%esp
8010503d:	50                   	push   %eax
8010503e:	e8 dd c7 ff ff       	call   80101820 <iunlockput>
  end_op();
80105043:	e8 98 da ff ff       	call   80102ae0 <end_op>
  return 0;
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	31 c0                	xor    %eax,%eax
}
8010504d:	c9                   	leave  
8010504e:	c3                   	ret    
8010504f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105050:	e8 8b da ff ff       	call   80102ae0 <end_op>
    return -1;
80105055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010505a:	c9                   	leave  
8010505b:	c3                   	ret    
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105060 <sys_chdir>:

int
sys_chdir(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
80105065:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105068:	e8 33 e6 ff ff       	call   801036a0 <myproc>
8010506d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010506f:	e8 fc d9 ff ff       	call   80102a70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105074:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105077:	83 ec 08             	sub    $0x8,%esp
8010507a:	50                   	push   %eax
8010507b:	6a 00                	push   $0x0
8010507d:	e8 0e f6 ff ff       	call   80104690 <argstr>
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	85 c0                	test   %eax,%eax
80105087:	78 77                	js     80105100 <sys_chdir+0xa0>
80105089:	83 ec 0c             	sub    $0xc,%esp
8010508c:	ff 75 f4             	pushl  -0xc(%ebp)
8010508f:	e8 4c cd ff ff       	call   80101de0 <namei>
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	85 c0                	test   %eax,%eax
80105099:	89 c3                	mov    %eax,%ebx
8010509b:	74 63                	je     80105100 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010509d:	83 ec 0c             	sub    $0xc,%esp
801050a0:	50                   	push   %eax
801050a1:	e8 ea c4 ff ff       	call   80101590 <ilock>
  if(ip->type != T_DIR){
801050a6:	83 c4 10             	add    $0x10,%esp
801050a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050ae:	75 30                	jne    801050e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	53                   	push   %ebx
801050b4:	e8 b7 c5 ff ff       	call   80101670 <iunlock>
  iput(curproc->cwd);
801050b9:	58                   	pop    %eax
801050ba:	ff 76 68             	pushl  0x68(%esi)
801050bd:	e8 fe c5 ff ff       	call   801016c0 <iput>
  end_op();
801050c2:	e8 19 da ff ff       	call   80102ae0 <end_op>
  curproc->cwd = ip;
801050c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801050ca:	83 c4 10             	add    $0x10,%esp
801050cd:	31 c0                	xor    %eax,%eax
}
801050cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050d2:	5b                   	pop    %ebx
801050d3:	5e                   	pop    %esi
801050d4:	5d                   	pop    %ebp
801050d5:	c3                   	ret    
801050d6:	8d 76 00             	lea    0x0(%esi),%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	53                   	push   %ebx
801050e4:	e8 37 c7 ff ff       	call   80101820 <iunlockput>
    end_op();
801050e9:	e8 f2 d9 ff ff       	call   80102ae0 <end_op>
    return -1;
801050ee:	83 c4 10             	add    $0x10,%esp
801050f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f6:	eb d7                	jmp    801050cf <sys_chdir+0x6f>
801050f8:	90                   	nop
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105100:	e8 db d9 ff ff       	call   80102ae0 <end_op>
    return -1;
80105105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510a:	eb c3                	jmp    801050cf <sys_chdir+0x6f>
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
80105115:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105116:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010511c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105122:	50                   	push   %eax
80105123:	6a 00                	push   $0x0
80105125:	e8 66 f5 ff ff       	call   80104690 <argstr>
8010512a:	83 c4 10             	add    $0x10,%esp
8010512d:	85 c0                	test   %eax,%eax
8010512f:	78 7f                	js     801051b0 <sys_exec+0xa0>
80105131:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105137:	83 ec 08             	sub    $0x8,%esp
8010513a:	50                   	push   %eax
8010513b:	6a 01                	push   $0x1
8010513d:	e8 ee f4 ff ff       	call   80104630 <argint>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	85 c0                	test   %eax,%eax
80105147:	78 67                	js     801051b0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105149:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010514f:	83 ec 04             	sub    $0x4,%esp
80105152:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105158:	68 80 00 00 00       	push   $0x80
8010515d:	6a 00                	push   $0x0
8010515f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105165:	50                   	push   %eax
80105166:	31 db                	xor    %ebx,%ebx
80105168:	e8 03 f2 ff ff       	call   80104370 <memset>
8010516d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105170:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105176:	83 ec 08             	sub    $0x8,%esp
80105179:	57                   	push   %edi
8010517a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010517d:	50                   	push   %eax
8010517e:	e8 5d f4 ff ff       	call   801045e0 <fetchint>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	78 26                	js     801051b0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010518a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105190:	85 c0                	test   %eax,%eax
80105192:	74 2c                	je     801051c0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105194:	83 ec 08             	sub    $0x8,%esp
80105197:	56                   	push   %esi
80105198:	50                   	push   %eax
80105199:	e8 62 f4 ff ff       	call   80104600 <fetchstr>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	85 c0                	test   %eax,%eax
801051a3:	78 0b                	js     801051b0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801051a5:	83 c3 01             	add    $0x1,%ebx
801051a8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801051ab:	83 fb 20             	cmp    $0x20,%ebx
801051ae:	75 c0                	jne    80105170 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801051b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801051b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801051b8:	5b                   	pop    %ebx
801051b9:	5e                   	pop    %esi
801051ba:	5f                   	pop    %edi
801051bb:	5d                   	pop    %ebp
801051bc:	c3                   	ret    
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801051c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801051c6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801051c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801051d0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801051d4:	50                   	push   %eax
801051d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801051db:	e8 10 b8 ff ff       	call   801009f0 <exec>
801051e0:	83 c4 10             	add    $0x10,%esp
}
801051e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051e6:	5b                   	pop    %ebx
801051e7:	5e                   	pop    %esi
801051e8:	5f                   	pop    %edi
801051e9:	5d                   	pop    %ebp
801051ea:	c3                   	ret    
801051eb:	90                   	nop
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051f0 <sys_pipe>:

int
sys_pipe(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
801051f5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801051f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801051f9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801051fc:	6a 08                	push   $0x8
801051fe:	50                   	push   %eax
801051ff:	6a 00                	push   $0x0
80105201:	e8 5a f4 ff ff       	call   80104660 <argptr>
80105206:	83 c4 10             	add    $0x10,%esp
80105209:	85 c0                	test   %eax,%eax
8010520b:	78 4a                	js     80105257 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010520d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105210:	83 ec 08             	sub    $0x8,%esp
80105213:	50                   	push   %eax
80105214:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105217:	50                   	push   %eax
80105218:	e8 f3 de ff ff       	call   80103110 <pipealloc>
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	85 c0                	test   %eax,%eax
80105222:	78 33                	js     80105257 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105224:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105226:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105229:	e8 72 e4 ff ff       	call   801036a0 <myproc>
8010522e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105230:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105234:	85 f6                	test   %esi,%esi
80105236:	74 30                	je     80105268 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105238:	83 c3 01             	add    $0x1,%ebx
8010523b:	83 fb 10             	cmp    $0x10,%ebx
8010523e:	75 f0                	jne    80105230 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105240:	83 ec 0c             	sub    $0xc,%esp
80105243:	ff 75 e0             	pushl  -0x20(%ebp)
80105246:	e8 05 bb ff ff       	call   80100d50 <fileclose>
    fileclose(wf);
8010524b:	58                   	pop    %eax
8010524c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010524f:	e8 fc ba ff ff       	call   80100d50 <fileclose>
    return -1;
80105254:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105257:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010525a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010525f:	5b                   	pop    %ebx
80105260:	5e                   	pop    %esi
80105261:	5f                   	pop    %edi
80105262:	5d                   	pop    %ebp
80105263:	c3                   	ret    
80105264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105268:	8d 73 08             	lea    0x8(%ebx),%esi
8010526b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010526f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105272:	e8 29 e4 ff ff       	call   801036a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105277:	31 d2                	xor    %edx,%edx
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105280:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105284:	85 c9                	test   %ecx,%ecx
80105286:	74 18                	je     801052a0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105288:	83 c2 01             	add    $0x1,%edx
8010528b:	83 fa 10             	cmp    $0x10,%edx
8010528e:	75 f0                	jne    80105280 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105290:	e8 0b e4 ff ff       	call   801036a0 <myproc>
80105295:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010529c:	00 
8010529d:	eb a1                	jmp    80105240 <sys_pipe+0x50>
8010529f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801052a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801052a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801052a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801052a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801052ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801052af:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801052b2:	31 c0                	xor    %eax,%eax
}
801052b4:	5b                   	pop    %ebx
801052b5:	5e                   	pop    %esi
801052b6:	5f                   	pop    %edi
801052b7:	5d                   	pop    %ebp
801052b8:	c3                   	ret    
801052b9:	66 90                	xchg   %ax,%ax
801052bb:	66 90                	xchg   %ax,%ax
801052bd:	66 90                	xchg   %ax,%ax
801052bf:	90                   	nop

801052c0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801052c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052c9:	50                   	push   %eax
801052ca:	6a 00                	push   $0x0
801052cc:	e8 5f f3 ff ff       	call   80104630 <argint>
801052d1:	83 c4 10             	add    $0x10,%esp
801052d4:	85 c0                	test   %eax,%eax
801052d6:	78 30                	js     80105308 <sys_shm_open+0x48>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801052d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052db:	83 ec 04             	sub    $0x4,%esp
801052de:	6a 04                	push   $0x4
801052e0:	50                   	push   %eax
801052e1:	6a 01                	push   $0x1
801052e3:	e8 78 f3 ff ff       	call   80104660 <argptr>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	78 19                	js     80105308 <sys_shm_open+0x48>
    return -1;
  return shm_open(id, pointer);
801052ef:	83 ec 08             	sub    $0x8,%esp
801052f2:	ff 75 f4             	pushl  -0xc(%ebp)
801052f5:	ff 75 f0             	pushl  -0x10(%ebp)
801052f8:	e8 93 1c 00 00       	call   80106f90 <shm_open>
801052fd:	83 c4 10             	add    $0x10,%esp
}
80105300:	c9                   	leave  
80105301:	c3                   	ret    
80105302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
8010530d:	c9                   	leave  
8010530e:	c3                   	ret    
8010530f:	90                   	nop

80105310 <sys_shm_close>:

int sys_shm_close(void) {
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
80105316:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105319:	50                   	push   %eax
8010531a:	6a 00                	push   $0x0
8010531c:	e8 0f f3 ff ff       	call   80104630 <argint>
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	85 c0                	test   %eax,%eax
80105326:	78 18                	js     80105340 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	ff 75 f4             	pushl  -0xc(%ebp)
8010532e:	e8 6d 1c 00 00       	call   80106fa0 <shm_close>
80105333:	83 c4 10             	add    $0x10,%esp
}
80105336:	c9                   	leave  
80105337:	c3                   	ret    
80105338:	90                   	nop
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
80105345:	c9                   	leave  
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <sys_fork>:

int
sys_fork(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105353:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105354:	e9 27 e5 ff ff       	jmp    80103880 <fork>
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_exit>:
}

int
sys_exit(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 08             	sub    $0x8,%esp
  exit();
80105366:	e8 a5 e7 ff ff       	call   80103b10 <exit>
  return 0;  // not reached
}
8010536b:	31 c0                	xor    %eax,%eax
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    
8010536f:	90                   	nop

80105370 <sys_wait>:

int
sys_wait(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105373:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105374:	e9 d7 e9 ff ff       	jmp    80103d50 <wait>
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_kill>:
}

int
sys_kill(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105386:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105389:	50                   	push   %eax
8010538a:	6a 00                	push   $0x0
8010538c:	e8 9f f2 ff ff       	call   80104630 <argint>
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	85 c0                	test   %eax,%eax
80105396:	78 18                	js     801053b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	ff 75 f4             	pushl  -0xc(%ebp)
8010539e:	e8 fd ea ff ff       	call   80103ea0 <kill>
801053a3:	83 c4 10             	add    $0x10,%esp
}
801053a6:	c9                   	leave  
801053a7:	c3                   	ret    
801053a8:	90                   	nop
801053a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_getpid>:

int
sys_getpid(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801053c6:	e8 d5 e2 ff ff       	call   801036a0 <myproc>
801053cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801053ce:	c9                   	leave  
801053cf:	c3                   	ret    

801053d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801053d7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053da:	50                   	push   %eax
801053db:	6a 00                	push   $0x0
801053dd:	e8 4e f2 ff ff       	call   80104630 <argint>
801053e2:	83 c4 10             	add    $0x10,%esp
801053e5:	85 c0                	test   %eax,%eax
801053e7:	78 27                	js     80105410 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801053e9:	e8 b2 e2 ff ff       	call   801036a0 <myproc>
  if(growproc(n) < 0)
801053ee:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801053f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801053f3:	ff 75 f4             	pushl  -0xc(%ebp)
801053f6:	e8 05 e4 ff ff       	call   80103800 <growproc>
801053fb:	83 c4 10             	add    $0x10,%esp
801053fe:	85 c0                	test   %eax,%eax
80105400:	78 0e                	js     80105410 <sys_sbrk+0x40>
    return -1;
  return addr;
80105402:	89 d8                	mov    %ebx,%eax
}
80105404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105407:	c9                   	leave  
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105415:	eb ed                	jmp    80105404 <sys_sbrk+0x34>
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105424:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105427:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010542a:	50                   	push   %eax
8010542b:	6a 00                	push   $0x0
8010542d:	e8 fe f1 ff ff       	call   80104630 <argint>
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	85 c0                	test   %eax,%eax
80105437:	0f 88 8a 00 00 00    	js     801054c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010543d:	83 ec 0c             	sub    $0xc,%esp
80105440:	68 60 4d 11 80       	push   $0x80114d60
80105445:	e8 b6 ed ff ff       	call   80104200 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010544a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010544d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105450:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105456:	85 d2                	test   %edx,%edx
80105458:	75 27                	jne    80105481 <sys_sleep+0x61>
8010545a:	eb 54                	jmp    801054b0 <sys_sleep+0x90>
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105460:	83 ec 08             	sub    $0x8,%esp
80105463:	68 60 4d 11 80       	push   $0x80114d60
80105468:	68 a0 55 11 80       	push   $0x801155a0
8010546d:	e8 1e e8 ff ff       	call   80103c90 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105472:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105477:	83 c4 10             	add    $0x10,%esp
8010547a:	29 d8                	sub    %ebx,%eax
8010547c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010547f:	73 2f                	jae    801054b0 <sys_sleep+0x90>
    if(myproc()->killed){
80105481:	e8 1a e2 ff ff       	call   801036a0 <myproc>
80105486:	8b 40 24             	mov    0x24(%eax),%eax
80105489:	85 c0                	test   %eax,%eax
8010548b:	74 d3                	je     80105460 <sys_sleep+0x40>
      release(&tickslock);
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	68 60 4d 11 80       	push   $0x80114d60
80105495:	e8 86 ee ff ff       	call   80104320 <release>
      return -1;
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801054a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	68 60 4d 11 80       	push   $0x80114d60
801054b8:	e8 63 ee ff ff       	call   80104320 <release>
  return 0;
801054bd:	83 c4 10             	add    $0x10,%esp
801054c0:	31 c0                	xor    %eax,%eax
}
801054c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054c5:	c9                   	leave  
801054c6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801054c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cc:	eb d4                	jmp    801054a2 <sys_sleep+0x82>
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	53                   	push   %ebx
801054d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801054d7:	68 60 4d 11 80       	push   $0x80114d60
801054dc:	e8 1f ed ff ff       	call   80104200 <acquire>
  xticks = ticks;
801054e1:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801054e7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801054ee:	e8 2d ee ff ff       	call   80104320 <release>
  return xticks;
}
801054f3:	89 d8                	mov    %ebx,%eax
801054f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054f8:	c9                   	leave  
801054f9:	c3                   	ret    

801054fa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801054fa:	1e                   	push   %ds
  pushl %es
801054fb:	06                   	push   %es
  pushl %fs
801054fc:	0f a0                	push   %fs
  pushl %gs
801054fe:	0f a8                	push   %gs
  pushal
80105500:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105501:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105505:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105507:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105509:	54                   	push   %esp
  call trap
8010550a:	e8 e1 00 00 00       	call   801055f0 <trap>
  addl $4, %esp
8010550f:	83 c4 04             	add    $0x4,%esp

80105512 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105512:	61                   	popa   
  popl %gs
80105513:	0f a9                	pop    %gs
  popl %fs
80105515:	0f a1                	pop    %fs
  popl %es
80105517:	07                   	pop    %es
  popl %ds
80105518:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105519:	83 c4 08             	add    $0x8,%esp
  iret
8010551c:	cf                   	iret   
8010551d:	66 90                	xchg   %ax,%ax
8010551f:	90                   	nop

80105520 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105520:	31 c0                	xor    %eax,%eax
80105522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105528:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010552f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105534:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
8010553b:	00 
8010553c:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
80105543:	80 
80105544:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010554b:	8e 
8010554c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105553:	80 
80105554:	c1 ea 10             	shr    $0x10,%edx
80105557:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010555e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010555f:	83 c0 01             	add    $0x1,%eax
80105562:	3d 00 01 00 00       	cmp    $0x100,%eax
80105567:	75 bf                	jne    80105528 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105569:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010556a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010556f:	89 e5                	mov    %esp,%ebp
80105571:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105574:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105579:	68 a1 77 10 80       	push   $0x801077a1
8010557e:	68 60 4d 11 80       	push   $0x80114d60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105583:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010558a:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
80105591:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105597:	c1 e8 10             	shr    $0x10,%eax
8010559a:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
801055a1:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6

  initlock(&tickslock, "time");
801055a7:	e8 54 eb ff ff       	call   80104100 <initlock>
}
801055ac:	83 c4 10             	add    $0x10,%esp
801055af:	c9                   	leave  
801055b0:	c3                   	ret    
801055b1:	eb 0d                	jmp    801055c0 <idtinit>
801055b3:	90                   	nop
801055b4:	90                   	nop
801055b5:	90                   	nop
801055b6:	90                   	nop
801055b7:	90                   	nop
801055b8:	90                   	nop
801055b9:	90                   	nop
801055ba:	90                   	nop
801055bb:	90                   	nop
801055bc:	90                   	nop
801055bd:	90                   	nop
801055be:	90                   	nop
801055bf:	90                   	nop

801055c0 <idtinit>:

void
idtinit(void)
{
801055c0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801055c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801055c6:	89 e5                	mov    %esp,%ebp
801055c8:	83 ec 10             	sub    $0x10,%esp
801055cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801055cf:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801055d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801055d8:	c1 e8 10             	shr    $0x10,%eax
801055db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801055df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801055e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	57                   	push   %edi
801055f4:	56                   	push   %esi
801055f5:	53                   	push   %ebx
801055f6:	83 ec 1c             	sub    $0x1c,%esp
801055f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801055fc:	8b 47 30             	mov    0x30(%edi),%eax
801055ff:	83 f8 40             	cmp    $0x40,%eax
80105602:	0f 84 d8 01 00 00    	je     801057e0 <trap+0x1f0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105608:	83 e8 0e             	sub    $0xe,%eax
8010560b:	83 f8 31             	cmp    $0x31,%eax
8010560e:	77 10                	ja     80105620 <trap+0x30>
80105610:	ff 24 85 ec 78 10 80 	jmp    *-0x7fef8714(,%eax,4)
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    break;
  }

//PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105620:	e8 7b e0 ff ff       	call   801036a0 <myproc>
80105625:	85 c0                	test   %eax,%eax
80105627:	0f 84 57 02 00 00    	je     80105884 <trap+0x294>
8010562d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105631:	0f 84 4d 02 00 00    	je     80105884 <trap+0x294>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105637:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010563a:	8b 57 38             	mov    0x38(%edi),%edx
8010563d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105640:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105643:	e8 38 e0 ff ff       	call   80103680 <cpuid>
80105648:	8b 77 34             	mov    0x34(%edi),%esi
8010564b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010564e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105651:	e8 4a e0 ff ff       	call   801036a0 <myproc>
80105656:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105659:	e8 42 e0 ff ff       	call   801036a0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010565e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105661:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105664:	51                   	push   %ecx
80105665:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105666:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105669:	ff 75 e4             	pushl  -0x1c(%ebp)
8010566c:	56                   	push   %esi
8010566d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010566e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105671:	52                   	push   %edx
80105672:	ff 70 10             	pushl  0x10(%eax)
80105675:	68 a8 78 10 80       	push   $0x801078a8
8010567a:	e8 e1 af ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010567f:	83 c4 20             	add    $0x20,%esp
80105682:	e8 19 e0 ff ff       	call   801036a0 <myproc>
80105687:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010568e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105690:	e8 0b e0 ff ff       	call   801036a0 <myproc>
80105695:	85 c0                	test   %eax,%eax
80105697:	74 0c                	je     801056a5 <trap+0xb5>
80105699:	e8 02 e0 ff ff       	call   801036a0 <myproc>
8010569e:	8b 50 24             	mov    0x24(%eax),%edx
801056a1:	85 d2                	test   %edx,%edx
801056a3:	75 4b                	jne    801056f0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801056a5:	e8 f6 df ff ff       	call   801036a0 <myproc>
801056aa:	85 c0                	test   %eax,%eax
801056ac:	74 0b                	je     801056b9 <trap+0xc9>
801056ae:	e8 ed df ff ff       	call   801036a0 <myproc>
801056b3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801056b7:	74 4f                	je     80105708 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056b9:	e8 e2 df ff ff       	call   801036a0 <myproc>
801056be:	85 c0                	test   %eax,%eax
801056c0:	74 1d                	je     801056df <trap+0xef>
801056c2:	e8 d9 df ff ff       	call   801036a0 <myproc>
801056c7:	8b 40 24             	mov    0x24(%eax),%eax
801056ca:	85 c0                	test   %eax,%eax
801056cc:	74 11                	je     801056df <trap+0xef>
801056ce:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801056d2:	83 e0 03             	and    $0x3,%eax
801056d5:	66 83 f8 03          	cmp    $0x3,%ax
801056d9:	0f 84 2a 01 00 00    	je     80105809 <trap+0x219>
    exit();
}
801056df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e2:	5b                   	pop    %ebx
801056e3:	5e                   	pop    %esi
801056e4:	5f                   	pop    %edi
801056e5:	5d                   	pop    %ebp
801056e6:	c3                   	ret    
801056e7:	89 f6                	mov    %esi,%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056f0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801056f4:	83 e0 03             	and    $0x3,%eax
801056f7:	66 83 f8 03          	cmp    $0x3,%ax
801056fb:	75 a8                	jne    801056a5 <trap+0xb5>
    exit();
801056fd:	e8 0e e4 ff ff       	call   80103b10 <exit>
80105702:	eb a1                	jmp    801056a5 <trap+0xb5>
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105708:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010570c:	75 ab                	jne    801056b9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010570e:	e8 2d e5 ff ff       	call   80103c40 <yield>
80105713:	eb a4                	jmp    801056b9 <trap+0xc9>
80105715:	8d 76 00             	lea    0x0(%esi),%esi
80105718:	0f 20 d3             	mov    %cr2,%ebx
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  case T_PGFLT: {
    uint num = rcr2();
    struct proc* p = myproc();
8010571b:	e8 80 df ff ff       	call   801036a0 <myproc>
    if(allocuvm(p->pgdir, PGROUNDDOWN(num), num) == 0){
80105720:	83 ec 04             	sub    $0x4,%esp
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  case T_PGFLT: {
    uint num = rcr2();
    struct proc* p = myproc();
80105723:	89 c6                	mov    %eax,%esi
    if(allocuvm(p->pgdir, PGROUNDDOWN(num), num) == 0){
80105725:	53                   	push   %ebx
80105726:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010572c:	53                   	push   %ebx
8010572d:	ff 70 04             	pushl  0x4(%eax)
80105730:	e8 9b 12 00 00       	call   801069d0 <allocuvm>
80105735:	83 c4 10             	add    $0x10,%esp
80105738:	85 c0                	test   %eax,%eax
8010573a:	0f 85 d8 00 00 00    	jne    80105818 <trap+0x228>
        cprintf("case T_PGFLT from trap.c: allocuvm failed. Number of current allocated pages: %d\n", p->pages);
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	ff 76 7c             	pushl  0x7c(%esi)
80105746:	68 d0 77 10 80       	push   $0x801077d0
8010574b:	e8 10 af ff ff       	call   80100660 <cprintf>
        exit();
80105750:	e8 bb e3 ff ff       	call   80103b10 <exit>
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	e9 33 ff ff ff       	jmp    80105690 <trap+0xa0>
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105760:	e8 1b df ff ff       	call   80103680 <cpuid>
80105765:	85 c0                	test   %eax,%eax
80105767:	0f 84 e3 00 00 00    	je     80105850 <trap+0x260>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
8010576d:	e8 be ce ff ff       	call   80102630 <lapiceoi>
    break;
80105772:	e9 19 ff ff ff       	jmp    80105690 <trap+0xa0>
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105780:	e8 6b cd ff ff       	call   801024f0 <kbdintr>
    lapiceoi();
80105785:	e8 a6 ce ff ff       	call   80102630 <lapiceoi>
    break;
8010578a:	e9 01 ff ff ff       	jmp    80105690 <trap+0xa0>
8010578f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105790:	e8 8b 02 00 00       	call   80105a20 <uartintr>
    lapiceoi();
80105795:	e8 96 ce ff ff       	call   80102630 <lapiceoi>
    break;
8010579a:	e9 f1 fe ff ff       	jmp    80105690 <trap+0xa0>
8010579f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801057a0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801057a4:	8b 77 38             	mov    0x38(%edi),%esi
801057a7:	e8 d4 de ff ff       	call   80103680 <cpuid>
801057ac:	56                   	push   %esi
801057ad:	53                   	push   %ebx
801057ae:	50                   	push   %eax
801057af:	68 ac 77 10 80       	push   $0x801077ac
801057b4:	e8 a7 ae ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801057b9:	e8 72 ce ff ff       	call   80102630 <lapiceoi>
    break;
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	e9 ca fe ff ff       	jmp    80105690 <trap+0xa0>
801057c6:	8d 76 00             	lea    0x0(%esi),%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801057d0:	e8 9b c7 ff ff       	call   80101f70 <ideintr>
801057d5:	eb 96                	jmp    8010576d <trap+0x17d>
801057d7:	89 f6                	mov    %esi,%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801057e0:	e8 bb de ff ff       	call   801036a0 <myproc>
801057e5:	8b 58 24             	mov    0x24(%eax),%ebx
801057e8:	85 db                	test   %ebx,%ebx
801057ea:	75 54                	jne    80105840 <trap+0x250>
      exit();
    myproc()->tf = tf;
801057ec:	e8 af de ff ff       	call   801036a0 <myproc>
801057f1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801057f4:	e8 d7 ee ff ff       	call   801046d0 <syscall>
    if(myproc()->killed)
801057f9:	e8 a2 de ff ff       	call   801036a0 <myproc>
801057fe:	8b 48 24             	mov    0x24(%eax),%ecx
80105801:	85 c9                	test   %ecx,%ecx
80105803:	0f 84 d6 fe ff ff    	je     801056df <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010580c:	5b                   	pop    %ebx
8010580d:	5e                   	pop    %esi
8010580e:	5f                   	pop    %edi
8010580f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105810:	e9 fb e2 ff ff       	jmp    80103b10 <exit>
80105815:	8d 76 00             	lea    0x0(%esi),%esi
    if(allocuvm(p->pgdir, PGROUNDDOWN(num), num) == 0){
        cprintf("case T_PGFLT from trap.c: allocuvm failed. Number of current allocated pages: %d\n", p->pages);
        exit();
    }
    else{
        p->pages += 1;
80105818:	8b 46 7c             	mov    0x7c(%esi),%eax
        cprintf("case T_PGFLT from trap.c: allocuvm succeeded. Number of pages allocated: %d\n", p->pages);
8010581b:	83 ec 08             	sub    $0x8,%esp
    if(allocuvm(p->pgdir, PGROUNDDOWN(num), num) == 0){
        cprintf("case T_PGFLT from trap.c: allocuvm failed. Number of current allocated pages: %d\n", p->pages);
        exit();
    }
    else{
        p->pages += 1;
8010581e:	83 c0 01             	add    $0x1,%eax
80105821:	89 46 7c             	mov    %eax,0x7c(%esi)
        cprintf("case T_PGFLT from trap.c: allocuvm succeeded. Number of pages allocated: %d\n", p->pages);
80105824:	50                   	push   %eax
80105825:	68 24 78 10 80       	push   $0x80107824
8010582a:	e8 31 ae ff ff       	call   80100660 <cprintf>
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	e9 59 fe ff ff       	jmp    80105690 <trap+0xa0>
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105840:	e8 cb e2 ff ff       	call   80103b10 <exit>
80105845:	eb a5                	jmp    801057ec <trap+0x1fc>
80105847:	89 f6                	mov    %esi,%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	68 60 4d 11 80       	push   $0x80114d60
80105858:	e8 a3 e9 ff ff       	call   80104200 <acquire>
      ticks++;
      wakeup(&ticks);
8010585d:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105864:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
8010586b:	e8 d0 e5 ff ff       	call   80103e40 <wakeup>
      release(&tickslock);
80105870:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105877:	e8 a4 ea ff ff       	call   80104320 <release>
8010587c:	83 c4 10             	add    $0x10,%esp
8010587f:	e9 e9 fe ff ff       	jmp    8010576d <trap+0x17d>
80105884:	0f 20 d6             	mov    %cr2,%esi

//PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105887:	8b 5f 38             	mov    0x38(%edi),%ebx
8010588a:	e8 f1 dd ff ff       	call   80103680 <cpuid>
8010588f:	83 ec 0c             	sub    $0xc,%esp
80105892:	56                   	push   %esi
80105893:	53                   	push   %ebx
80105894:	50                   	push   %eax
80105895:	ff 77 30             	pushl  0x30(%edi)
80105898:	68 74 78 10 80       	push   $0x80107874
8010589d:	e8 be ad ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801058a2:	83 c4 14             	add    $0x14,%esp
801058a5:	68 a6 77 10 80       	push   $0x801077a6
801058aa:	e8 c1 aa ff ff       	call   80100370 <panic>
801058af:	90                   	nop

801058b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801058b0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801058b5:	55                   	push   %ebp
801058b6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801058b8:	85 c0                	test   %eax,%eax
801058ba:	74 1c                	je     801058d8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801058bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801058c1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801058c2:	a8 01                	test   $0x1,%al
801058c4:	74 12                	je     801058d8 <uartgetc+0x28>
801058c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058cb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801058cc:	0f b6 c0             	movzbl %al,%eax
}
801058cf:	5d                   	pop    %ebp
801058d0:	c3                   	ret    
801058d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801058d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801058dd:	5d                   	pop    %ebp
801058de:	c3                   	ret    
801058df:	90                   	nop

801058e0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	57                   	push   %edi
801058e4:	56                   	push   %esi
801058e5:	53                   	push   %ebx
801058e6:	89 c7                	mov    %eax,%edi
801058e8:	bb 80 00 00 00       	mov    $0x80,%ebx
801058ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801058f2:	83 ec 0c             	sub    $0xc,%esp
801058f5:	eb 1b                	jmp    80105912 <uartputc.part.0+0x32>
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	6a 0a                	push   $0xa
80105905:	e8 46 cd ff ff       	call   80102650 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	83 eb 01             	sub    $0x1,%ebx
80105910:	74 07                	je     80105919 <uartputc.part.0+0x39>
80105912:	89 f2                	mov    %esi,%edx
80105914:	ec                   	in     (%dx),%al
80105915:	a8 20                	test   $0x20,%al
80105917:	74 e7                	je     80105900 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105919:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010591e:	89 f8                	mov    %edi,%eax
80105920:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret    
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105930 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105930:	55                   	push   %ebp
80105931:	31 c9                	xor    %ecx,%ecx
80105933:	89 c8                	mov    %ecx,%eax
80105935:	89 e5                	mov    %esp,%ebp
80105937:	57                   	push   %edi
80105938:	56                   	push   %esi
80105939:	53                   	push   %ebx
8010593a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010593f:	89 da                	mov    %ebx,%edx
80105941:	83 ec 0c             	sub    $0xc,%esp
80105944:	ee                   	out    %al,(%dx)
80105945:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010594a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010594f:	89 fa                	mov    %edi,%edx
80105951:	ee                   	out    %al,(%dx)
80105952:	b8 0c 00 00 00       	mov    $0xc,%eax
80105957:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010595c:	ee                   	out    %al,(%dx)
8010595d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105962:	89 c8                	mov    %ecx,%eax
80105964:	89 f2                	mov    %esi,%edx
80105966:	ee                   	out    %al,(%dx)
80105967:	b8 03 00 00 00       	mov    $0x3,%eax
8010596c:	89 fa                	mov    %edi,%edx
8010596e:	ee                   	out    %al,(%dx)
8010596f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105974:	89 c8                	mov    %ecx,%eax
80105976:	ee                   	out    %al,(%dx)
80105977:	b8 01 00 00 00       	mov    $0x1,%eax
8010597c:	89 f2                	mov    %esi,%edx
8010597e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010597f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105984:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105985:	3c ff                	cmp    $0xff,%al
80105987:	74 5a                	je     801059e3 <uartinit+0xb3>
    return;
  uart = 1;
80105989:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105990:	00 00 00 
80105993:	89 da                	mov    %ebx,%edx
80105995:	ec                   	in     (%dx),%al
80105996:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010599b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010599c:	83 ec 08             	sub    $0x8,%esp
8010599f:	bb b4 79 10 80       	mov    $0x801079b4,%ebx
801059a4:	6a 00                	push   $0x0
801059a6:	6a 04                	push   $0x4
801059a8:	e8 13 c8 ff ff       	call   801021c0 <ioapicenable>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	b8 78 00 00 00       	mov    $0x78,%eax
801059b5:	eb 13                	jmp    801059ca <uartinit+0x9a>
801059b7:	89 f6                	mov    %esi,%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059c0:	83 c3 01             	add    $0x1,%ebx
801059c3:	0f be 03             	movsbl (%ebx),%eax
801059c6:	84 c0                	test   %al,%al
801059c8:	74 19                	je     801059e3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801059ca:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
801059d0:	85 d2                	test   %edx,%edx
801059d2:	74 ec                	je     801059c0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801059d4:	83 c3 01             	add    $0x1,%ebx
801059d7:	e8 04 ff ff ff       	call   801058e0 <uartputc.part.0>
801059dc:	0f be 03             	movsbl (%ebx),%eax
801059df:	84 c0                	test   %al,%al
801059e1:	75 e7                	jne    801059ca <uartinit+0x9a>
    uartputc(*p);
}
801059e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e6:	5b                   	pop    %ebx
801059e7:	5e                   	pop    %esi
801059e8:	5f                   	pop    %edi
801059e9:	5d                   	pop    %ebp
801059ea:	c3                   	ret    
801059eb:	90                   	nop
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801059f0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801059f6:	55                   	push   %ebp
801059f7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
801059f9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801059fb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
801059fe:	74 10                	je     80105a10 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105a00:	5d                   	pop    %ebp
80105a01:	e9 da fe ff ff       	jmp    801058e0 <uartputc.part.0>
80105a06:	8d 76 00             	lea    0x0(%esi),%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105a10:	5d                   	pop    %ebp
80105a11:	c3                   	ret    
80105a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a20 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105a26:	68 b0 58 10 80       	push   $0x801058b0
80105a2b:	e8 c0 ad ff ff       	call   801007f0 <consoleintr>
}
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	c9                   	leave  
80105a34:	c3                   	ret    

80105a35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a35:	6a 00                	push   $0x0
  pushl $0
80105a37:	6a 00                	push   $0x0
  jmp alltraps
80105a39:	e9 bc fa ff ff       	jmp    801054fa <alltraps>

80105a3e <vector1>:
.globl vector1
vector1:
  pushl $0
80105a3e:	6a 00                	push   $0x0
  pushl $1
80105a40:	6a 01                	push   $0x1
  jmp alltraps
80105a42:	e9 b3 fa ff ff       	jmp    801054fa <alltraps>

80105a47 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a47:	6a 00                	push   $0x0
  pushl $2
80105a49:	6a 02                	push   $0x2
  jmp alltraps
80105a4b:	e9 aa fa ff ff       	jmp    801054fa <alltraps>

80105a50 <vector3>:
.globl vector3
vector3:
  pushl $0
80105a50:	6a 00                	push   $0x0
  pushl $3
80105a52:	6a 03                	push   $0x3
  jmp alltraps
80105a54:	e9 a1 fa ff ff       	jmp    801054fa <alltraps>

80105a59 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a59:	6a 00                	push   $0x0
  pushl $4
80105a5b:	6a 04                	push   $0x4
  jmp alltraps
80105a5d:	e9 98 fa ff ff       	jmp    801054fa <alltraps>

80105a62 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a62:	6a 00                	push   $0x0
  pushl $5
80105a64:	6a 05                	push   $0x5
  jmp alltraps
80105a66:	e9 8f fa ff ff       	jmp    801054fa <alltraps>

80105a6b <vector6>:
.globl vector6
vector6:
  pushl $0
80105a6b:	6a 00                	push   $0x0
  pushl $6
80105a6d:	6a 06                	push   $0x6
  jmp alltraps
80105a6f:	e9 86 fa ff ff       	jmp    801054fa <alltraps>

80105a74 <vector7>:
.globl vector7
vector7:
  pushl $0
80105a74:	6a 00                	push   $0x0
  pushl $7
80105a76:	6a 07                	push   $0x7
  jmp alltraps
80105a78:	e9 7d fa ff ff       	jmp    801054fa <alltraps>

80105a7d <vector8>:
.globl vector8
vector8:
  pushl $8
80105a7d:	6a 08                	push   $0x8
  jmp alltraps
80105a7f:	e9 76 fa ff ff       	jmp    801054fa <alltraps>

80105a84 <vector9>:
.globl vector9
vector9:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $9
80105a86:	6a 09                	push   $0x9
  jmp alltraps
80105a88:	e9 6d fa ff ff       	jmp    801054fa <alltraps>

80105a8d <vector10>:
.globl vector10
vector10:
  pushl $10
80105a8d:	6a 0a                	push   $0xa
  jmp alltraps
80105a8f:	e9 66 fa ff ff       	jmp    801054fa <alltraps>

80105a94 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a94:	6a 0b                	push   $0xb
  jmp alltraps
80105a96:	e9 5f fa ff ff       	jmp    801054fa <alltraps>

80105a9b <vector12>:
.globl vector12
vector12:
  pushl $12
80105a9b:	6a 0c                	push   $0xc
  jmp alltraps
80105a9d:	e9 58 fa ff ff       	jmp    801054fa <alltraps>

80105aa2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105aa2:	6a 0d                	push   $0xd
  jmp alltraps
80105aa4:	e9 51 fa ff ff       	jmp    801054fa <alltraps>

80105aa9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105aa9:	6a 0e                	push   $0xe
  jmp alltraps
80105aab:	e9 4a fa ff ff       	jmp    801054fa <alltraps>

80105ab0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ab0:	6a 00                	push   $0x0
  pushl $15
80105ab2:	6a 0f                	push   $0xf
  jmp alltraps
80105ab4:	e9 41 fa ff ff       	jmp    801054fa <alltraps>

80105ab9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $16
80105abb:	6a 10                	push   $0x10
  jmp alltraps
80105abd:	e9 38 fa ff ff       	jmp    801054fa <alltraps>

80105ac2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ac2:	6a 11                	push   $0x11
  jmp alltraps
80105ac4:	e9 31 fa ff ff       	jmp    801054fa <alltraps>

80105ac9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ac9:	6a 00                	push   $0x0
  pushl $18
80105acb:	6a 12                	push   $0x12
  jmp alltraps
80105acd:	e9 28 fa ff ff       	jmp    801054fa <alltraps>

80105ad2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ad2:	6a 00                	push   $0x0
  pushl $19
80105ad4:	6a 13                	push   $0x13
  jmp alltraps
80105ad6:	e9 1f fa ff ff       	jmp    801054fa <alltraps>

80105adb <vector20>:
.globl vector20
vector20:
  pushl $0
80105adb:	6a 00                	push   $0x0
  pushl $20
80105add:	6a 14                	push   $0x14
  jmp alltraps
80105adf:	e9 16 fa ff ff       	jmp    801054fa <alltraps>

80105ae4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ae4:	6a 00                	push   $0x0
  pushl $21
80105ae6:	6a 15                	push   $0x15
  jmp alltraps
80105ae8:	e9 0d fa ff ff       	jmp    801054fa <alltraps>

80105aed <vector22>:
.globl vector22
vector22:
  pushl $0
80105aed:	6a 00                	push   $0x0
  pushl $22
80105aef:	6a 16                	push   $0x16
  jmp alltraps
80105af1:	e9 04 fa ff ff       	jmp    801054fa <alltraps>

80105af6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105af6:	6a 00                	push   $0x0
  pushl $23
80105af8:	6a 17                	push   $0x17
  jmp alltraps
80105afa:	e9 fb f9 ff ff       	jmp    801054fa <alltraps>

80105aff <vector24>:
.globl vector24
vector24:
  pushl $0
80105aff:	6a 00                	push   $0x0
  pushl $24
80105b01:	6a 18                	push   $0x18
  jmp alltraps
80105b03:	e9 f2 f9 ff ff       	jmp    801054fa <alltraps>

80105b08 <vector25>:
.globl vector25
vector25:
  pushl $0
80105b08:	6a 00                	push   $0x0
  pushl $25
80105b0a:	6a 19                	push   $0x19
  jmp alltraps
80105b0c:	e9 e9 f9 ff ff       	jmp    801054fa <alltraps>

80105b11 <vector26>:
.globl vector26
vector26:
  pushl $0
80105b11:	6a 00                	push   $0x0
  pushl $26
80105b13:	6a 1a                	push   $0x1a
  jmp alltraps
80105b15:	e9 e0 f9 ff ff       	jmp    801054fa <alltraps>

80105b1a <vector27>:
.globl vector27
vector27:
  pushl $0
80105b1a:	6a 00                	push   $0x0
  pushl $27
80105b1c:	6a 1b                	push   $0x1b
  jmp alltraps
80105b1e:	e9 d7 f9 ff ff       	jmp    801054fa <alltraps>

80105b23 <vector28>:
.globl vector28
vector28:
  pushl $0
80105b23:	6a 00                	push   $0x0
  pushl $28
80105b25:	6a 1c                	push   $0x1c
  jmp alltraps
80105b27:	e9 ce f9 ff ff       	jmp    801054fa <alltraps>

80105b2c <vector29>:
.globl vector29
vector29:
  pushl $0
80105b2c:	6a 00                	push   $0x0
  pushl $29
80105b2e:	6a 1d                	push   $0x1d
  jmp alltraps
80105b30:	e9 c5 f9 ff ff       	jmp    801054fa <alltraps>

80105b35 <vector30>:
.globl vector30
vector30:
  pushl $0
80105b35:	6a 00                	push   $0x0
  pushl $30
80105b37:	6a 1e                	push   $0x1e
  jmp alltraps
80105b39:	e9 bc f9 ff ff       	jmp    801054fa <alltraps>

80105b3e <vector31>:
.globl vector31
vector31:
  pushl $0
80105b3e:	6a 00                	push   $0x0
  pushl $31
80105b40:	6a 1f                	push   $0x1f
  jmp alltraps
80105b42:	e9 b3 f9 ff ff       	jmp    801054fa <alltraps>

80105b47 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b47:	6a 00                	push   $0x0
  pushl $32
80105b49:	6a 20                	push   $0x20
  jmp alltraps
80105b4b:	e9 aa f9 ff ff       	jmp    801054fa <alltraps>

80105b50 <vector33>:
.globl vector33
vector33:
  pushl $0
80105b50:	6a 00                	push   $0x0
  pushl $33
80105b52:	6a 21                	push   $0x21
  jmp alltraps
80105b54:	e9 a1 f9 ff ff       	jmp    801054fa <alltraps>

80105b59 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b59:	6a 00                	push   $0x0
  pushl $34
80105b5b:	6a 22                	push   $0x22
  jmp alltraps
80105b5d:	e9 98 f9 ff ff       	jmp    801054fa <alltraps>

80105b62 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b62:	6a 00                	push   $0x0
  pushl $35
80105b64:	6a 23                	push   $0x23
  jmp alltraps
80105b66:	e9 8f f9 ff ff       	jmp    801054fa <alltraps>

80105b6b <vector36>:
.globl vector36
vector36:
  pushl $0
80105b6b:	6a 00                	push   $0x0
  pushl $36
80105b6d:	6a 24                	push   $0x24
  jmp alltraps
80105b6f:	e9 86 f9 ff ff       	jmp    801054fa <alltraps>

80105b74 <vector37>:
.globl vector37
vector37:
  pushl $0
80105b74:	6a 00                	push   $0x0
  pushl $37
80105b76:	6a 25                	push   $0x25
  jmp alltraps
80105b78:	e9 7d f9 ff ff       	jmp    801054fa <alltraps>

80105b7d <vector38>:
.globl vector38
vector38:
  pushl $0
80105b7d:	6a 00                	push   $0x0
  pushl $38
80105b7f:	6a 26                	push   $0x26
  jmp alltraps
80105b81:	e9 74 f9 ff ff       	jmp    801054fa <alltraps>

80105b86 <vector39>:
.globl vector39
vector39:
  pushl $0
80105b86:	6a 00                	push   $0x0
  pushl $39
80105b88:	6a 27                	push   $0x27
  jmp alltraps
80105b8a:	e9 6b f9 ff ff       	jmp    801054fa <alltraps>

80105b8f <vector40>:
.globl vector40
vector40:
  pushl $0
80105b8f:	6a 00                	push   $0x0
  pushl $40
80105b91:	6a 28                	push   $0x28
  jmp alltraps
80105b93:	e9 62 f9 ff ff       	jmp    801054fa <alltraps>

80105b98 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b98:	6a 00                	push   $0x0
  pushl $41
80105b9a:	6a 29                	push   $0x29
  jmp alltraps
80105b9c:	e9 59 f9 ff ff       	jmp    801054fa <alltraps>

80105ba1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ba1:	6a 00                	push   $0x0
  pushl $42
80105ba3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ba5:	e9 50 f9 ff ff       	jmp    801054fa <alltraps>

80105baa <vector43>:
.globl vector43
vector43:
  pushl $0
80105baa:	6a 00                	push   $0x0
  pushl $43
80105bac:	6a 2b                	push   $0x2b
  jmp alltraps
80105bae:	e9 47 f9 ff ff       	jmp    801054fa <alltraps>

80105bb3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105bb3:	6a 00                	push   $0x0
  pushl $44
80105bb5:	6a 2c                	push   $0x2c
  jmp alltraps
80105bb7:	e9 3e f9 ff ff       	jmp    801054fa <alltraps>

80105bbc <vector45>:
.globl vector45
vector45:
  pushl $0
80105bbc:	6a 00                	push   $0x0
  pushl $45
80105bbe:	6a 2d                	push   $0x2d
  jmp alltraps
80105bc0:	e9 35 f9 ff ff       	jmp    801054fa <alltraps>

80105bc5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105bc5:	6a 00                	push   $0x0
  pushl $46
80105bc7:	6a 2e                	push   $0x2e
  jmp alltraps
80105bc9:	e9 2c f9 ff ff       	jmp    801054fa <alltraps>

80105bce <vector47>:
.globl vector47
vector47:
  pushl $0
80105bce:	6a 00                	push   $0x0
  pushl $47
80105bd0:	6a 2f                	push   $0x2f
  jmp alltraps
80105bd2:	e9 23 f9 ff ff       	jmp    801054fa <alltraps>

80105bd7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105bd7:	6a 00                	push   $0x0
  pushl $48
80105bd9:	6a 30                	push   $0x30
  jmp alltraps
80105bdb:	e9 1a f9 ff ff       	jmp    801054fa <alltraps>

80105be0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $49
80105be2:	6a 31                	push   $0x31
  jmp alltraps
80105be4:	e9 11 f9 ff ff       	jmp    801054fa <alltraps>

80105be9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $50
80105beb:	6a 32                	push   $0x32
  jmp alltraps
80105bed:	e9 08 f9 ff ff       	jmp    801054fa <alltraps>

80105bf2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105bf2:	6a 00                	push   $0x0
  pushl $51
80105bf4:	6a 33                	push   $0x33
  jmp alltraps
80105bf6:	e9 ff f8 ff ff       	jmp    801054fa <alltraps>

80105bfb <vector52>:
.globl vector52
vector52:
  pushl $0
80105bfb:	6a 00                	push   $0x0
  pushl $52
80105bfd:	6a 34                	push   $0x34
  jmp alltraps
80105bff:	e9 f6 f8 ff ff       	jmp    801054fa <alltraps>

80105c04 <vector53>:
.globl vector53
vector53:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $53
80105c06:	6a 35                	push   $0x35
  jmp alltraps
80105c08:	e9 ed f8 ff ff       	jmp    801054fa <alltraps>

80105c0d <vector54>:
.globl vector54
vector54:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $54
80105c0f:	6a 36                	push   $0x36
  jmp alltraps
80105c11:	e9 e4 f8 ff ff       	jmp    801054fa <alltraps>

80105c16 <vector55>:
.globl vector55
vector55:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $55
80105c18:	6a 37                	push   $0x37
  jmp alltraps
80105c1a:	e9 db f8 ff ff       	jmp    801054fa <alltraps>

80105c1f <vector56>:
.globl vector56
vector56:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $56
80105c21:	6a 38                	push   $0x38
  jmp alltraps
80105c23:	e9 d2 f8 ff ff       	jmp    801054fa <alltraps>

80105c28 <vector57>:
.globl vector57
vector57:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $57
80105c2a:	6a 39                	push   $0x39
  jmp alltraps
80105c2c:	e9 c9 f8 ff ff       	jmp    801054fa <alltraps>

80105c31 <vector58>:
.globl vector58
vector58:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $58
80105c33:	6a 3a                	push   $0x3a
  jmp alltraps
80105c35:	e9 c0 f8 ff ff       	jmp    801054fa <alltraps>

80105c3a <vector59>:
.globl vector59
vector59:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $59
80105c3c:	6a 3b                	push   $0x3b
  jmp alltraps
80105c3e:	e9 b7 f8 ff ff       	jmp    801054fa <alltraps>

80105c43 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $60
80105c45:	6a 3c                	push   $0x3c
  jmp alltraps
80105c47:	e9 ae f8 ff ff       	jmp    801054fa <alltraps>

80105c4c <vector61>:
.globl vector61
vector61:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $61
80105c4e:	6a 3d                	push   $0x3d
  jmp alltraps
80105c50:	e9 a5 f8 ff ff       	jmp    801054fa <alltraps>

80105c55 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $62
80105c57:	6a 3e                	push   $0x3e
  jmp alltraps
80105c59:	e9 9c f8 ff ff       	jmp    801054fa <alltraps>

80105c5e <vector63>:
.globl vector63
vector63:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $63
80105c60:	6a 3f                	push   $0x3f
  jmp alltraps
80105c62:	e9 93 f8 ff ff       	jmp    801054fa <alltraps>

80105c67 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $64
80105c69:	6a 40                	push   $0x40
  jmp alltraps
80105c6b:	e9 8a f8 ff ff       	jmp    801054fa <alltraps>

80105c70 <vector65>:
.globl vector65
vector65:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $65
80105c72:	6a 41                	push   $0x41
  jmp alltraps
80105c74:	e9 81 f8 ff ff       	jmp    801054fa <alltraps>

80105c79 <vector66>:
.globl vector66
vector66:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $66
80105c7b:	6a 42                	push   $0x42
  jmp alltraps
80105c7d:	e9 78 f8 ff ff       	jmp    801054fa <alltraps>

80105c82 <vector67>:
.globl vector67
vector67:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $67
80105c84:	6a 43                	push   $0x43
  jmp alltraps
80105c86:	e9 6f f8 ff ff       	jmp    801054fa <alltraps>

80105c8b <vector68>:
.globl vector68
vector68:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $68
80105c8d:	6a 44                	push   $0x44
  jmp alltraps
80105c8f:	e9 66 f8 ff ff       	jmp    801054fa <alltraps>

80105c94 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $69
80105c96:	6a 45                	push   $0x45
  jmp alltraps
80105c98:	e9 5d f8 ff ff       	jmp    801054fa <alltraps>

80105c9d <vector70>:
.globl vector70
vector70:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $70
80105c9f:	6a 46                	push   $0x46
  jmp alltraps
80105ca1:	e9 54 f8 ff ff       	jmp    801054fa <alltraps>

80105ca6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $71
80105ca8:	6a 47                	push   $0x47
  jmp alltraps
80105caa:	e9 4b f8 ff ff       	jmp    801054fa <alltraps>

80105caf <vector72>:
.globl vector72
vector72:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $72
80105cb1:	6a 48                	push   $0x48
  jmp alltraps
80105cb3:	e9 42 f8 ff ff       	jmp    801054fa <alltraps>

80105cb8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $73
80105cba:	6a 49                	push   $0x49
  jmp alltraps
80105cbc:	e9 39 f8 ff ff       	jmp    801054fa <alltraps>

80105cc1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $74
80105cc3:	6a 4a                	push   $0x4a
  jmp alltraps
80105cc5:	e9 30 f8 ff ff       	jmp    801054fa <alltraps>

80105cca <vector75>:
.globl vector75
vector75:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $75
80105ccc:	6a 4b                	push   $0x4b
  jmp alltraps
80105cce:	e9 27 f8 ff ff       	jmp    801054fa <alltraps>

80105cd3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $76
80105cd5:	6a 4c                	push   $0x4c
  jmp alltraps
80105cd7:	e9 1e f8 ff ff       	jmp    801054fa <alltraps>

80105cdc <vector77>:
.globl vector77
vector77:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $77
80105cde:	6a 4d                	push   $0x4d
  jmp alltraps
80105ce0:	e9 15 f8 ff ff       	jmp    801054fa <alltraps>

80105ce5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $78
80105ce7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ce9:	e9 0c f8 ff ff       	jmp    801054fa <alltraps>

80105cee <vector79>:
.globl vector79
vector79:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $79
80105cf0:	6a 4f                	push   $0x4f
  jmp alltraps
80105cf2:	e9 03 f8 ff ff       	jmp    801054fa <alltraps>

80105cf7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $80
80105cf9:	6a 50                	push   $0x50
  jmp alltraps
80105cfb:	e9 fa f7 ff ff       	jmp    801054fa <alltraps>

80105d00 <vector81>:
.globl vector81
vector81:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $81
80105d02:	6a 51                	push   $0x51
  jmp alltraps
80105d04:	e9 f1 f7 ff ff       	jmp    801054fa <alltraps>

80105d09 <vector82>:
.globl vector82
vector82:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $82
80105d0b:	6a 52                	push   $0x52
  jmp alltraps
80105d0d:	e9 e8 f7 ff ff       	jmp    801054fa <alltraps>

80105d12 <vector83>:
.globl vector83
vector83:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $83
80105d14:	6a 53                	push   $0x53
  jmp alltraps
80105d16:	e9 df f7 ff ff       	jmp    801054fa <alltraps>

80105d1b <vector84>:
.globl vector84
vector84:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $84
80105d1d:	6a 54                	push   $0x54
  jmp alltraps
80105d1f:	e9 d6 f7 ff ff       	jmp    801054fa <alltraps>

80105d24 <vector85>:
.globl vector85
vector85:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $85
80105d26:	6a 55                	push   $0x55
  jmp alltraps
80105d28:	e9 cd f7 ff ff       	jmp    801054fa <alltraps>

80105d2d <vector86>:
.globl vector86
vector86:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $86
80105d2f:	6a 56                	push   $0x56
  jmp alltraps
80105d31:	e9 c4 f7 ff ff       	jmp    801054fa <alltraps>

80105d36 <vector87>:
.globl vector87
vector87:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $87
80105d38:	6a 57                	push   $0x57
  jmp alltraps
80105d3a:	e9 bb f7 ff ff       	jmp    801054fa <alltraps>

80105d3f <vector88>:
.globl vector88
vector88:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $88
80105d41:	6a 58                	push   $0x58
  jmp alltraps
80105d43:	e9 b2 f7 ff ff       	jmp    801054fa <alltraps>

80105d48 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $89
80105d4a:	6a 59                	push   $0x59
  jmp alltraps
80105d4c:	e9 a9 f7 ff ff       	jmp    801054fa <alltraps>

80105d51 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $90
80105d53:	6a 5a                	push   $0x5a
  jmp alltraps
80105d55:	e9 a0 f7 ff ff       	jmp    801054fa <alltraps>

80105d5a <vector91>:
.globl vector91
vector91:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $91
80105d5c:	6a 5b                	push   $0x5b
  jmp alltraps
80105d5e:	e9 97 f7 ff ff       	jmp    801054fa <alltraps>

80105d63 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $92
80105d65:	6a 5c                	push   $0x5c
  jmp alltraps
80105d67:	e9 8e f7 ff ff       	jmp    801054fa <alltraps>

80105d6c <vector93>:
.globl vector93
vector93:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $93
80105d6e:	6a 5d                	push   $0x5d
  jmp alltraps
80105d70:	e9 85 f7 ff ff       	jmp    801054fa <alltraps>

80105d75 <vector94>:
.globl vector94
vector94:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $94
80105d77:	6a 5e                	push   $0x5e
  jmp alltraps
80105d79:	e9 7c f7 ff ff       	jmp    801054fa <alltraps>

80105d7e <vector95>:
.globl vector95
vector95:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $95
80105d80:	6a 5f                	push   $0x5f
  jmp alltraps
80105d82:	e9 73 f7 ff ff       	jmp    801054fa <alltraps>

80105d87 <vector96>:
.globl vector96
vector96:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $96
80105d89:	6a 60                	push   $0x60
  jmp alltraps
80105d8b:	e9 6a f7 ff ff       	jmp    801054fa <alltraps>

80105d90 <vector97>:
.globl vector97
vector97:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $97
80105d92:	6a 61                	push   $0x61
  jmp alltraps
80105d94:	e9 61 f7 ff ff       	jmp    801054fa <alltraps>

80105d99 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $98
80105d9b:	6a 62                	push   $0x62
  jmp alltraps
80105d9d:	e9 58 f7 ff ff       	jmp    801054fa <alltraps>

80105da2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $99
80105da4:	6a 63                	push   $0x63
  jmp alltraps
80105da6:	e9 4f f7 ff ff       	jmp    801054fa <alltraps>

80105dab <vector100>:
.globl vector100
vector100:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $100
80105dad:	6a 64                	push   $0x64
  jmp alltraps
80105daf:	e9 46 f7 ff ff       	jmp    801054fa <alltraps>

80105db4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $101
80105db6:	6a 65                	push   $0x65
  jmp alltraps
80105db8:	e9 3d f7 ff ff       	jmp    801054fa <alltraps>

80105dbd <vector102>:
.globl vector102
vector102:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $102
80105dbf:	6a 66                	push   $0x66
  jmp alltraps
80105dc1:	e9 34 f7 ff ff       	jmp    801054fa <alltraps>

80105dc6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $103
80105dc8:	6a 67                	push   $0x67
  jmp alltraps
80105dca:	e9 2b f7 ff ff       	jmp    801054fa <alltraps>

80105dcf <vector104>:
.globl vector104
vector104:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $104
80105dd1:	6a 68                	push   $0x68
  jmp alltraps
80105dd3:	e9 22 f7 ff ff       	jmp    801054fa <alltraps>

80105dd8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $105
80105dda:	6a 69                	push   $0x69
  jmp alltraps
80105ddc:	e9 19 f7 ff ff       	jmp    801054fa <alltraps>

80105de1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $106
80105de3:	6a 6a                	push   $0x6a
  jmp alltraps
80105de5:	e9 10 f7 ff ff       	jmp    801054fa <alltraps>

80105dea <vector107>:
.globl vector107
vector107:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $107
80105dec:	6a 6b                	push   $0x6b
  jmp alltraps
80105dee:	e9 07 f7 ff ff       	jmp    801054fa <alltraps>

80105df3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $108
80105df5:	6a 6c                	push   $0x6c
  jmp alltraps
80105df7:	e9 fe f6 ff ff       	jmp    801054fa <alltraps>

80105dfc <vector109>:
.globl vector109
vector109:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $109
80105dfe:	6a 6d                	push   $0x6d
  jmp alltraps
80105e00:	e9 f5 f6 ff ff       	jmp    801054fa <alltraps>

80105e05 <vector110>:
.globl vector110
vector110:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $110
80105e07:	6a 6e                	push   $0x6e
  jmp alltraps
80105e09:	e9 ec f6 ff ff       	jmp    801054fa <alltraps>

80105e0e <vector111>:
.globl vector111
vector111:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $111
80105e10:	6a 6f                	push   $0x6f
  jmp alltraps
80105e12:	e9 e3 f6 ff ff       	jmp    801054fa <alltraps>

80105e17 <vector112>:
.globl vector112
vector112:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $112
80105e19:	6a 70                	push   $0x70
  jmp alltraps
80105e1b:	e9 da f6 ff ff       	jmp    801054fa <alltraps>

80105e20 <vector113>:
.globl vector113
vector113:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $113
80105e22:	6a 71                	push   $0x71
  jmp alltraps
80105e24:	e9 d1 f6 ff ff       	jmp    801054fa <alltraps>

80105e29 <vector114>:
.globl vector114
vector114:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $114
80105e2b:	6a 72                	push   $0x72
  jmp alltraps
80105e2d:	e9 c8 f6 ff ff       	jmp    801054fa <alltraps>

80105e32 <vector115>:
.globl vector115
vector115:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $115
80105e34:	6a 73                	push   $0x73
  jmp alltraps
80105e36:	e9 bf f6 ff ff       	jmp    801054fa <alltraps>

80105e3b <vector116>:
.globl vector116
vector116:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $116
80105e3d:	6a 74                	push   $0x74
  jmp alltraps
80105e3f:	e9 b6 f6 ff ff       	jmp    801054fa <alltraps>

80105e44 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $117
80105e46:	6a 75                	push   $0x75
  jmp alltraps
80105e48:	e9 ad f6 ff ff       	jmp    801054fa <alltraps>

80105e4d <vector118>:
.globl vector118
vector118:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $118
80105e4f:	6a 76                	push   $0x76
  jmp alltraps
80105e51:	e9 a4 f6 ff ff       	jmp    801054fa <alltraps>

80105e56 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $119
80105e58:	6a 77                	push   $0x77
  jmp alltraps
80105e5a:	e9 9b f6 ff ff       	jmp    801054fa <alltraps>

80105e5f <vector120>:
.globl vector120
vector120:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $120
80105e61:	6a 78                	push   $0x78
  jmp alltraps
80105e63:	e9 92 f6 ff ff       	jmp    801054fa <alltraps>

80105e68 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $121
80105e6a:	6a 79                	push   $0x79
  jmp alltraps
80105e6c:	e9 89 f6 ff ff       	jmp    801054fa <alltraps>

80105e71 <vector122>:
.globl vector122
vector122:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $122
80105e73:	6a 7a                	push   $0x7a
  jmp alltraps
80105e75:	e9 80 f6 ff ff       	jmp    801054fa <alltraps>

80105e7a <vector123>:
.globl vector123
vector123:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $123
80105e7c:	6a 7b                	push   $0x7b
  jmp alltraps
80105e7e:	e9 77 f6 ff ff       	jmp    801054fa <alltraps>

80105e83 <vector124>:
.globl vector124
vector124:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $124
80105e85:	6a 7c                	push   $0x7c
  jmp alltraps
80105e87:	e9 6e f6 ff ff       	jmp    801054fa <alltraps>

80105e8c <vector125>:
.globl vector125
vector125:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $125
80105e8e:	6a 7d                	push   $0x7d
  jmp alltraps
80105e90:	e9 65 f6 ff ff       	jmp    801054fa <alltraps>

80105e95 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $126
80105e97:	6a 7e                	push   $0x7e
  jmp alltraps
80105e99:	e9 5c f6 ff ff       	jmp    801054fa <alltraps>

80105e9e <vector127>:
.globl vector127
vector127:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $127
80105ea0:	6a 7f                	push   $0x7f
  jmp alltraps
80105ea2:	e9 53 f6 ff ff       	jmp    801054fa <alltraps>

80105ea7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $128
80105ea9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105eae:	e9 47 f6 ff ff       	jmp    801054fa <alltraps>

80105eb3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105eb3:	6a 00                	push   $0x0
  pushl $129
80105eb5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105eba:	e9 3b f6 ff ff       	jmp    801054fa <alltraps>

80105ebf <vector130>:
.globl vector130
vector130:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $130
80105ec1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ec6:	e9 2f f6 ff ff       	jmp    801054fa <alltraps>

80105ecb <vector131>:
.globl vector131
vector131:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $131
80105ecd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105ed2:	e9 23 f6 ff ff       	jmp    801054fa <alltraps>

80105ed7 <vector132>:
.globl vector132
vector132:
  pushl $0
80105ed7:	6a 00                	push   $0x0
  pushl $132
80105ed9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105ede:	e9 17 f6 ff ff       	jmp    801054fa <alltraps>

80105ee3 <vector133>:
.globl vector133
vector133:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $133
80105ee5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105eea:	e9 0b f6 ff ff       	jmp    801054fa <alltraps>

80105eef <vector134>:
.globl vector134
vector134:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $134
80105ef1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105ef6:	e9 ff f5 ff ff       	jmp    801054fa <alltraps>

80105efb <vector135>:
.globl vector135
vector135:
  pushl $0
80105efb:	6a 00                	push   $0x0
  pushl $135
80105efd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105f02:	e9 f3 f5 ff ff       	jmp    801054fa <alltraps>

80105f07 <vector136>:
.globl vector136
vector136:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $136
80105f09:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105f0e:	e9 e7 f5 ff ff       	jmp    801054fa <alltraps>

80105f13 <vector137>:
.globl vector137
vector137:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $137
80105f15:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105f1a:	e9 db f5 ff ff       	jmp    801054fa <alltraps>

80105f1f <vector138>:
.globl vector138
vector138:
  pushl $0
80105f1f:	6a 00                	push   $0x0
  pushl $138
80105f21:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105f26:	e9 cf f5 ff ff       	jmp    801054fa <alltraps>

80105f2b <vector139>:
.globl vector139
vector139:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $139
80105f2d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f32:	e9 c3 f5 ff ff       	jmp    801054fa <alltraps>

80105f37 <vector140>:
.globl vector140
vector140:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $140
80105f39:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f3e:	e9 b7 f5 ff ff       	jmp    801054fa <alltraps>

80105f43 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f43:	6a 00                	push   $0x0
  pushl $141
80105f45:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f4a:	e9 ab f5 ff ff       	jmp    801054fa <alltraps>

80105f4f <vector142>:
.globl vector142
vector142:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $142
80105f51:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f56:	e9 9f f5 ff ff       	jmp    801054fa <alltraps>

80105f5b <vector143>:
.globl vector143
vector143:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $143
80105f5d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f62:	e9 93 f5 ff ff       	jmp    801054fa <alltraps>

80105f67 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f67:	6a 00                	push   $0x0
  pushl $144
80105f69:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f6e:	e9 87 f5 ff ff       	jmp    801054fa <alltraps>

80105f73 <vector145>:
.globl vector145
vector145:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $145
80105f75:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f7a:	e9 7b f5 ff ff       	jmp    801054fa <alltraps>

80105f7f <vector146>:
.globl vector146
vector146:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $146
80105f81:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f86:	e9 6f f5 ff ff       	jmp    801054fa <alltraps>

80105f8b <vector147>:
.globl vector147
vector147:
  pushl $0
80105f8b:	6a 00                	push   $0x0
  pushl $147
80105f8d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f92:	e9 63 f5 ff ff       	jmp    801054fa <alltraps>

80105f97 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $148
80105f99:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f9e:	e9 57 f5 ff ff       	jmp    801054fa <alltraps>

80105fa3 <vector149>:
.globl vector149
vector149:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $149
80105fa5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105faa:	e9 4b f5 ff ff       	jmp    801054fa <alltraps>

80105faf <vector150>:
.globl vector150
vector150:
  pushl $0
80105faf:	6a 00                	push   $0x0
  pushl $150
80105fb1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105fb6:	e9 3f f5 ff ff       	jmp    801054fa <alltraps>

80105fbb <vector151>:
.globl vector151
vector151:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $151
80105fbd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105fc2:	e9 33 f5 ff ff       	jmp    801054fa <alltraps>

80105fc7 <vector152>:
.globl vector152
vector152:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $152
80105fc9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105fce:	e9 27 f5 ff ff       	jmp    801054fa <alltraps>

80105fd3 <vector153>:
.globl vector153
vector153:
  pushl $0
80105fd3:	6a 00                	push   $0x0
  pushl $153
80105fd5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105fda:	e9 1b f5 ff ff       	jmp    801054fa <alltraps>

80105fdf <vector154>:
.globl vector154
vector154:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $154
80105fe1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105fe6:	e9 0f f5 ff ff       	jmp    801054fa <alltraps>

80105feb <vector155>:
.globl vector155
vector155:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $155
80105fed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ff2:	e9 03 f5 ff ff       	jmp    801054fa <alltraps>

80105ff7 <vector156>:
.globl vector156
vector156:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $156
80105ff9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105ffe:	e9 f7 f4 ff ff       	jmp    801054fa <alltraps>

80106003 <vector157>:
.globl vector157
vector157:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $157
80106005:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010600a:	e9 eb f4 ff ff       	jmp    801054fa <alltraps>

8010600f <vector158>:
.globl vector158
vector158:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $158
80106011:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106016:	e9 df f4 ff ff       	jmp    801054fa <alltraps>

8010601b <vector159>:
.globl vector159
vector159:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $159
8010601d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106022:	e9 d3 f4 ff ff       	jmp    801054fa <alltraps>

80106027 <vector160>:
.globl vector160
vector160:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $160
80106029:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010602e:	e9 c7 f4 ff ff       	jmp    801054fa <alltraps>

80106033 <vector161>:
.globl vector161
vector161:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $161
80106035:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010603a:	e9 bb f4 ff ff       	jmp    801054fa <alltraps>

8010603f <vector162>:
.globl vector162
vector162:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $162
80106041:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106046:	e9 af f4 ff ff       	jmp    801054fa <alltraps>

8010604b <vector163>:
.globl vector163
vector163:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $163
8010604d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106052:	e9 a3 f4 ff ff       	jmp    801054fa <alltraps>

80106057 <vector164>:
.globl vector164
vector164:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $164
80106059:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010605e:	e9 97 f4 ff ff       	jmp    801054fa <alltraps>

80106063 <vector165>:
.globl vector165
vector165:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $165
80106065:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010606a:	e9 8b f4 ff ff       	jmp    801054fa <alltraps>

8010606f <vector166>:
.globl vector166
vector166:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $166
80106071:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106076:	e9 7f f4 ff ff       	jmp    801054fa <alltraps>

8010607b <vector167>:
.globl vector167
vector167:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $167
8010607d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106082:	e9 73 f4 ff ff       	jmp    801054fa <alltraps>

80106087 <vector168>:
.globl vector168
vector168:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $168
80106089:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010608e:	e9 67 f4 ff ff       	jmp    801054fa <alltraps>

80106093 <vector169>:
.globl vector169
vector169:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $169
80106095:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010609a:	e9 5b f4 ff ff       	jmp    801054fa <alltraps>

8010609f <vector170>:
.globl vector170
vector170:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $170
801060a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801060a6:	e9 4f f4 ff ff       	jmp    801054fa <alltraps>

801060ab <vector171>:
.globl vector171
vector171:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $171
801060ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801060b2:	e9 43 f4 ff ff       	jmp    801054fa <alltraps>

801060b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $172
801060b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801060be:	e9 37 f4 ff ff       	jmp    801054fa <alltraps>

801060c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $173
801060c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801060ca:	e9 2b f4 ff ff       	jmp    801054fa <alltraps>

801060cf <vector174>:
.globl vector174
vector174:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $174
801060d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801060d6:	e9 1f f4 ff ff       	jmp    801054fa <alltraps>

801060db <vector175>:
.globl vector175
vector175:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $175
801060dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801060e2:	e9 13 f4 ff ff       	jmp    801054fa <alltraps>

801060e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $176
801060e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801060ee:	e9 07 f4 ff ff       	jmp    801054fa <alltraps>

801060f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $177
801060f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060fa:	e9 fb f3 ff ff       	jmp    801054fa <alltraps>

801060ff <vector178>:
.globl vector178
vector178:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $178
80106101:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106106:	e9 ef f3 ff ff       	jmp    801054fa <alltraps>

8010610b <vector179>:
.globl vector179
vector179:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $179
8010610d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106112:	e9 e3 f3 ff ff       	jmp    801054fa <alltraps>

80106117 <vector180>:
.globl vector180
vector180:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $180
80106119:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010611e:	e9 d7 f3 ff ff       	jmp    801054fa <alltraps>

80106123 <vector181>:
.globl vector181
vector181:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $181
80106125:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010612a:	e9 cb f3 ff ff       	jmp    801054fa <alltraps>

8010612f <vector182>:
.globl vector182
vector182:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $182
80106131:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106136:	e9 bf f3 ff ff       	jmp    801054fa <alltraps>

8010613b <vector183>:
.globl vector183
vector183:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $183
8010613d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106142:	e9 b3 f3 ff ff       	jmp    801054fa <alltraps>

80106147 <vector184>:
.globl vector184
vector184:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $184
80106149:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010614e:	e9 a7 f3 ff ff       	jmp    801054fa <alltraps>

80106153 <vector185>:
.globl vector185
vector185:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $185
80106155:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010615a:	e9 9b f3 ff ff       	jmp    801054fa <alltraps>

8010615f <vector186>:
.globl vector186
vector186:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $186
80106161:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106166:	e9 8f f3 ff ff       	jmp    801054fa <alltraps>

8010616b <vector187>:
.globl vector187
vector187:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $187
8010616d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106172:	e9 83 f3 ff ff       	jmp    801054fa <alltraps>

80106177 <vector188>:
.globl vector188
vector188:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $188
80106179:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010617e:	e9 77 f3 ff ff       	jmp    801054fa <alltraps>

80106183 <vector189>:
.globl vector189
vector189:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $189
80106185:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010618a:	e9 6b f3 ff ff       	jmp    801054fa <alltraps>

8010618f <vector190>:
.globl vector190
vector190:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $190
80106191:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106196:	e9 5f f3 ff ff       	jmp    801054fa <alltraps>

8010619b <vector191>:
.globl vector191
vector191:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $191
8010619d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801061a2:	e9 53 f3 ff ff       	jmp    801054fa <alltraps>

801061a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $192
801061a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801061ae:	e9 47 f3 ff ff       	jmp    801054fa <alltraps>

801061b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $193
801061b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801061ba:	e9 3b f3 ff ff       	jmp    801054fa <alltraps>

801061bf <vector194>:
.globl vector194
vector194:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $194
801061c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801061c6:	e9 2f f3 ff ff       	jmp    801054fa <alltraps>

801061cb <vector195>:
.globl vector195
vector195:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $195
801061cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801061d2:	e9 23 f3 ff ff       	jmp    801054fa <alltraps>

801061d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $196
801061d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801061de:	e9 17 f3 ff ff       	jmp    801054fa <alltraps>

801061e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $197
801061e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801061ea:	e9 0b f3 ff ff       	jmp    801054fa <alltraps>

801061ef <vector198>:
.globl vector198
vector198:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $198
801061f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061f6:	e9 ff f2 ff ff       	jmp    801054fa <alltraps>

801061fb <vector199>:
.globl vector199
vector199:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $199
801061fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106202:	e9 f3 f2 ff ff       	jmp    801054fa <alltraps>

80106207 <vector200>:
.globl vector200
vector200:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $200
80106209:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010620e:	e9 e7 f2 ff ff       	jmp    801054fa <alltraps>

80106213 <vector201>:
.globl vector201
vector201:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $201
80106215:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010621a:	e9 db f2 ff ff       	jmp    801054fa <alltraps>

8010621f <vector202>:
.globl vector202
vector202:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $202
80106221:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106226:	e9 cf f2 ff ff       	jmp    801054fa <alltraps>

8010622b <vector203>:
.globl vector203
vector203:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $203
8010622d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106232:	e9 c3 f2 ff ff       	jmp    801054fa <alltraps>

80106237 <vector204>:
.globl vector204
vector204:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $204
80106239:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010623e:	e9 b7 f2 ff ff       	jmp    801054fa <alltraps>

80106243 <vector205>:
.globl vector205
vector205:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $205
80106245:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010624a:	e9 ab f2 ff ff       	jmp    801054fa <alltraps>

8010624f <vector206>:
.globl vector206
vector206:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $206
80106251:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106256:	e9 9f f2 ff ff       	jmp    801054fa <alltraps>

8010625b <vector207>:
.globl vector207
vector207:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $207
8010625d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106262:	e9 93 f2 ff ff       	jmp    801054fa <alltraps>

80106267 <vector208>:
.globl vector208
vector208:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $208
80106269:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010626e:	e9 87 f2 ff ff       	jmp    801054fa <alltraps>

80106273 <vector209>:
.globl vector209
vector209:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $209
80106275:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010627a:	e9 7b f2 ff ff       	jmp    801054fa <alltraps>

8010627f <vector210>:
.globl vector210
vector210:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $210
80106281:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106286:	e9 6f f2 ff ff       	jmp    801054fa <alltraps>

8010628b <vector211>:
.globl vector211
vector211:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $211
8010628d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106292:	e9 63 f2 ff ff       	jmp    801054fa <alltraps>

80106297 <vector212>:
.globl vector212
vector212:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $212
80106299:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010629e:	e9 57 f2 ff ff       	jmp    801054fa <alltraps>

801062a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $213
801062a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801062aa:	e9 4b f2 ff ff       	jmp    801054fa <alltraps>

801062af <vector214>:
.globl vector214
vector214:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $214
801062b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801062b6:	e9 3f f2 ff ff       	jmp    801054fa <alltraps>

801062bb <vector215>:
.globl vector215
vector215:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $215
801062bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801062c2:	e9 33 f2 ff ff       	jmp    801054fa <alltraps>

801062c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $216
801062c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801062ce:	e9 27 f2 ff ff       	jmp    801054fa <alltraps>

801062d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $217
801062d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801062da:	e9 1b f2 ff ff       	jmp    801054fa <alltraps>

801062df <vector218>:
.globl vector218
vector218:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $218
801062e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801062e6:	e9 0f f2 ff ff       	jmp    801054fa <alltraps>

801062eb <vector219>:
.globl vector219
vector219:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $219
801062ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062f2:	e9 03 f2 ff ff       	jmp    801054fa <alltraps>

801062f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $220
801062f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062fe:	e9 f7 f1 ff ff       	jmp    801054fa <alltraps>

80106303 <vector221>:
.globl vector221
vector221:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $221
80106305:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010630a:	e9 eb f1 ff ff       	jmp    801054fa <alltraps>

8010630f <vector222>:
.globl vector222
vector222:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $222
80106311:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106316:	e9 df f1 ff ff       	jmp    801054fa <alltraps>

8010631b <vector223>:
.globl vector223
vector223:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $223
8010631d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106322:	e9 d3 f1 ff ff       	jmp    801054fa <alltraps>

80106327 <vector224>:
.globl vector224
vector224:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $224
80106329:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010632e:	e9 c7 f1 ff ff       	jmp    801054fa <alltraps>

80106333 <vector225>:
.globl vector225
vector225:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $225
80106335:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010633a:	e9 bb f1 ff ff       	jmp    801054fa <alltraps>

8010633f <vector226>:
.globl vector226
vector226:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $226
80106341:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106346:	e9 af f1 ff ff       	jmp    801054fa <alltraps>

8010634b <vector227>:
.globl vector227
vector227:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $227
8010634d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106352:	e9 a3 f1 ff ff       	jmp    801054fa <alltraps>

80106357 <vector228>:
.globl vector228
vector228:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $228
80106359:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010635e:	e9 97 f1 ff ff       	jmp    801054fa <alltraps>

80106363 <vector229>:
.globl vector229
vector229:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $229
80106365:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010636a:	e9 8b f1 ff ff       	jmp    801054fa <alltraps>

8010636f <vector230>:
.globl vector230
vector230:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $230
80106371:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106376:	e9 7f f1 ff ff       	jmp    801054fa <alltraps>

8010637b <vector231>:
.globl vector231
vector231:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $231
8010637d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106382:	e9 73 f1 ff ff       	jmp    801054fa <alltraps>

80106387 <vector232>:
.globl vector232
vector232:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $232
80106389:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010638e:	e9 67 f1 ff ff       	jmp    801054fa <alltraps>

80106393 <vector233>:
.globl vector233
vector233:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $233
80106395:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010639a:	e9 5b f1 ff ff       	jmp    801054fa <alltraps>

8010639f <vector234>:
.globl vector234
vector234:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $234
801063a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801063a6:	e9 4f f1 ff ff       	jmp    801054fa <alltraps>

801063ab <vector235>:
.globl vector235
vector235:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $235
801063ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801063b2:	e9 43 f1 ff ff       	jmp    801054fa <alltraps>

801063b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $236
801063b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801063be:	e9 37 f1 ff ff       	jmp    801054fa <alltraps>

801063c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $237
801063c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801063ca:	e9 2b f1 ff ff       	jmp    801054fa <alltraps>

801063cf <vector238>:
.globl vector238
vector238:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $238
801063d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801063d6:	e9 1f f1 ff ff       	jmp    801054fa <alltraps>

801063db <vector239>:
.globl vector239
vector239:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $239
801063dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801063e2:	e9 13 f1 ff ff       	jmp    801054fa <alltraps>

801063e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $240
801063e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801063ee:	e9 07 f1 ff ff       	jmp    801054fa <alltraps>

801063f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $241
801063f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063fa:	e9 fb f0 ff ff       	jmp    801054fa <alltraps>

801063ff <vector242>:
.globl vector242
vector242:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $242
80106401:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106406:	e9 ef f0 ff ff       	jmp    801054fa <alltraps>

8010640b <vector243>:
.globl vector243
vector243:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $243
8010640d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106412:	e9 e3 f0 ff ff       	jmp    801054fa <alltraps>

80106417 <vector244>:
.globl vector244
vector244:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $244
80106419:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010641e:	e9 d7 f0 ff ff       	jmp    801054fa <alltraps>

80106423 <vector245>:
.globl vector245
vector245:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $245
80106425:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010642a:	e9 cb f0 ff ff       	jmp    801054fa <alltraps>

8010642f <vector246>:
.globl vector246
vector246:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $246
80106431:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106436:	e9 bf f0 ff ff       	jmp    801054fa <alltraps>

8010643b <vector247>:
.globl vector247
vector247:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $247
8010643d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106442:	e9 b3 f0 ff ff       	jmp    801054fa <alltraps>

80106447 <vector248>:
.globl vector248
vector248:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $248
80106449:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010644e:	e9 a7 f0 ff ff       	jmp    801054fa <alltraps>

80106453 <vector249>:
.globl vector249
vector249:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $249
80106455:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010645a:	e9 9b f0 ff ff       	jmp    801054fa <alltraps>

8010645f <vector250>:
.globl vector250
vector250:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $250
80106461:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106466:	e9 8f f0 ff ff       	jmp    801054fa <alltraps>

8010646b <vector251>:
.globl vector251
vector251:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $251
8010646d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106472:	e9 83 f0 ff ff       	jmp    801054fa <alltraps>

80106477 <vector252>:
.globl vector252
vector252:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $252
80106479:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010647e:	e9 77 f0 ff ff       	jmp    801054fa <alltraps>

80106483 <vector253>:
.globl vector253
vector253:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $253
80106485:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010648a:	e9 6b f0 ff ff       	jmp    801054fa <alltraps>

8010648f <vector254>:
.globl vector254
vector254:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $254
80106491:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106496:	e9 5f f0 ff ff       	jmp    801054fa <alltraps>

8010649b <vector255>:
.globl vector255
vector255:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $255
8010649d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801064a2:	e9 53 f0 ff ff       	jmp    801054fa <alltraps>
801064a7:	66 90                	xchg   %ax,%ax
801064a9:	66 90                	xchg   %ax,%ax
801064ab:	66 90                	xchg   %ax,%ax
801064ad:	66 90                	xchg   %ax,%ax
801064af:	90                   	nop

801064b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	56                   	push   %esi
801064b5:	53                   	push   %ebx
801064b6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801064b8:	c1 ea 16             	shr    $0x16,%edx
801064bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064be:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801064c1:	8b 07                	mov    (%edi),%eax
801064c3:	a8 01                	test   $0x1,%al
801064c5:	74 29                	je     801064f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801064c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801064cc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801064d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801064d5:	c1 eb 0a             	shr    $0xa,%ebx
801064d8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801064de:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
801064e1:	5b                   	pop    %ebx
801064e2:	5e                   	pop    %esi
801064e3:	5f                   	pop    %edi
801064e4:	5d                   	pop    %ebp
801064e5:	c3                   	ret    
801064e6:	8d 76 00             	lea    0x0(%esi),%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801064f0:	85 c9                	test   %ecx,%ecx
801064f2:	74 2c                	je     80106520 <walkpgdir+0x70>
801064f4:	e8 b7 be ff ff       	call   801023b0 <kalloc>
801064f9:	85 c0                	test   %eax,%eax
801064fb:	89 c6                	mov    %eax,%esi
801064fd:	74 21                	je     80106520 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801064ff:	83 ec 04             	sub    $0x4,%esp
80106502:	68 00 10 00 00       	push   $0x1000
80106507:	6a 00                	push   $0x0
80106509:	50                   	push   %eax
8010650a:	e8 61 de ff ff       	call   80104370 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010650f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106515:	83 c4 10             	add    $0x10,%esp
80106518:	83 c8 07             	or     $0x7,%eax
8010651b:	89 07                	mov    %eax,(%edi)
8010651d:	eb b3                	jmp    801064d2 <walkpgdir+0x22>
8010651f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106523:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106525:	5b                   	pop    %ebx
80106526:	5e                   	pop    %esi
80106527:	5f                   	pop    %edi
80106528:	5d                   	pop    %ebp
80106529:	c3                   	ret    
8010652a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106530 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	57                   	push   %edi
80106534:	56                   	push   %esi
80106535:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106536:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010653c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010653e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106544:	83 ec 1c             	sub    $0x1c,%esp
80106547:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010654a:	39 d3                	cmp    %edx,%ebx
8010654c:	73 66                	jae    801065b4 <deallocuvm.part.0+0x84>
8010654e:	89 d6                	mov    %edx,%esi
80106550:	eb 3d                	jmp    8010658f <deallocuvm.part.0+0x5f>
80106552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106558:	8b 10                	mov    (%eax),%edx
8010655a:	f6 c2 01             	test   $0x1,%dl
8010655d:	74 26                	je     80106585 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010655f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106565:	74 58                	je     801065bf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106567:	83 ec 0c             	sub    $0xc,%esp
8010656a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106573:	52                   	push   %edx
80106574:	e8 87 bc ff ff       	call   80102200 <kfree>
      *pte = 0;
80106579:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010657c:	83 c4 10             	add    $0x10,%esp
8010657f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106585:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010658b:	39 f3                	cmp    %esi,%ebx
8010658d:	73 25                	jae    801065b4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010658f:	31 c9                	xor    %ecx,%ecx
80106591:	89 da                	mov    %ebx,%edx
80106593:	89 f8                	mov    %edi,%eax
80106595:	e8 16 ff ff ff       	call   801064b0 <walkpgdir>
    if(!pte)
8010659a:	85 c0                	test   %eax,%eax
8010659c:	75 ba                	jne    80106558 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010659e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801065a4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801065aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065b0:	39 f3                	cmp    %esi,%ebx
801065b2:	72 db                	jb     8010658f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801065b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801065b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065ba:	5b                   	pop    %ebx
801065bb:	5e                   	pop    %esi
801065bc:	5f                   	pop    %edi
801065bd:	5d                   	pop    %ebp
801065be:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801065bf:	83 ec 0c             	sub    $0xc,%esp
801065c2:	68 26 72 10 80       	push   $0x80107226
801065c7:	e8 a4 9d ff ff       	call   80100370 <panic>
801065cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065d0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801065d6:	e8 a5 d0 ff ff       	call   80103680 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065db:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801065e1:	31 c9                	xor    %ecx,%ecx
801065e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801065e8:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
801065ef:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065f6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801065fb:	31 c9                	xor    %ecx,%ecx
801065fd:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106604:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106609:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106610:	31 c9                	xor    %ecx,%ecx
80106612:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106619:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106620:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106625:	31 c9                	xor    %ecx,%ecx
80106627:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010662e:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106635:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010663a:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106641:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106648:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010664f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106656:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
8010665d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106664:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010666b:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106672:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106679:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106680:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106687:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
8010668e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106695:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
8010669c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
801066a3:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801066aa:	05 f0 27 11 80       	add    $0x801127f0,%eax
801066af:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801066b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801066b7:	c1 e8 10             	shr    $0x10,%eax
801066ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801066be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801066c1:	0f 01 10             	lgdtl  (%eax)
}
801066c4:	c9                   	leave  
801066c5:	c3                   	ret    
801066c6:	8d 76 00             	lea    0x0(%esi),%esi
801066c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 1c             	sub    $0x1c,%esp
801066d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066dc:	8b 55 10             	mov    0x10(%ebp),%edx
801066df:	8b 7d 14             	mov    0x14(%ebp),%edi
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066e2:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066e4:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066f3:	29 df                	sub    %ebx,%edi
801066f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801066f8:	8b 45 18             	mov    0x18(%ebp),%eax
801066fb:	83 c8 01             	or     $0x1,%eax
801066fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106701:	eb 1a                	jmp    8010671d <mappages+0x4d>
80106703:	90                   	nop
80106704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106708:	f6 00 01             	testb  $0x1,(%eax)
8010670b:	75 3d                	jne    8010674a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010670d:	0b 75 e0             	or     -0x20(%ebp),%esi
    if(a == last)
80106710:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106713:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106715:	74 29                	je     80106740 <mappages+0x70>
      break;
    a += PGSIZE;
80106717:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010671d:	8b 45 08             	mov    0x8(%ebp),%eax
80106720:	b9 01 00 00 00       	mov    $0x1,%ecx
80106725:	89 da                	mov    %ebx,%edx
80106727:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
8010672a:	e8 81 fd ff ff       	call   801064b0 <walkpgdir>
8010672f:	85 c0                	test   %eax,%eax
80106731:	75 d5                	jne    80106708 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106733:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010673b:	5b                   	pop    %ebx
8010673c:	5e                   	pop    %esi
8010673d:	5f                   	pop    %edi
8010673e:	5d                   	pop    %ebp
8010673f:	c3                   	ret    
80106740:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106743:	31 c0                	xor    %eax,%eax
}
80106745:	5b                   	pop    %ebx
80106746:	5e                   	pop    %esi
80106747:	5f                   	pop    %edi
80106748:	5d                   	pop    %ebp
80106749:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010674a:	83 ec 0c             	sub    $0xc,%esp
8010674d:	68 bc 79 10 80       	push   $0x801079bc
80106752:	e8 19 9c ff ff       	call   80100370 <panic>
80106757:	89 f6                	mov    %esi,%esi
80106759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106760 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106760:	a1 a4 55 11 80       	mov    0x801155a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106765:	55                   	push   %ebp
80106766:	89 e5                	mov    %esp,%ebp
80106768:	05 00 00 00 80       	add    $0x80000000,%eax
8010676d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106770:	5d                   	pop    %ebp
80106771:	c3                   	ret    
80106772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106780 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	56                   	push   %esi
80106785:	53                   	push   %ebx
80106786:	83 ec 1c             	sub    $0x1c,%esp
80106789:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010678c:	85 f6                	test   %esi,%esi
8010678e:	0f 84 cd 00 00 00    	je     80106861 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106794:	8b 46 08             	mov    0x8(%esi),%eax
80106797:	85 c0                	test   %eax,%eax
80106799:	0f 84 dc 00 00 00    	je     8010687b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010679f:	8b 7e 04             	mov    0x4(%esi),%edi
801067a2:	85 ff                	test   %edi,%edi
801067a4:	0f 84 c4 00 00 00    	je     8010686e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801067aa:	e8 11 da ff ff       	call   801041c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801067af:	e8 4c ce ff ff       	call   80103600 <mycpu>
801067b4:	89 c3                	mov    %eax,%ebx
801067b6:	e8 45 ce ff ff       	call   80103600 <mycpu>
801067bb:	89 c7                	mov    %eax,%edi
801067bd:	e8 3e ce ff ff       	call   80103600 <mycpu>
801067c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067c5:	83 c7 08             	add    $0x8,%edi
801067c8:	e8 33 ce ff ff       	call   80103600 <mycpu>
801067cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801067d0:	83 c0 08             	add    $0x8,%eax
801067d3:	ba 67 00 00 00       	mov    $0x67,%edx
801067d8:	c1 e8 18             	shr    $0x18,%eax
801067db:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801067e2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801067e9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801067f0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801067f7:	83 c1 08             	add    $0x8,%ecx
801067fa:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106800:	c1 e9 10             	shr    $0x10,%ecx
80106803:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106809:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010680e:	e8 ed cd ff ff       	call   80103600 <mycpu>
80106813:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010681a:	e8 e1 cd ff ff       	call   80103600 <mycpu>
8010681f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106824:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106828:	e8 d3 cd ff ff       	call   80103600 <mycpu>
8010682d:	8b 56 08             	mov    0x8(%esi),%edx
80106830:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106836:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106839:	e8 c2 cd ff ff       	call   80103600 <mycpu>
8010683e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106842:	b8 28 00 00 00       	mov    $0x28,%eax
80106847:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010684a:	8b 46 04             	mov    0x4(%esi),%eax
8010684d:	05 00 00 00 80       	add    $0x80000000,%eax
80106852:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106855:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106858:	5b                   	pop    %ebx
80106859:	5e                   	pop    %esi
8010685a:	5f                   	pop    %edi
8010685b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010685c:	e9 4f da ff ff       	jmp    801042b0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106861:	83 ec 0c             	sub    $0xc,%esp
80106864:	68 c2 79 10 80       	push   $0x801079c2
80106869:	e8 02 9b ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010686e:	83 ec 0c             	sub    $0xc,%esp
80106871:	68 ed 79 10 80       	push   $0x801079ed
80106876:	e8 f5 9a ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010687b:	83 ec 0c             	sub    $0xc,%esp
8010687e:	68 d8 79 10 80       	push   $0x801079d8
80106883:	e8 e8 9a ff ff       	call   80100370 <panic>
80106888:	90                   	nop
80106889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106890 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	83 ec 1c             	sub    $0x1c,%esp
80106899:	8b 75 10             	mov    0x10(%ebp),%esi
8010689c:	8b 55 08             	mov    0x8(%ebp),%edx
8010689f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801068a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801068a8:	77 50                	ja     801068fa <inituvm+0x6a>
801068aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
801068ad:	e8 fe ba ff ff       	call   801023b0 <kalloc>
  memset(mem, 0, PGSIZE);
801068b2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801068b5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801068b7:	68 00 10 00 00       	push   $0x1000
801068bc:	6a 00                	push   $0x0
801068be:	50                   	push   %eax
801068bf:	e8 ac da ff ff       	call   80104370 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801068c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801068c7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068cd:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801068d4:	50                   	push   %eax
801068d5:	68 00 10 00 00       	push   $0x1000
801068da:	6a 00                	push   $0x0
801068dc:	52                   	push   %edx
801068dd:	e8 ee fd ff ff       	call   801066d0 <mappages>
  memmove(mem, init, sz);
801068e2:	89 75 10             	mov    %esi,0x10(%ebp)
801068e5:	89 7d 0c             	mov    %edi,0xc(%ebp)
801068e8:	83 c4 20             	add    $0x20,%esp
801068eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801068ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f1:	5b                   	pop    %ebx
801068f2:	5e                   	pop    %esi
801068f3:	5f                   	pop    %edi
801068f4:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801068f5:	e9 26 db ff ff       	jmp    80104420 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801068fa:	83 ec 0c             	sub    $0xc,%esp
801068fd:	68 01 7a 10 80       	push   $0x80107a01
80106902:	e8 69 9a ff ff       	call   80100370 <panic>
80106907:	89 f6                	mov    %esi,%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106910 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106919:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106920:	0f 85 91 00 00 00    	jne    801069b7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106926:	8b 75 18             	mov    0x18(%ebp),%esi
80106929:	31 db                	xor    %ebx,%ebx
8010692b:	85 f6                	test   %esi,%esi
8010692d:	75 1a                	jne    80106949 <loaduvm+0x39>
8010692f:	eb 6f                	jmp    801069a0 <loaduvm+0x90>
80106931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106938:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010693e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106944:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106947:	76 57                	jbe    801069a0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106949:	8b 55 0c             	mov    0xc(%ebp),%edx
8010694c:	8b 45 08             	mov    0x8(%ebp),%eax
8010694f:	31 c9                	xor    %ecx,%ecx
80106951:	01 da                	add    %ebx,%edx
80106953:	e8 58 fb ff ff       	call   801064b0 <walkpgdir>
80106958:	85 c0                	test   %eax,%eax
8010695a:	74 4e                	je     801069aa <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010695c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010695e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106961:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010696b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106971:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106974:	01 d9                	add    %ebx,%ecx
80106976:	05 00 00 00 80       	add    $0x80000000,%eax
8010697b:	57                   	push   %edi
8010697c:	51                   	push   %ecx
8010697d:	50                   	push   %eax
8010697e:	ff 75 10             	pushl  0x10(%ebp)
80106981:	e8 ea ae ff ff       	call   80101870 <readi>
80106986:	83 c4 10             	add    $0x10,%esp
80106989:	39 c7                	cmp    %eax,%edi
8010698b:	74 ab                	je     80106938 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010698d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106995:	5b                   	pop    %ebx
80106996:	5e                   	pop    %esi
80106997:	5f                   	pop    %edi
80106998:	5d                   	pop    %ebp
80106999:	c3                   	ret    
8010699a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801069a3:	31 c0                	xor    %eax,%eax
}
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801069aa:	83 ec 0c             	sub    $0xc,%esp
801069ad:	68 1b 7a 10 80       	push   $0x80107a1b
801069b2:	e8 b9 99 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801069b7:	83 ec 0c             	sub    $0xc,%esp
801069ba:	68 f0 7a 10 80       	push   $0x80107af0
801069bf:	e8 ac 99 ff ff       	call   80100370 <panic>
801069c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801069d0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 0c             	sub    $0xc,%esp
801069d9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801069dc:	85 ff                	test   %edi,%edi
801069de:	0f 88 ca 00 00 00    	js     80106aae <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
801069e4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801069e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801069ea:	0f 82 84 00 00 00    	jb     80106a74 <allocuvm+0xa4>
    return oldsz;

  a = PGROUNDUP(oldsz);
801069f0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801069f6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a <= newsz; a += PGSIZE){
801069fc:	39 df                	cmp    %ebx,%edi
801069fe:	73 45                	jae    80106a45 <allocuvm+0x75>
80106a00:	e9 bb 00 00 00       	jmp    80106ac0 <allocuvm+0xf0>
80106a05:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106a08:	83 ec 04             	sub    $0x4,%esp
80106a0b:	68 00 10 00 00       	push   $0x1000
80106a10:	6a 00                	push   $0x0
80106a12:	50                   	push   %eax
80106a13:	e8 58 d9 ff ff       	call   80104370 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a18:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a1e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106a25:	50                   	push   %eax
80106a26:	68 00 10 00 00       	push   $0x1000
80106a2b:	53                   	push   %ebx
80106a2c:	ff 75 08             	pushl  0x8(%ebp)
80106a2f:	e8 9c fc ff ff       	call   801066d0 <mappages>
80106a34:	83 c4 20             	add    $0x20,%esp
80106a37:	85 c0                	test   %eax,%eax
80106a39:	78 45                	js     80106a80 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a <= newsz; a += PGSIZE){
80106a3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a41:	39 df                	cmp    %ebx,%edi
80106a43:	72 7b                	jb     80106ac0 <allocuvm+0xf0>
    mem = kalloc();
80106a45:	e8 66 b9 ff ff       	call   801023b0 <kalloc>
    if(mem == 0){
80106a4a:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a <= newsz; a += PGSIZE){
    mem = kalloc();
80106a4c:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106a4e:	75 b8                	jne    80106a08 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106a50:	83 ec 0c             	sub    $0xc,%esp
80106a53:	68 39 7a 10 80       	push   $0x80107a39
80106a58:	e8 03 9c ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106a5d:	83 c4 10             	add    $0x10,%esp
80106a60:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a63:	76 49                	jbe    80106aae <allocuvm+0xde>
80106a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a68:	8b 45 08             	mov    0x8(%ebp),%eax
80106a6b:	89 fa                	mov    %edi,%edx
80106a6d:	e8 be fa ff ff       	call   80106530 <deallocuvm.part.0>
  for(; a <= newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106a72:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a77:	5b                   	pop    %ebx
80106a78:	5e                   	pop    %esi
80106a79:	5f                   	pop    %edi
80106a7a:	5d                   	pop    %ebp
80106a7b:	c3                   	ret    
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106a80:	83 ec 0c             	sub    $0xc,%esp
80106a83:	68 51 7a 10 80       	push   $0x80107a51
80106a88:	e8 d3 9b ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106a8d:	83 c4 10             	add    $0x10,%esp
80106a90:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a93:	76 0d                	jbe    80106aa2 <allocuvm+0xd2>
80106a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a98:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9b:	89 fa                	mov    %edi,%edx
80106a9d:	e8 8e fa ff ff       	call   80106530 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106aa2:	83 ec 0c             	sub    $0xc,%esp
80106aa5:	56                   	push   %esi
80106aa6:	e8 55 b7 ff ff       	call   80102200 <kfree>
      return 0;
80106aab:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106ab1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106ab3:	5b                   	pop    %ebx
80106ab4:	5e                   	pop    %esi
80106ab5:	5f                   	pop    %edi
80106ab6:	5d                   	pop    %ebp
80106ab7:	c3                   	ret    
80106ab8:	90                   	nop
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a <= newsz; a += PGSIZE){
80106ac3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ad6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106adc:	39 d1                	cmp    %edx,%ecx
80106ade:	73 10                	jae    80106af0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ae0:	5d                   	pop    %ebp
80106ae1:	e9 4a fa ff ff       	jmp    80106530 <deallocuvm.part.0>
80106ae6:	8d 76 00             	lea    0x0(%esi),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106af0:	89 d0                	mov    %edx,%eax
80106af2:	5d                   	pop    %ebp
80106af3:	c3                   	ret    
80106af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 0c             	sub    $0xc,%esp
80106b09:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b0c:	85 f6                	test   %esi,%esi
80106b0e:	74 59                	je     80106b69 <freevm+0x69>
80106b10:	31 c9                	xor    %ecx,%ecx
80106b12:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b17:	89 f0                	mov    %esi,%eax
80106b19:	e8 12 fa ff ff       	call   80106530 <deallocuvm.part.0>
80106b1e:	89 f3                	mov    %esi,%ebx
80106b20:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106b26:	eb 0f                	jmp    80106b37 <freevm+0x37>
80106b28:	90                   	nop
80106b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b30:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b33:	39 fb                	cmp    %edi,%ebx
80106b35:	74 23                	je     80106b5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106b37:	8b 03                	mov    (%ebx),%eax
80106b39:	a8 01                	test   $0x1,%al
80106b3b:	74 f3                	je     80106b30 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106b3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b42:	83 ec 0c             	sub    $0xc,%esp
80106b45:	83 c3 04             	add    $0x4,%ebx
80106b48:	05 00 00 00 80       	add    $0x80000000,%eax
80106b4d:	50                   	push   %eax
80106b4e:	e8 ad b6 ff ff       	call   80102200 <kfree>
80106b53:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106b56:	39 fb                	cmp    %edi,%ebx
80106b58:	75 dd                	jne    80106b37 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106b5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b60:	5b                   	pop    %ebx
80106b61:	5e                   	pop    %esi
80106b62:	5f                   	pop    %edi
80106b63:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106b64:	e9 97 b6 ff ff       	jmp    80102200 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106b69:	83 ec 0c             	sub    $0xc,%esp
80106b6c:	68 6d 7a 10 80       	push   $0x80107a6d
80106b71:	e8 fa 97 ff ff       	call   80100370 <panic>
80106b76:	8d 76 00             	lea    0x0(%esi),%esi
80106b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b80 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	56                   	push   %esi
80106b84:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106b85:	e8 26 b8 ff ff       	call   801023b0 <kalloc>
80106b8a:	85 c0                	test   %eax,%eax
80106b8c:	74 6a                	je     80106bf8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b8e:	83 ec 04             	sub    $0x4,%esp
80106b91:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b93:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106b98:	68 00 10 00 00       	push   $0x1000
80106b9d:	6a 00                	push   $0x0
80106b9f:	50                   	push   %eax
80106ba0:	e8 cb d7 ff ff       	call   80104370 <memset>
80106ba5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ba8:	8b 43 04             	mov    0x4(%ebx),%eax
80106bab:	8b 53 08             	mov    0x8(%ebx),%edx
80106bae:	83 ec 0c             	sub    $0xc,%esp
80106bb1:	ff 73 0c             	pushl  0xc(%ebx)
80106bb4:	29 c2                	sub    %eax,%edx
80106bb6:	50                   	push   %eax
80106bb7:	52                   	push   %edx
80106bb8:	ff 33                	pushl  (%ebx)
80106bba:	56                   	push   %esi
80106bbb:	e8 10 fb ff ff       	call   801066d0 <mappages>
80106bc0:	83 c4 20             	add    $0x20,%esp
80106bc3:	85 c0                	test   %eax,%eax
80106bc5:	78 19                	js     80106be0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106bc7:	83 c3 10             	add    $0x10,%ebx
80106bca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106bd0:	75 d6                	jne    80106ba8 <setupkvm+0x28>
80106bd2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106bd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106bd7:	5b                   	pop    %ebx
80106bd8:	5e                   	pop    %esi
80106bd9:	5d                   	pop    %ebp
80106bda:	c3                   	ret    
80106bdb:	90                   	nop
80106bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106be0:	83 ec 0c             	sub    $0xc,%esp
80106be3:	56                   	push   %esi
80106be4:	e8 17 ff ff ff       	call   80106b00 <freevm>
      return 0;
80106be9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106bec:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106bef:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106bf1:	5b                   	pop    %ebx
80106bf2:	5e                   	pop    %esi
80106bf3:	5d                   	pop    %ebp
80106bf4:	c3                   	ret    
80106bf5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106bf8:	31 c0                	xor    %eax,%eax
80106bfa:	eb d8                	jmp    80106bd4 <setupkvm+0x54>
80106bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c00 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106c06:	e8 75 ff ff ff       	call   80106b80 <setupkvm>
80106c0b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
80106c10:	05 00 00 00 80       	add    $0x80000000,%eax
80106c15:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106c18:	c9                   	leave  
80106c19:	c3                   	ret    
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c21:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c23:	89 e5                	mov    %esp,%ebp
80106c25:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2e:	e8 7d f8 ff ff       	call   801064b0 <walkpgdir>
  if(pte == 0)
80106c33:	85 c0                	test   %eax,%eax
80106c35:	74 05                	je     80106c3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c3a:	c9                   	leave  
80106c3b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106c3c:	83 ec 0c             	sub    $0xc,%esp
80106c3f:	68 7e 7a 10 80       	push   $0x80107a7e
80106c44:	e8 27 97 ff ff       	call   80100370 <panic>
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(struct proc* parent)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte; // pointer we use to check if when we walkpgdir
  // if it is null, then we know we cannot walk the parent pg, so we panic
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106c59:	e8 22 ff ff ff       	call   80106b80 <setupkvm>
80106c5e:	85 c0                	test   %eax,%eax
80106c60:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c63:	0f 84 87 01 00 00    	je     80106df0 <copyuvm+0x1a0>
    return 0;
  for(i = 0; i < parent->sz; i += PGSIZE){
80106c69:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6c:	8b 08                	mov    (%eax),%ecx
80106c6e:	85 c9                	test   %ecx,%ecx
80106c70:	0f 84 aa 00 00 00    	je     80106d20 <copyuvm+0xd0>
80106c76:	31 f6                	xor    %esi,%esi
80106c78:	89 c7                	mov    %eax,%edi
80106c7a:	eb 45                	jmp    80106cc1 <copyuvm+0x71>
80106c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c83:	83 ec 04             	sub    $0x4,%esp
80106c86:	68 00 10 00 00       	push   $0x1000
80106c8b:	05 00 00 00 80       	add    $0x80000000,%eax
80106c90:	50                   	push   %eax
80106c91:	53                   	push   %ebx
80106c92:	e8 89 d7 ff ff       	call   80104420 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106c97:	5a                   	pop    %edx
80106c98:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106c9e:	ff 75 e0             	pushl  -0x20(%ebp)
80106ca1:	52                   	push   %edx
80106ca2:	68 00 10 00 00       	push   $0x1000
80106ca7:	56                   	push   %esi
80106ca8:	ff 75 dc             	pushl  -0x24(%ebp)
80106cab:	e8 20 fa ff ff       	call   801066d0 <mappages>
80106cb0:	83 c4 20             	add    $0x20,%esp
80106cb3:	85 c0                	test   %eax,%eax
80106cb5:	78 47                	js     80106cfe <copyuvm+0xae>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < parent->sz; i += PGSIZE){
80106cb7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106cbd:	39 37                	cmp    %esi,(%edi)
80106cbf:	76 5f                	jbe    80106d20 <copyuvm+0xd0>
    if((pte = walkpgdir(parent->pgdir, (void *) i, 0)) == 0)
80106cc1:	8b 47 04             	mov    0x4(%edi),%eax
80106cc4:	31 c9                	xor    %ecx,%ecx
80106cc6:	89 f2                	mov    %esi,%edx
80106cc8:	e8 e3 f7 ff ff       	call   801064b0 <walkpgdir>
80106ccd:	85 c0                	test   %eax,%eax
80106ccf:	0f 84 40 01 00 00    	je     80106e15 <copyuvm+0x1c5>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P)) {
80106cd5:	8b 18                	mov    (%eax),%ebx
80106cd7:	f6 c3 01             	test   $0x1,%bl
80106cda:	0f 84 17 01 00 00    	je     80106df7 <copyuvm+0x1a7>
      cprintf("%x", parent->sz);
      panic("copyuvm: page not present");
    }
    pa = PTE_ADDR(*pte);
80106ce0:	89 d8                	mov    %ebx,%eax
    flags = PTE_FLAGS(*pte);
80106ce2:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P)) {
      cprintf("%x", parent->sz);
      panic("copyuvm: page not present");
    }
    pa = PTE_ADDR(*pte);
80106ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    flags = PTE_FLAGS(*pte);
80106ced:	89 5d e0             	mov    %ebx,-0x20(%ebp)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P)) {
      cprintf("%x", parent->sz);
      panic("copyuvm: page not present");
    }
    pa = PTE_ADDR(*pte);
80106cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106cf3:	e8 b8 b6 ff ff       	call   801023b0 <kalloc>
80106cf8:	85 c0                	test   %eax,%eax
80106cfa:	89 c3                	mov    %eax,%ebx
80106cfc:	75 82                	jne    80106c80 <copyuvm+0x30>
  }
  return d;
  */

bad:
  freevm(d);
80106cfe:	83 ec 0c             	sub    $0xc,%esp
80106d01:	ff 75 dc             	pushl  -0x24(%ebp)
80106d04:	e8 f7 fd ff ff       	call   80106b00 <freevm>
  return 0;
80106d09:	83 c4 10             	add    $0x10,%esp
80106d0c:	31 c0                	xor    %eax,%eax
}
80106d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d11:	5b                   	pop    %ebx
80106d12:	5e                   	pop    %esi
80106d13:	5f                   	pop    %edi
80106d14:	5d                   	pop    %ebp
80106d15:	c3                   	ret    
80106d16:	8d 76 00             	lea    0x0(%esi),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < parent->sz; i += PGSIZE){
80106d20:	bf 00 f0 ff 7f       	mov    $0x7ffff000,%edi
80106d25:	31 db                	xor    %ebx,%ebx
80106d27:	8b 75 08             	mov    0x8(%ebp),%esi
80106d2a:	e9 83 00 00 00       	jmp    80106db2 <copyuvm+0x162>
80106d2f:	90                   	nop

  //Second Loop
    for (int i = 0; i < parent->pages; i++) {
      //Checks if a PTE is found
      uint page = STACKBASE - ((PGSIZE-1)*(i+1));
      if ((pte = walkpgdir(parent->pgdir, (void *)page, 0)) == 0)
80106d30:	8b 46 04             	mov    0x4(%esi),%eax
80106d33:	31 c9                	xor    %ecx,%ecx
80106d35:	89 fa                	mov    %edi,%edx
  }

  //Second Loop
    for (int i = 0; i < parent->pages; i++) {
      //Checks if a PTE is found
      uint page = STACKBASE - ((PGSIZE-1)*(i+1));
80106d37:	83 c3 01             	add    $0x1,%ebx
      if ((pte = walkpgdir(parent->pgdir, (void *)page, 0)) == 0)
80106d3a:	e8 71 f7 ff ff       	call   801064b0 <walkpgdir>
80106d3f:	85 c0                	test   %eax,%eax
80106d41:	0f 84 db 00 00 00    	je     80106e22 <copyuvm+0x1d2>
        panic("copyuvm: pte not found");
      // Checks if PTE_P is found
      if (!(*pte & PTE_P)){
80106d47:	8b 00                	mov    (%eax),%eax
80106d49:	a8 01                	test   $0x1,%al
80106d4b:	0f 84 de 00 00 00    	je     80106e2f <copyuvm+0x1df>
        cprintf("%x", page);
        panic("copyuvm: pte_p not found");
      }
      pa = PTE_ADDR(*pte);
80106d51:	89 c1                	mov    %eax,%ecx
      flags = PTE_FLAGS(*pte);
80106d53:	25 ff 0f 00 00       	and    $0xfff,%eax
      // Checks if PTE_P is found
      if (!(*pte & PTE_P)){
        cprintf("%x", page);
        panic("copyuvm: pte_p not found");
      }
      pa = PTE_ADDR(*pte);
80106d58:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
      flags = PTE_FLAGS(*pte);
80106d5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      // Checks if PTE_P is found
      if (!(*pte & PTE_P)){
        cprintf("%x", page);
        panic("copyuvm: pte_p not found");
      }
      pa = PTE_ADDR(*pte);
80106d61:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      flags = PTE_FLAGS(*pte);
      // kalloc() finding a page and checking
      //mem = kalloc();
      if ((mem =kalloc())  == 0) {
80106d64:	e8 47 b6 ff ff       	call   801023b0 <kalloc>
80106d69:	85 c0                	test   %eax,%eax
80106d6b:	89 c2                	mov    %eax,%edx
80106d6d:	74 57                	je     80106dc6 <copyuvm+0x176>
        cprintf("copyuvm: kalloc() didn't find a page");
        goto bad;
      }
      // mappages()
      memmove(mem, (void *)P2V(pa), PGSIZE);
80106d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d72:	83 ec 04             	sub    $0x4,%esp
80106d75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d78:	68 00 10 00 00       	push   $0x1000
80106d7d:	05 00 00 00 80       	add    $0x80000000,%eax
80106d82:	50                   	push   %eax
80106d83:	52                   	push   %edx
80106d84:	e8 97 d6 ff ff       	call   80104420 <memmove>
      if (mappages(d, (void *)page, PGSIZE, V2P(mem), flags) < 0) {
80106d89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d8c:	58                   	pop    %eax
80106d8d:	ff 75 e0             	pushl  -0x20(%ebp)
80106d90:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d96:	52                   	push   %edx
80106d97:	68 00 10 00 00       	push   $0x1000
80106d9c:	57                   	push   %edi
80106d9d:	ff 75 dc             	pushl  -0x24(%ebp)
80106da0:	81 ef ff 0f 00 00    	sub    $0xfff,%edi
80106da6:	e8 25 f9 ff ff       	call   801066d0 <mappages>
80106dab:	83 c4 20             	add    $0x20,%esp
80106dae:	85 c0                	test   %eax,%eax
80106db0:	78 29                	js     80106ddb <copyuvm+0x18b>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  //Second Loop
    for (int i = 0; i < parent->pages; i++) {
80106db2:	3b 5e 7c             	cmp    0x7c(%esi),%ebx
80106db5:	0f 8c 75 ff ff ff    	jl     80106d30 <copyuvm+0xe0>
80106dbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  */

bad:
  freevm(d);
  return 0;
}
80106dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dc1:	5b                   	pop    %ebx
80106dc2:	5e                   	pop    %esi
80106dc3:	5f                   	pop    %edi
80106dc4:	5d                   	pop    %ebp
80106dc5:	c3                   	ret    
      pa = PTE_ADDR(*pte);
      flags = PTE_FLAGS(*pte);
      // kalloc() finding a page and checking
      //mem = kalloc();
      if ((mem =kalloc())  == 0) {
        cprintf("copyuvm: kalloc() didn't find a page");
80106dc6:	83 ec 0c             	sub    $0xc,%esp
80106dc9:	68 14 7b 10 80       	push   $0x80107b14
80106dce:	e8 8d 98 ff ff       	call   80100660 <cprintf>
        goto bad;
80106dd3:	83 c4 10             	add    $0x10,%esp
80106dd6:	e9 23 ff ff ff       	jmp    80106cfe <copyuvm+0xae>
      }
      // mappages()
      memmove(mem, (void *)P2V(pa), PGSIZE);
      if (mappages(d, (void *)page, PGSIZE, V2P(mem), flags) < 0) {
        cprintf("copyuvm: mappages() doesn't map correctly");
80106ddb:	83 ec 0c             	sub    $0xc,%esp
80106dde:	68 3c 7b 10 80       	push   $0x80107b3c
80106de3:	e8 78 98 ff ff       	call   80100660 <cprintf>
        goto bad;
80106de8:	83 c4 10             	add    $0x10,%esp
80106deb:	e9 0e ff ff ff       	jmp    80106cfe <copyuvm+0xae>
  // if it is null, then we know we cannot walk the parent pg, so we panic
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106df0:	31 c0                	xor    %eax,%eax
80106df2:	e9 17 ff ff ff       	jmp    80106d0e <copyuvm+0xbe>
  for(i = 0; i < parent->sz; i += PGSIZE){
    if((pte = walkpgdir(parent->pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P)) {
      cprintf("%x", parent->sz);
80106df7:	8b 45 08             	mov    0x8(%ebp),%eax
80106dfa:	83 ec 08             	sub    $0x8,%esp
80106dfd:	ff 30                	pushl  (%eax)
80106dff:	68 a2 7a 10 80       	push   $0x80107aa2
80106e04:	e8 57 98 ff ff       	call   80100660 <cprintf>
      panic("copyuvm: page not present");
80106e09:	c7 04 24 a5 7a 10 80 	movl   $0x80107aa5,(%esp)
80106e10:	e8 5b 95 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < parent->sz; i += PGSIZE){
    if((pte = walkpgdir(parent->pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106e15:	83 ec 0c             	sub    $0xc,%esp
80106e18:	68 88 7a 10 80       	push   $0x80107a88
80106e1d:	e8 4e 95 ff ff       	call   80100370 <panic>
  //Second Loop
    for (int i = 0; i < parent->pages; i++) {
      //Checks if a PTE is found
      uint page = STACKBASE - ((PGSIZE-1)*(i+1));
      if ((pte = walkpgdir(parent->pgdir, (void *)page, 0)) == 0)
        panic("copyuvm: pte not found");
80106e22:	83 ec 0c             	sub    $0xc,%esp
80106e25:	68 bf 7a 10 80       	push   $0x80107abf
80106e2a:	e8 41 95 ff ff       	call   80100370 <panic>
      // Checks if PTE_P is found
      if (!(*pte & PTE_P)){
        cprintf("%x", page);
80106e2f:	83 ec 08             	sub    $0x8,%esp
80106e32:	57                   	push   %edi
80106e33:	68 a2 7a 10 80       	push   $0x80107aa2
80106e38:	e8 23 98 ff ff       	call   80100660 <cprintf>
        panic("copyuvm: pte_p not found");
80106e3d:	c7 04 24 d6 7a 10 80 	movl   $0x80107ad6,(%esp)
80106e44:	e8 27 95 ff ff       	call   80100370 <panic>
80106e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e51:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e53:	89 e5                	mov    %esp,%ebp
80106e55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e5e:	e8 4d f6 ff ff       	call   801064b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106e63:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106e65:	89 c2                	mov    %eax,%edx
80106e67:	83 e2 05             	and    $0x5,%edx
80106e6a:	83 fa 05             	cmp    $0x5,%edx
80106e6d:	75 11                	jne    80106e80 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106e6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106e74:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106e75:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106e7a:	c3                   	ret    
80106e7b:	90                   	nop
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106e80:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106e82:	c9                   	leave  
80106e83:	c3                   	ret    
80106e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
80106e99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ea2:	85 db                	test   %ebx,%ebx
80106ea4:	75 40                	jne    80106ee6 <copyout+0x56>
80106ea6:	eb 70                	jmp    80106f18 <copyout+0x88>
80106ea8:	90                   	nop
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106eb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106eb3:	89 f1                	mov    %esi,%ecx
80106eb5:	29 d1                	sub    %edx,%ecx
80106eb7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106ebd:	39 d9                	cmp    %ebx,%ecx
80106ebf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ec2:	29 f2                	sub    %esi,%edx
80106ec4:	83 ec 04             	sub    $0x4,%esp
80106ec7:	01 d0                	add    %edx,%eax
80106ec9:	51                   	push   %ecx
80106eca:	57                   	push   %edi
80106ecb:	50                   	push   %eax
80106ecc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106ecf:	e8 4c d5 ff ff       	call   80104420 <memmove>
    len -= n;
    buf += n;
80106ed4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ed7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106eda:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106ee0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ee2:	29 cb                	sub    %ecx,%ebx
80106ee4:	74 32                	je     80106f18 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106ee6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ee8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106eeb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106eee:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ef4:	56                   	push   %esi
80106ef5:	ff 75 08             	pushl  0x8(%ebp)
80106ef8:	e8 53 ff ff ff       	call   80106e50 <uva2ka>
    if(pa0 == 0)
80106efd:	83 c4 10             	add    $0x10,%esp
80106f00:	85 c0                	test   %eax,%eax
80106f02:	75 ac                	jne    80106eb0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f0c:	5b                   	pop    %ebx
80106f0d:	5e                   	pop    %esi
80106f0e:	5f                   	pop    %edi
80106f0f:	5d                   	pop    %ebp
80106f10:	c3                   	ret    
80106f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106f1b:	31 c0                	xor    %eax,%eax
}
80106f1d:	5b                   	pop    %ebx
80106f1e:	5e                   	pop    %esi
80106f1f:	5f                   	pop    %edi
80106f20:	5d                   	pop    %ebp
80106f21:	c3                   	ret    
80106f22:	66 90                	xchg   %ax,%ax
80106f24:	66 90                	xchg   %ax,%ax
80106f26:	66 90                	xchg   %ax,%ax
80106f28:	66 90                	xchg   %ax,%ax
80106f2a:	66 90                	xchg   %ax,%ax
80106f2c:	66 90                	xchg   %ax,%ax
80106f2e:	66 90                	xchg   %ax,%ax

80106f30 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106f36:	68 68 7b 10 80       	push   $0x80107b68
80106f3b:	68 c0 55 11 80       	push   $0x801155c0
80106f40:	e8 bb d1 ff ff       	call   80104100 <initlock>
  acquire(&(shm_table.lock));
80106f45:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106f4c:	e8 af d2 ff ff       	call   80104200 <acquire>
80106f51:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106f56:	83 c4 10             	add    $0x10,%esp
80106f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106f60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
80106f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80106f6d:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].refcnt =0;
80106f70:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80106f77:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106f7c:	75 e2                	jne    80106f60 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
80106f7e:	83 ec 0c             	sub    $0xc,%esp
80106f81:	68 c0 55 11 80       	push   $0x801155c0
80106f86:	e8 95 d3 ff ff       	call   80104320 <release>
}
80106f8b:	83 c4 10             	add    $0x10,%esp
80106f8e:	c9                   	leave  
80106f8f:	c3                   	ret    

80106f90 <shm_open>:

int shm_open(int id, char **pointer) {
80106f90:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106f91:	31 c0                	xor    %eax,%eax
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
80106f93:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106f95:	5d                   	pop    %ebp
80106f96:	c3                   	ret    
80106f97:	89 f6                	mov    %esi,%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <shm_close>:


int shm_close(int id) {
80106fa0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106fa1:	31 c0                	xor    %eax,%eax

return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
80106fa3:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106fa5:	5d                   	pop    %ebp
80106fa6:	c3                   	ret    
