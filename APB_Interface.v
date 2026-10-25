module apb_interface(input pwrite,
                     input penable,
                     input [2:0]psel, 
                     input [31:0]paddr,
                     input [31:0]pwdata, 
                     output pwrite_out,
                     output penable_out,
                     output [2:0]psel_out,
                     output [31:0]paddr_out,
                     output [31:0]pwdata_out,
                     output reg [31:0]prdata);
                     
 
assign psel_out = psel;
assign paddr_out = paddr;                    
assign pwrite_out = pwrite;
assign penable_out = penable;
assign pwdata_out = pwdata;

always@(*)
   begin
   if(!pwrite&&penable)
      prdata=($random)%256;
   else
      prdata=32'h0;
   end
endmodule