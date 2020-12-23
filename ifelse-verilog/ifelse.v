module ifelseverilog(a,b,c,d,e,f,y);
    input a,b,c,d,e,f;
    output y;
    
    //reg sum,cout;
    always @ (a or b or cin)
    begin
        if (a==1) 
            y <= d;
        else if (b==0) 
            y <= e;
        else if (c==1)
            y <= f;
        else begin
        //    y <= 0;
        end
    end
endmodule
