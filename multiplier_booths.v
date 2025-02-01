`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Company			:	MSRSAS
// Engineer			:	Amogh c Dixit
// 
// Create Date		:	00:53:03 03/16/2008 
// Design Name		:	Multiplier
// Module Name		:	multiplier_booths
// Project Name		:	MULTIPLIERS
// Tool versions	:	Tool Independent
// Description		:	Multiplier using booths encoding and shift right and add 
//						method of multiplication 
//
// Dependencies		:	none so ever
//
// Comments 		: 	Remember to change the size of 'no' appropriately  based on change in width
//
// Revision			:	i.) 13:50:11 08/08/2008 -> Proper Identation carried out
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module multiplier_booths #(parameter width = 8, no = 4)(
output 	reg                 	done		,
output 	reg 	[2*width-1:0] 	product		,
input      	[width-1:0]   	multiplier	,
input           [width-1:0]   	multiplicand	,
input 				load		,
input 				clear_n		,
input                  		clock 		);

	reg	[3*width+2:0]	accumulator	;
	reg	[2*width-1:0] 	acc_in		;			
	reg 	[no-1:0]      	count		;
	reg 	[width+1:0]   	check 		;

always@(posedge clock, negedge clear_n)
	if(!clear_n) 
		begin
			accumulator	= 0;
			done 		= 0;
			count 		= 0;
			product 	= 0;
		end
	else	
		if(load)
			begin
				accumulator	= {{(2*width+2){1'b0}},multiplier,1'b0};
			    	done		= 0;
				count 		= 0;
			end
		else
			begin
				case(accumulator[1:0])
					2'b10 	:  	acc_in	= ~({{width{1'b0}},multiplicand}) + 1'b1;
					2'b01 	:  	acc_in	=   {{width{1'b0}},multiplicand};
					default : 	acc_in 	= 0;
				endcase

				accumulator[3*width+2:width+2] = accumulator[3*width+1:width+2] + acc_in;
								
				if(count == width)
					begin	
						done 	= 1'b1;
						product = accumulator[2*width+1:2];
					end
					
				accumulator		= {accumulator[3*width+2],accumulator[3*width+2:1]};		
				count 			= count + 1'b1;
			end
	
endmodule 
