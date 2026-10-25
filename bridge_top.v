// module bridge_top(input hclk,
//                   input hresetn,
//                   input hwrite,
//                   input hreadyin,
//                   input [1:0] htrans,
//                   input [31:0] hwdata,
//                   input [31:0] haddr,
//                   input [31:0] prdata,
//                   output penable,
//                   output pwrite,
//                   output hr_readyout,
//                   output [2:0] psel,
//                   output [1:0] hresp,
//                   output [31:0] paddr,
//                   output [31:0] pwdata,
//                   output [31:0] hrdata);
  
// //intermediate signals                
// wire [31:0] hwdata1, hwdata2, haddr1, hadddr2;
// wire [2:0]temp_sel;
// wire hwrite_reg, hwrite_reg1;
// wire valid;

// //instantiating AHB Slave Interface
// ahb_slave_interface AHBS(hclk,hresetn,hwrite,hreadyin,hwdata,haddr,prdata,htrans,hrdata,haddr1,haddr2,hwdata1,hwdata2,hwrite_reg,hwrite_reg1,valid,temp_selx);

// //instantiating APB Controller
// apb_controller APBC(hclk,hresetn,hwrite,hwrite_reg,valid,haddr,haddr1,haddr2,hwdata,hwdata1,hwdata2,prdata,tempselx,pwrite,penable,hr_readyout,psel,paddr,pwdata);

// endmodule

// module bridge_top(input hclk,
//                   input hresetn,
//                   input hwrite,
//                   input hreadyin,
//                   input [1:0] htrans,
//                   input [31:0] hwdata,
//                   input [31:0] haddr,
//                   input [31:0] prdata,
//                   output penable,
//                   output pwrite,
//                   output hr_readyout,
//                   output [2:0] psel,
//                   output [1:0] hresp,
//                   output [31:0] paddr,
//                   output [31:0] pwdata,
//                   output [31:0] hrdata);
  
// //intermediate signals                
// wire [31:0] hwdata1, hwdata2, haddr1, hadddr2;
// wire [2:0]temp_sel;
// wire hwrite_reg, hwrite_reg1;
// wire valid;

// //instantiating AHB Slave Interface
// ahb_slave_interface AHBS(hclk,hresetn,hwrite,hreadyin,hwdata,haddr,prdata,htrans,hrdata,haddr1,haddr2,hwdata1,hwdata2,hwrite_reg,hwrite_reg1,valid,temp_selx);

// //instantiating APB Controller
// apb_controller APBC(hclk,hresetn,hwrite,hwrite_reg,valid,haddr,haddr1,haddr2,hwdata,hwdata1,hwdata2,prdata,tempselx,pwrite,penable,hr_readyout,psel,paddr,pwdata);

// endmodule


module bridge_top(
input hclk,
input hresetn,
input hwrite,
input hreadyin,
input [1:0] htrans,
input [31:0] hwdata,
input [31:0] haddr,
input [31:0] prdata,

output penable,
output pwrite,
output hr_readyout,
output [2:0] psel,
output [1:0] hresp,
output [31:0] paddr,
output [31:0] pwdata,
output [31:0] hrdata
);

//================ INTERNAL =================//

wire [31:0] hwdata1, hwdata2;
wire [31:0] haddr1, haddr2;
wire [2:0] temp_selx;

wire hwrite_reg, hwrite_reg1;
wire valid;

//================ AHB SLAVE =================//

ahb_slave_interface AHBS(
hclk,hresetn,hwrite,hreadyin,
hwdata,haddr,prdata,htrans,
hrdata,
haddr1,haddr2,
hwdata1,hwdata2,
hwrite_reg,hwrite_reg1,
valid,temp_selx
);

//================ APB CONTROLLER =================//

apb_controller APBC(
hclk,hresetn,
hwrite,hwrite_reg,
valid,
haddr,haddr1,haddr2,
hwdata,hwdata1,hwdata2,
prdata,
temp_selx,
pwrite,penable,
hr_readyout,
psel,
paddr,pwdata
);

endmodule