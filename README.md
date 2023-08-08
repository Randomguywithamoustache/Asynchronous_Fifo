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

![alt text](https://github.com/Randomguywithamoustache/Asynchronous_Fifo/blob/main/modelsim_screenshot.png)

Here the depth of fifo is 8, that is, there are 8 locations to be stored, from where the data will be read in the other clock domain.We need to employ an asynchronous FIFO between two modules working at  different clock domains when some amount of data has to be transmitted from one module to  the other to avoid the data loss. FIFO is required, only when you are slow at reading and fast in  writing to buffer the data which is not read by the slower module. 

The depth (size) of the FIFO should be in such a way that, the FIFO can store all the  data which is not read by the slower module. FIFO will only work if the data comes in bursts; 
we can't have continuous data in and out. If there is a continuous flow of data, then the size of the FIFO required should be infinite.

###  Generating empty condition
The Gray code write pointer must be synchronized into the read-clock domain through a pair of synchronizer registers found in the sync_w2r module. Since only one bit changes at a time using a Gray code pointer, there isno problem synchronizing multi-bit transitions between clock domains.In order to efficiently register the rempty output, the synchronized write pointer is actually compared against the rgraynext (the next Gray code that will be registered into the rptr). The empty value testing and the
accompanying sequential always block has been extracted from the rptr_empty.v


###  Generating full condition

In order to efficiently register the wfull output, the synchronized read pointer is actually compared against the wgnext (the next Gray code that will be registered in the wptr).

### Results interpretation

There are 8 address locations where data can be written into the FIFO, it will bw filled only when the w_rstn is enabled, w-inc is enabled and there is positive edge of the clock.
ehwn all the conditions are met, data is sent into the burst of 8 locations, which are written into the fifo.when all the loaction are filled w_inc is left at '1', and the clock waits for the r_inc and r_rstn to be enabled. therse are enabled at the appropriate time into the testbench.

We can observe when the fifo is full, that is, all addresses are written then w_full flag goes high.

When we start reading from the fifo, (r_inc and r_rstn are enbled), at each r_clk, w_full flag goes low and one more data is written into the fifo(since one data is read).

