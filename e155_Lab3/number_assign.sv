module number_assign(
      input  logic [3:0] rows,
      input  logic [3:0] cols,
      output logic [3:0] left_digit
);
    logic [7:0] total;
    assign total = {~rows, ~cols};

    always_comb begin
        case(total)
        8'b0001_0001:  left_digit = 4'b0001;  //(1)
        8'b0001_0010:  left_digit = 4'b0010;  //(2)
        8'b0001_0100:  left_digit = 4'b0011;  //(3)
        8'b0001_1000:  left_digit = 4'b1010;  //(A)
        8'b0010_0001:  left_digit = 4'b0100;  //(4)
        8'b0010_0010:  left_digit = 4'b0101;  //(5)
        8'b0010_0100:  left_digit = 4'b0110;  //(6)
        8'b0010_1000:  left_digit = 4'b1011;  //(B)
        8'b0100_0001:  left_digit = 4'b0111;  //(7)
        8'b0100_0010:  left_digit = 4'b1000;  //(8)
        8'b0100_0100:  left_digit = 4'b1001;  //(9)
        8'b0100_1000:  left_digit = 4'b1100;  //(C)
        8'b1000_0001:  left_digit = 4'b1110;  //(E)
        8'b1000_0010:  left_digit = 4'b0000;  //(0)
        8'b1000_0100:  left_digit = 4'b1111;  //(F)
        8'b1000_1000:  left_digit = 4'b1101;  //(D)
        default:       left_digit = 4'b0000;  //default
        endcase
    end

endmodule