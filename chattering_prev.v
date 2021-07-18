module CHATTERING_PREV(CLK,RESET,SW_IN,SW_OUT);
 input CLK, RESET, SW_IN;
 output SW_OUT;
 reg BUF_SW1, BUF_SW2, BUF_OUT;

//�N���b�N�ő҂����Ԃ𔭐����������@����10ms�@���炢�̃N���b�N

// �`���^�����O����
 always @(posedge CLK or posedge RESET)
 begin
 
    if(reset == 1'b0)   //������
       begin
        BUF_SW1 <= 1'b0;
        //BUF_SW2 <= 1'b0;
        BUF_OUT <= 1'b0;
       end
    else
       begin
�@�@�@     if(BUF_SW1 == SW_IN)  //SW�̓���2�N���b�N�œ����ł����
             begin
�@�@�@�@        BUF_OUT <= SW_IN;
�@�@          end
           else
             begin
                BUF_SW2 = BUF_SW1;  //1��ڂ�SW_IN��SW2��
                BUF_SW1 = SW_IN;    //2��ڂ�SW_IN��SW1��
�@�@         end
       end
 end
// �o��
assign SW_OUT = BUF_OUT;
endmodule 