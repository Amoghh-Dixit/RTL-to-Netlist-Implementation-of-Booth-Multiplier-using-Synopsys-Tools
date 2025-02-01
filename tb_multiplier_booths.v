`timescale 1ns/1ps

module tb_multiplier_booths;
    parameter width = 8;
    parameter no = 4;

    // Signals
    reg [width-1:0] multiplier;
    reg [width-1:0] multiplicand;
    reg load, clear_n, clock;
    wire done;
    wire [2*width-1:0] product;

    // Instantiate the DUT (Device Under Test)
    multiplier_booths #(width, no) dut (
        .done(done),
        .product(product),
        .multiplier(multiplier),
        .multiplicand(multiplicand),
        .load(load),
        .clear_n(clear_n),
        .clock(clock)
    );

    // Clock Generation
    always #5 clock = ~clock;  // 10 ns period (100 MHz)

    // Test sequence
    initial begin
        // Initialize signals
        clock = 0;
        clear_n = 0;
        load = 0;
        multiplier = 0;
        multiplicand = 0;
        
        // Apply Reset
        #10 clear_n = 1;
        
        // Test Case 1: 5 x 3
        #10 multiplier = 8'd5; multiplicand = 8'd3; load = 1;
        #10 load = 0;
        wait(done);
        $display("Test 1: 5 x 3 = %d", product);

        // Test Case 2: -7 x 4 (Two's complement representation)
        #20 multiplier = -8'd7; multiplicand = 8'd4; load = 1;
        #10 load = 0;
        wait(done);
        $display("Test 2: -7 x 4 = %d", product);

        // Test Case 3: -6 x -2
        #20 multiplier = -8'd6; multiplicand = -8'd2; load = 1;
        #10 load = 0;
        wait(done);
        $display("Test 3: -6 x -2 = %d", product);

        // Test Case 4: 9 x -5
        #20 multiplier = 8'd9; multiplicand = -8'd5; load = 1;
        #10 load = 0;
        wait(done);
        $display("Test 4: 9 x -5 = %d", product);

        // End simulation
        #50 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t | Multiplier=%d | Multiplicand=%d | Product=%d | Done=%b", 
                 $time, multiplier, multiplicand, product, done);
    end

endmodule
