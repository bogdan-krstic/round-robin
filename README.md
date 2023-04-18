# round-robin

A round robin arbiter and checker written in Verilog. Assertions checked (and proved for up to N = 16, see rr_wrap.v) include round robin safety (at most one grant given at once) and fairness (all requests served in <= N cycles, and requests served in circular order).
