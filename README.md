# Asynchronous_Fifo


FIFOs are often used to safely pass data from one clock domain to another asynchronous clock domain. Using a
FIFO to pass data from one clock domain to another clock domain requires multi-asynchronous clock design
techniques.



## The block diagram for FIFO style

![alt text](https://github.com/Randomguywithamoustache/Asynchronous_Fifo/blob/main/async_fifo.png)


## Pointers design

The write pointer always points to the next word to be written; therefore, on reset, both pointers are set to zero, which also happens to be the next FIFO word location to be written. The read pointer always points to the current FIFO word to be read. Again on reset, both pointers are resetto zero, the FIFO is empty and the read pointer is pointing to invalid data. To resolve metastability problems, we make use use of gray coding, since only one bit changes at a time. While we are sending data to the other clock domain, we need synchronizers, which are designd in the code as 2 fp flps. There are various modules in the code which perform various function, like checking empty or full condition of the fifo, pointers synchronization, fifo memory etc.

##Various modules working

fifo1.v -  This is the top-level wrapper-module that includes all clock domains. The top module is only used as a wrapper to instantiate all of the other FIFO modules used in thedesign.

fifomem.v - this is the FIFO memory buffer that is accessed by both the write and read clock domains. This buffer is most likely an instantiated, synchronous dual-port RAM.

sync_r2w.v - This is a synchronizer module that is used to synchronize the read pointer into the write-clock domain module.

sync_w2r.v -  This is a synchronizer module that is used to synchronize the write pointer into the read-clock domain.

rptr_empty.v - This module is completely synchronous to the read-clock domain and contains the FIFO read pointer and empty-flag logic.

wptr_full.v - this module is completely synchronous to the write-clock domain and contains the FIFO write pointer and full-flag logic.


## Simulation reslts


