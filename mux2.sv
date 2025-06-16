// HDL Example 7.11 2:1 MULTIPLEXER
module mux2 #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] d0,
    input  logic [WIDTH-1:0] d1,
    input  logic             s,
    output logic [WIDTH-1:0] y
);
    assign y = s ? d1 : d0;
endmodule
