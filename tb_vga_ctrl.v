`timescale  1ns/1ns
module  tb_vga_ctrl();
wire            locked      ;
wire            rst_n       ;
wire            vga_clk     ;

//reg   define
reg             sys_clk     ;
reg             sys_rst_n   ;
reg     [15:0]  pix_data    ;
initial
    begin
        sys_clk     =   1'b1;
        sys_rst_n   <=  1'b0;
        #200
        sys_rst_n   <=  1'b1;
    end

//sys_clk：产生时钟
always  #10 sys_clk = ~sys_clk  ;

//rst_n:VGA模块复位信号
assign  rst_n = (sys_rst_n & locked);

//pix_data:输入像素点色彩信息
always@(posedge vga_clk or  negedge rst_n)
    if(rst_n == 1'b0)
        pix_data    <=  16'h0;
    else
        pix_data    <=  16'hffff;
clk_gen clk_gen_inst
(
    .areset     (~sys_rst_n ),  //输入复位信号,高电平有效,1bit
    .inclk0     (sys_clk    ),  //输入50MHz晶振时钟,1bit
    .c0         (vga_clk    ),  //输出VGA工作时钟,频率25Mhz,1bit
    .locked     (locked     )   //输出pll locked信号,1bit
);

//------------- vga_ctrl_inst -------------
vga_ctrl  vga_ctrl_inst
(
    .vga_clk    (vga_clk    ),  //输入工作时钟,频率25MHz,1bit
    .sys_rst_n  (rst_n      ),  //输入复位信号,低电平有效,1bit
    .pix_data   (pix_data   ),  //输入像素点色彩信息,16bit

    .pix_x      (pix_x      ),  //输出VGA有效显示区域像素点X轴坐标,10bit
    .pix_y      (pix_y      ),  //输出VGA有效显示区域像素点Y轴坐标,10bit
    .hsync      (hsync      ),  //输出行同步信号,1bit
    .vsync      (vsync      ),  //输出场同步信号,1bit
    .rgb        (rgb        )   //输出像素点色彩信息,16bit
);

endmodule

