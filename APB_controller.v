module apb_controller(
    input hclk,
    input hresetn, 
    input hwrite, 
    input hwrite_reg, 
    input valid,
    input [31:0] haddr,
    input [31:0] haddr1,
    input [31:0] haddr2,
    input [31:0] hwdata,
    input [31:0] hwdata1,
    input [31:0] hwdata2,
    input [31:0] prdata,
    input [2:0] tempselx,
    output reg pwrite,
    output reg penable,
    output reg hr_readyout,
    output reg [2:0] psel,
    output reg [31:0] paddr,
    output reg [31:0] pwdata
);

// state register
parameter idle=3'b000, read=3'b001, renable=3'b010, wwait=3'b011, write=3'b100, wenable=3'b101, writep=3'b110, wenablep=3'b111;

reg [2:0] present, next;

// temporary output registers
reg penable_temp, pwrite_temp, hr_readyout_temp;
reg [2:0] psel_temp;
reg [31:0] paddr_temp, pwdata_temp;

// present state logic
always @(posedge hclk)
begin
    if (!hresetn)
        present <= idle;
    else
        present <= next;
end

// next-state logic
always @(*)
begin
    next = idle;
    case (present)

        idle: begin
            if(valid==1 && hwrite==1)
                next = wwait;
            else if(valid==1 && hwrite==0)
                next = read;
            else
                next = idle;
        end

        read: next = renable;

        renable: begin
            if(valid==1 && hwrite==1)
                next = wwait;
            else if(valid==1 && hwrite==0)
                next = read;
            else
                next = idle;
        end

        wwait: begin
            if(valid==0)
                next = write;
            else
                next = writep;
        end

        write: begin
            if(valid==0)
                next = wenable;
            else
                next = wenablep;
        end

        wenable: begin
            if(valid==1 && hwrite==1)
                next = wwait;
            else if(valid==1 && hwrite==0)
                next = read;
            else
                next = idle;
        end

        writep: next = wenablep;

        wenablep: begin
            if(valid==1 && hwrite_reg==1)
                next = writep;
            else if(valid==0 && hwrite_reg==1)
                next = write;
            else
                next = read;
        end

    endcase
end

// temporary output logic
always @(*)
begin
    case (present)

        idle: begin
            if(valid==1 && hwrite==0) begin
                paddr_temp = haddr;
                pwrite_temp = hwrite;
                psel_temp = tempselx;
                penable_temp = 0;
                hr_readyout_temp = 0;
            end
            else if(valid==1 && hwrite==1) begin
                psel_temp = 0;
                penable_temp = 0;
                hr_readyout_temp = 1;
            end
            else begin
                psel_temp = 0;
                penable_temp = 0;
                hr_readyout_temp = 1;
            end
        end

        read: begin
            penable_temp = 1;
            hr_readyout_temp = 1;
        end

        renable: begin
            if(valid==1 && hwrite==0) begin
                paddr_temp = haddr;
                pwrite_temp = hwrite;
                psel_temp = tempselx;
                penable_temp = 0;
                hr_readyout_temp = 0;
            end
            else if(valid==1 && hwrite==1) begin
                psel_temp = 0;
                penable_temp = 0;
                hr_readyout_temp = 1;
            end
            else begin
                psel_temp = 0;
                penable_temp = 0;
                hr_readyout_temp = 1;
            end
        end

        wwait: begin
            paddr_temp = haddr1;
            pwdata_temp = hwdata;
            pwrite_temp = hwrite;
            psel_temp = tempselx;
            penable_temp = 0;
            hr_readyout_temp = 0;
        end

        write: begin
            penable_temp = 1;
            hr_readyout_temp = 1;
        end

        wenable: begin
            if(valid==1 && hwrite==0) begin
                hr_readyout_temp = 1;
                psel_temp = 0;
                penable_temp = 0;
            end
            else if(valid==1 && hwrite==0) begin
                paddr_temp = haddr1;
                pwrite_temp = hwrite_reg;
                psel_temp = tempselx;
                penable_temp = 0;
                hr_readyout_temp = 0;
            end
            else begin
                hr_readyout_temp = 1;
                psel_temp = 0;
                penable_temp = 0;
            end
        end

        writep: begin
            penable_temp = 1;
            hr_readyout_temp = 1;
        end

        wenablep: begin
            paddr_temp = haddr1;
            pwdata_temp = hwdata;
            pwrite_temp = hwrite;
            psel_temp = tempselx;
            penable_temp = 0;
            hr_readyout_temp = 0;
        end

    endcase
end

// registered outputs
always @(posedge hclk)
begin
    if (!hresetn) begin
        paddr <= 0;
        pwdata <= 0;
        pwrite <= 0;
        psel <= 0;
        penable <= 0;
        hr_readyout <= 1;
    end
    else begin
        paddr <= paddr_temp;
        pwdata <= pwdata_temp;
        pwrite <= pwrite_temp;
        psel <= psel_temp;
        penable <= penable_temp;
        hr_readyout <= hr_readyout_temp;
    end
end

endmodule




// module apb_controller(
//     input hclk,
//     input hresetn, 
//     input hwrite, 
//     input hwrite_reg, 
//     input valid,
//     input [31:0] haddr,
//     input [31:0] haddr1,
//     input [31:0] haddr2,
//     input [31:0] hwdata,
//     input [31:0] hwdata1,
//     input [31:0] hwdata2,
//     input [31:0] prdata,
//     input [2:0] tempselx,
//     output reg pwrite,
//     output reg penable,
//     output reg hr_readyout,
//     output reg [2:0] psel,
//     output reg [31:0] paddr,
//     output reg [31:0] pwdata
// );

// // state register
// parameter idle=3'b000, read=3'b001, renable=3'b010, wwait=3'b011, write=3'b100, wenable=3'b101, writep=3'b110, wenablep=3'b111;

// reg [2:0] present, next;

// // temporary output registers
// reg penable_temp, pwrite_temp, hr_readyout_temp;
// reg [2:0] psel_temp;
// reg [31:0] paddr_temp, pwdata_temp;

// // present state logic
// always @(posedge hclk)
// begin
//     if (!hresetn)
//         present <= idle;
//     else
//         present <= next;
// end

// // next-state logic
// always @(*)
// begin
//     next = idle;
//     case (present)

//         idle: begin
//             if(valid==1 && hwrite==1)
//                 next = wwait;
//             else if(valid==1 && hwrite==0)
//                 next = read;
//             else
//                 next = idle;
//         end

//         read: next = renable;

//         renable: begin
//             if(valid==1 && hwrite==1)
//                 next = wwait;
//             else if(valid==1 && hwrite==0)
//                 next = read;
//             else
//                 next = idle;
//         end

//         wwait: begin
//             if(valid==0)
//                 next = write;
//             else
//                 next = writep;
//         end

//         write: begin
//             if(valid==0)
//                 next = wenable;
//             else
//                 next = wenablep;
//         end

//         wenable: begin
//             if(valid==1 && hwrite==1)
//                 next = wwait;
//             else if(valid==1 && hwrite==0)
//                 next = read;
//             else
//                 next = idle;
//         end

//         writep: next = wenablep;

//         wenablep: begin
//             if(valid==1 && hwrite_reg==1)
//                 next = writep;
//             else if(valid==0 && hwrite_reg==1)
//                 next = write;
//             else
//                 next = read;
//         end

//     endcase
// end

// // temporary output logic
// always @(*)
// begin
//     case (present)

//         idle: begin
//             if(valid==1 && hwrite==0) begin
//                 paddr_temp = haddr;
//                 pwrite_temp = hwrite;
//                 psel_temp = tempselx;
//                 penable_temp = 0;
//                 hr_readyout_temp = 0;
//             end
//             else if(valid==1 && hwrite==1) begin
//                 psel_temp = 0;
//                 penable_temp = 0;
//                 hr_readyout_temp = 1;
//             end
//             else begin
//                 psel_temp = 0;
//                 penable_temp = 0;
//                 hr_readyout_temp = 1;
//             end
//         end

//         read: begin
//             penable_temp = 1;
//             hr_readyout_temp = 1;
//         end

//         renable: begin
//             if(valid==1 && hwrite==0) begin
//                 paddr_temp = haddr;
//                 pwrite_temp = hwrite;
//                 psel_temp = tempselx;
//                 penable_temp = 0;
//                 hr_readyout_temp = 0;
//             end
//             else if(valid==1 && hwrite==1) begin
//                 psel_temp = 0;
//                 penable_temp = 0;
//                 hr_readyout_temp = 1;
//             end
//             else begin
//                 psel_temp = 0;
//                 penable_temp = 0;
//                 hr_readyout_temp = 1;
//             end
//         end

//         wwait: begin
//             paddr_temp = haddr1;
//             pwdata_temp = hwdata;
//             pwrite_temp = hwrite;
//             psel_temp = tempselx;
//             penable_temp = 0;
//             hr_readyout_temp = 0;
//         end

//         write: begin
//             penable_temp = 1;
//             hr_readyout_temp = 1;
//         end

//         wenable: begin
//             if(valid==1 && hwrite==0) begin
//                 hr_readyout_temp = 1;
//                 psel_temp = 0;
//                 penable_temp = 0;
//             end
//             else if(valid==1 && hwrite==0) begin
//                 paddr_temp = haddr1;
//                 pwrite_temp = hwrite_reg;
//                 psel_temp = tempselx;
//                 penable_temp = 0;
//                 hr_readyout_temp = 0;
//             end
//             else begin
//                 hr_readyout_temp = 1;
//                 psel_temp = 0;
//                 penable_temp = 0;
//             end
//         end

//         writep: begin
//             penable_temp = 1;
//             hr_readyout_temp = 1;
//         end

//         wenablep: begin
//             paddr_temp = haddr1;
//             pwdata_temp = hwdata;
//             pwrite_temp = hwrite;
//             psel_temp = tempselx;
//             penable_temp = 0;
//             hr_readyout_temp = 0;
//         end

//     endcase
// end

// // registered outputs
// always @(posedge hclk)
// begin
//     if (!hresetn) begin
//         paddr <= 0;
//         pwdata <= 0;
//         pwrite <= 0;
//         psel <= 0;
//         penable <= 0;
//         hr_readyout <= 1;
//     end
//     else begin
//         paddr <= paddr_temp;
//         pwdata <= pwdata_temp;
//         pwrite <= pwrite_temp;
//         psel <= psel_temp;
//         penable <= penable_temp;
//         hr_readyout <= hr_readyout_temp;
//     end
// end

// endmodule
// module apb_controller(
//     input hclk,
//     input hresetn, 
//     input hwrite, 
//     input hwrite_reg, 
//     input valid,
//     input [31:0] haddr,
//     input [31:0] haddr1,
//     input [31:0] haddr2,
//     input [31:0] hwdata,
//     input [31:0] hwdata1,
//     input [31:0] hwdata2,
//     input [31:0] prdata,
//     input [2:0] tempselx,

//     output reg pwrite,
//     output reg penable,
//     output reg hr_readyout,
//     output reg [2:0] psel,
//     output reg [31:0] paddr,
//     output reg [31:0] pwdata
// );

// //================ STATES =================//
// parameter idle=3'b000, read=3'b001, renable=3'b010,
//           wwait=3'b011, write=3'b100, wenable=3'b101,
//           writep=3'b110, wenablep=3'b111;

// reg [2:0] present, next;

// // temp outputs
// reg penable_temp, pwrite_temp, hr_readyout_temp;
// reg [2:0] psel_temp;
// reg [31:0] paddr_temp, pwdata_temp;

// //================ STATE REGISTER =================//
// always @(posedge hclk)
// begin
//     if (!hresetn)
//         present <= idle;
//     else
//         present <= next;
// end

// //================ NEXT STATE =================//
// always @(*)
// begin
//     next = idle;

//     case (present)

//         idle:
//             if(valid && hwrite) next = wwait;
//             else if(valid && !hwrite) next = read;

//         read: next = renable;

//         renable:
//             if(valid && hwrite) next = wwait;
//             else if(valid && !hwrite) next = read;

//         wwait:
//             if(valid) next = writep;
//             else next = write;

//         write:
//             if(valid) next = wenablep;
//             else next = wenable;

//         wenable:
//             if(valid && hwrite) next = wwait;
//             else if(valid && !hwrite) next = read;

//         writep: next = wenablep;

//         wenablep:
//             if(valid && hwrite_reg) next = writep;
//             else if(!valid && hwrite_reg) next = write;
//             else next = read;

//     endcase
// end

// //================ OUTPUT LOGIC =================//
// always @(*)
// begin
//     // DEFAULTS (VERY IMPORTANT)
//     paddr_temp = 0;
//     pwdata_temp = 0;
//     pwrite_temp = 0;
//     psel_temp = 0;
//     penable_temp = 0;
//     hr_readyout_temp = 1;

//     case (present)

//         //================ IDLE =================//
//         idle: begin
//             if(valid && !hwrite) begin
//                 paddr_temp = haddr;        // ✅ FIX
//                 pwrite_temp = 0;
//                 psel_temp = tempselx;
//                 hr_readyout_temp = 0;
//             end
//         end

//         //================ READ =================//
//         read: begin
//             penable_temp = 1;
//         end

//         //================ READ ENABLE =================//
//         renable: begin
//             if(valid && !hwrite) begin
//                 paddr_temp = haddr;        // ✅ FIX
//                 pwrite_temp = 0;
//                 psel_temp = tempselx;
//                 hr_readyout_temp = 0;
//             end
//         end

//         //================ WRITE WAIT =================//
//         wwait: begin
//             paddr_temp = haddr;            // ✅ FIX
//             pwdata_temp = hwdata1;         // ✅ FIX (aligned data)
//             pwrite_temp = 1;
//             psel_temp = tempselx;
//             hr_readyout_temp = 0;
//         end

//         //================ WRITE =================//
//         write: begin
//             penable_temp = 1;
//         end

//         //================ WRITE ENABLE =================//
//         wenable: begin
//             if(valid && hwrite) begin
//                 paddr_temp = haddr;        // ✅ FIX
//                 pwdata_temp = hwdata1;     // ✅ FIX
//                 pwrite_temp = 1;
//                 psel_temp = tempselx;
//                 hr_readyout_temp = 0;
//             end
//         end

//         //================ PIPE WRITE =================//
//         writep: begin
//             penable_temp = 1;
//         end

//         //================ PIPE WRITE ENABLE =================//
//         wenablep: begin
//             paddr_temp = haddr;            // ✅ FIX
//             pwdata_temp = hwdata1;         // ✅ FIX
//             pwrite_temp = 1;
//             psel_temp = tempselx;
//             hr_readyout_temp = 0;
//         end

//     endcase
// end

// //================ REGISTER OUTPUT =================//
// always @(posedge hclk)
// begin
//     if (!hresetn) begin
//         paddr <= 0;
//         pwdata <= 0;
//         pwrite <= 0;
//         psel <= 0;
//         penable <= 0;
//         hr_readyout <= 1;
//     end
//     else begin
//         paddr <= paddr_temp;
//         pwdata <= pwdata_temp;
//         pwrite <= pwrite_temp;
//         psel <= psel_temp;
//         penable <= penable_temp;
//         hr_readyout <= hr_readyout_temp;
//     end
// end

// endmodule