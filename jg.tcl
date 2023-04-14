clear -all
set_proofgrid_manager on

set top_file rr_wrap.v

analyze \
    -incdir . \
    -y . \
    -sv12 rr_wrap.v \
    +libext+.vs +libext+.sv +libext+.vlib +libext+.v +libext+.vh +libext+.v \

elaborate -top rr_wrap -disable_auto_bbox

clock clk
reset -expression rst

# ---------------------------------------------------------------------------

# Run Proofs

set_engine_mode {Hp Ht Hps B K I N D Tri}
# set_engine_mode {Hps }

# set_engine_mode {Mp N}
# prove -all
