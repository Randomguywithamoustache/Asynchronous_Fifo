module tb_fifo1();

wire [7:0] rdata;
wire wfull;
wire rempty;
reg [7:0] wdata;
reg winc;
reg wclk;
reg wrst_n;
reg rinc;
reg rclk;
reg rrst_n;

integer i;
initial 
begin
 wclk = 1'b0;
 rclk = 1'b0;
 wrst_n = 1'b0;
 rrst_n = 1'b0;
 rinc =1'b0;
 # 10 winc= 1'b1;
 #10 wrst_n = 1'b1;
 rrst_n = 1'b1;
 
 #200 rinc = 1'b1;
 end
 

  

 always #5 wclk = ~wclk;
 
 always #10 rclk = ~rclk;
 
initial
begin

 for(i=1;i<=8;i=i+1)
 begin
   
    #15 wdata= 5*i;
 end
 end
 
 always 
 begin
 #1500 $stop;
 end
 

fifo1 DUT (.rdata(rdata),.wfull(wfull),.rempty(rempty),.wdata(wdata),
.winc(winc), .wclk(wclk), .wrst_n(wrst_n),.rinc(rinc), .rclk(rclk), .rrst_n(rrst_n));

 
 endmodule




