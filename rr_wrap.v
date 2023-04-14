

module b_rr_wrap
  #(
    int N_ = 16
    )
   (
    input logic clk, rst,
    input logic [N_-1:0] req,
    output logic [N_-1:0] gnt
    );

   b_rr
     #(
       .N(N_)
       )
   dut
     (
      .*
      );

   b_rr_checker
     #(
       .N(N_)
       )
   chekker
     (
      .*
      );

endmodule // b_rr_wrap
