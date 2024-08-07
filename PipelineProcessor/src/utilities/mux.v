module mux_4 #(parameter integer LENGTH) (in1, in2, in3, in4, sel, out);
  input [LENGTH-1:0] in1, in2, in3, in4;
  input [1:0] sel;
  output [LENGTH-1:0] out;

  assign out = (sel == 2'd0) ? in1 :
               (sel == 2'd1) ? in2 :
               (sel == 2'd2) ? in3 : in4;
endmodule


module mux_3 #(parameter integer LENGTH) (in1, in2, in3, sel, out);
  input [LENGTH-1:0] in1, in2, in3;
  input [1:0] sel;
  output [LENGTH-1:0] out;

  assign out = (sel == 2'd0) ? in1 :
               (sel == 2'd1) ? in2 :
               (sel == 2'd2) ? in3 : 0;
endmodule	


module mux_2 #(parameter integer LENGTH) (in1, in2, sel, out);
  input [LENGTH-1:0] in1, in2;
  input  sel;
  output [LENGTH-1:0] out;

  assign out = (sel == 0) ? in1 : in2;
  
endmodule