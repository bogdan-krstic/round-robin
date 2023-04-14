// Fix a circular ordering of senders. Remember who was the last granted.
// Of all senders who have put in a request, grant the one that comes
// first after the last granted.

// If there are N senders, every request will be granted in <= N cycles.'

// Arbiter: onehot (verify!) grant vector

// Assume: requests are stable once high, until granted.


module b_rr_checker
  
  #(
    // parameters
    int N = 10,
    int logN = $clog2(N)
    )
   (
    // ports
    input logic [N-1:0] req,
    input logic [N-1:0] gnt,

    input logic clk,
    input logic rst
    );

   // assumption: reqs stable after going high
   
   genvar	i;
   
   generate for (i = 0; i < N; i++) begin: ASM_req_stable_loop
      ASM_req_stable: assume property (@(posedge clk) req[i] |=> (gnt[i] || req[i]));
   end
   endgenerate

   // gnt safety: onehot0(gnt)

   AST_onehot0_gnt: assert property (@(posedge clk) $onehot0(gnt));

   // reqs gnted within N cycles:
   
   logic [logN-1:0] sklm_idx;

   ASM_sklm_idx_bound: assume property (@(posedge clk) sklm_idx <= N);
   
   ASM_sklm_idx_stable: assume property (@(posedge clk) $stable(sklm_idx));

   AST_req_gnted_in_N_cycles: assert property(@(posedge clk) $rose(req[sklm_idx]) |-> ##[0:N] gnt[sklm_idx]);

   // reqs granted in order

   logic [logN-1:0] sklm_i, sklm_j, sklm_k;

   ASM_sklm_ijk__bound: assume property (@(posedge clk) (sklm_i <= N) && (sklm_j <= N) && (sklm_k <= N));

   ASM_sklm_ijk__stable: assume property (@(posedge clk) ($stable(sklm_i) && $stable(sklm_j) && $stable(sklm_k)));

   ASM_sklm_ijk_neq: assume property (@(posedge clk) (sklm_i != sklm_j) && (sklm_i != sklm_j) && (sklm_j != sklm_k));
      
   ASM_sklm_distance: assume property (@(posedge clk) ((sklm_k - sklm_i) % N) > ((sklm_j - sklm_i) % N));
   
   logic	    sklm_j_gnted;

   always_ff @(posedge clk) begin
      if (rst) begin
	 sklm_j_gnted <= 0;
      end
      else begin
	 if (gnt[sklm_j]) begin
	    sklm_j_gnted <= 1;
	 end
      end
   end
   
   logic sklm_ijk_monitor;

   always_ff @(posedge clk) begin
      if (rst) begin
	 sklm_ijk_monitor <= 0;
      end
      else begin
	 if (gnt[sklm_i] && req[sklm_j] && req[sklm_k]) begin
	    sklm_ijk_monitor <= 1;
	 end
      end
   end
   
   AST_reqs_gntd_in_order: assert property (@(posedge clk) sklm_ijk_monitor |-> !(!sklm_j_gnted && gnt[sklm_k]));
   

   

					
   

   
   
   
   
   
   
   
   
   
endmodule // b_rr_checker
