// Fix a circular ordering of senders. Remember who was the last granted.
// Of all senders who have put in a request, grant the one that comes
// first after the last granted.

// If there are N senders, every request will be granted in <= N cycles.'

// Arbiter: onehot (verify!) grant vector

// Assume: requests are stable once high, until granted.

module b_rr
  #(
    // parameters
    int	N = 10, // number of agents
    int	logN = $clog2(N)
    )
   (
    // ports
    input logic [N-1:0]	 req,
    output logic [N-1:0] gnt,
    
    input logic		 clk,
    input logic		 rst
    );

   logic [logN-1:0]	 cur_ptr, last_ptr;
   
   
   always_ff @(posedge clk) begin
      if (rst) begin
	 last_ptr <= '0;
	 // gnt <= '0;
      end
      else begin
	 last_ptr <= cur_ptr;	
      end
   end
   
   always_comb begin

      gnt = '0;
      	         
      if (req != '0) begin
	 for (int i = 1; i <= N; i++) begin
	    if (req[(last_ptr + i) % N] == 1) begin
	       cur_ptr = (last_ptr + i) % N;
	       gnt[cur_ptr] = 1;
	       // req[cur_ptr] = 0;
	       break;
	    end
	 end
      end
   end // always_comb
   
			
      
   
    endmodule // b_rr
