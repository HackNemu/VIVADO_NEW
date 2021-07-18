module CNT60(CLK, RESET, DEC, IN_CARRY, OUT_CARRY, ENABLE, CNT10, CNT6);
input CLK, RESET, DEC, ENABLE, IN_CARRY;
output [3:0]CNT10;
output [2:0]CNT6;
output OUT_CARRY; 

reg [3:0]CNT10;
reg [2:0]CNT6;
reg OUT_CARRY, CARRY;

//10 COUNT
always@(posedge CLK or posedge RESET)       //CLK������ or RESET���������
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT10 <= 4'h0;                  //COUNTER = 0 ������
        end
    else if(ENABLE == 1'b1 && IN_CARRY == 1'b1) //ENABLE�Ƃ�1�b�^�C�}�[��1�x��������p���X && �@���ʂ���̌J��オ��(���ʂ���CARRY�������Ƃ�����������������K�v�H)  
        if(DEC == 1'b0)                     //���Z
            begin
                if(CNT10 == 4'h9)
                    CNT10 <= 4'h0;          //�J��オ�������̏���
                else
                    CNT10 <= CNT10 + 4'h1;  //�J��オ�莞�ȊO�̏���
            end
        else                                //���Z
            begin
                if(CNT10 == 4'h0)           //�J�艺���莞�̏���       
                   CNT10 <= 4'h9;
                else
                    CNT10 <= CNT10 - 4'h1;  //�J�艺���莞�ȊO�̏���
            end
end
//CNT10==9 CARRY�@
always@(CNT10 or DEC or IN_CARRY)
begin
        if(DEC == 1'b0)                          //���Z
            if(CNT10 == 4'h9 && IN_CARRY == 1'b1)//CARRY10 �����@=�@�ꌅ�ڂ�9
                CARRY <= 1'b1;                   //���オ�肠��
            else                                 //�ꌅ�ڂ�9�ȊO
                CARRY <= 1'b0;                   //���オ��Ȃ�
        else                                     //���Z
            if(CNT10 == 4'h0 && IN_CARRY == 1'b1)//�ꌅ�ڂ�0     
                CARRY <= 1'b1;                   //���オ�肠�� 
             else                                //�ꌅ�ڂ�0�ȊO
                CARRY <= 1'b0;                   //���オ��Ȃ� 
end                                             


//6 COUNT
always@(posedge CLK or posedge RESET)       //CLK������ or RESET���������
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT6 <= 3'b000;                  //COUNTER = 0 ������
        end
    else if(ENABLE == 1'b1 && CARRY == 1'b1)     //ENABLE�Ƃ�1�b�^�C�}�[��1�x��������@�p���X && �@���ʂ���̌J��オ��(���ʂ���CARRY�������Ƃ�����������������K�v�H)
        if(DEC == 1'b0)                     //���Z
            begin
                if(CNT6 == 3'b101)          //�J��オ�������̏���
                   CNT6 <= 3'b000;          //0�ɖ߂�
                else
                    CNT6 <= CNT6 + 3'b001;  //�J��オ�莞�ȊO�̏���
            end
        else                                //���Z
            begin
                if(CNT6 == 3'b000)          //�J�艺���莞�̏���       
                   CNT6 <= 3'b101;          
                else
                    CNT6 <= CNT6 - 3'b001;  //�J�艺���莞�ȊO�̏���
            end
end
//CNT6==5 CARRY�@�쐬
always@(CNT6 or DEC or CARRY)
begin
        if(DEC == 1'b0)                         //���Z       
            if(CNT6 == 4'h5 && CARRY == 1'b1)   //�񌅖ڂ�5
                OUT_CARRY <= 1'b1;              //���オ�肠��   
            else                                //�񌅖ڂ�5�ȊO  
                OUT_CARRY <= 1'b0;              //���オ��Ȃ�   
        else                                    //���Z       
            if(CNT6 == 4'h0 && CARRY == 1'b1)   //�񌅖ڂ�0    
                OUT_CARRY <= 1'b1;              //���オ�肠��   
             else                               //�񌅖ڂ�0�ȊO  
                OUT_CARRY <= 1'b0;              //���オ��Ȃ�   
end
endmodule