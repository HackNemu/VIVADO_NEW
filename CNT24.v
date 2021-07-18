module CNT24(CLK, RESET, DEC, IN_CARRY, OUT_CARRY, ENABLE, CNT10, CNT3);
input CLK, RESET, DEC, ENABLE, IN_CARRY;
output [3:0]CNT10;
output [1:0]CNT3;
output OUT_CARRY;

reg [3:0]CNT10;
reg [1:0]CNT3;
reg OUT_CARRY,CARRY;

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
                else if(CNT10 == 4'h3 && CNT3 == 2'b10)    //3���Ԃ̎�����20����
                    CNT10 <= 4'h0; 
                else
                    CNT10 <= CNT10 + 4'h1;  //�J��オ�莞�ȊO�̏���
            end
        else                                //���Z
            begin
                if(CNT10 == 4'h0 && CNT3 == 2'b00)
                   CNT10 <= 4'h3; 
                else if(CNT10 == 4'h0)           //�J�艺���莞�̏���       
                   CNT10 <= 4'h9;
                else
                    CNT10 <= CNT10 - 4'h1;  //�J�艺���莞�ȊO�̏���
            end
end


//3 COUNT
always@(posedge CLK or posedge RESET)       //CLK������ or RESET���������
begin
    if(RESET == 1'b1)                       //RESET BTN ON
        begin
            CNT3 <= 2'b00;                  //COUNTER = 0 ������
        end
    else if(ENABLE == 1'b1 && CARRY == 1'b1) //ENABLE�Ƃ�1�b�^�C�}�[��1�x��������p���X && ���ԃL�����[  
        if(DEC == 1'b0)                     //���Z
            begin
                if(CNT3 == 2'b10)
                    CNT3 <= 2'b00;          //�J��オ�������̏���
                else
                    CNT3 <= CNT3 + 2'b01;  //�J��オ�莞�ȊO�̏���
            end
        else                                //���Z
            begin
                if(CNT3 == 2'b00)           //�J�艺���莞�̏���       
                   CNT3 <= 2'b10;
                else
                    CNT3 <= CNT3 - 2'b01;  //�J�艺���莞�ȊO�̏���
            end
end

//CNT10 CARRY�@�쐬
always@(CNT10 or DEC or IN_CARRY)
begin
        if(DEC == 1'b0)                         //���Z
            if(CNT10 == 4'h9 && IN_CARRY == 1'b1) //CARRY10 �����@=�@�ꌅ�ڂ�9�@&& ���ʂ���̌J��オ�肪1
                CARRY <= 1'b1;                //���オ�肠��
            else if(CNT10 == 4'h3 && CNT3 == 2'b10)//3���Ԃ̎�����20����
                CARRY <= 1'b1;
            else                              //�ꌅ�ڂ�9�ȊO
                CARRY <= 1'b0;                //���オ��Ȃ�
        else                                  //���Z
            if(CNT10 == 4'h0 && IN_CARRY == 1'b1)                 //�ꌅ�ڂ�0     
                CARRY <= 1'b1;                //���オ�肠��
            else if(CNT10 == 4'h0 && CNT3 == 2'b00)//3���Ԃ̎�����20���ԁ@������Ƃ��͕K�v�Ȃ�
                CARRY <= 1'b1; 
            else                             //�ꌅ�ڂ�0�ȊO
                CARRY <= 1'b0;                //���オ��Ȃ� 
end                                             

//CNT3 CARRY�@�쐬
always@(CNT3 or DEC or CARRY)
begin
        if(DEC == 1'b0)                      //���Z       
            if(CNT3 == 2'b10 && CARRY == 1'b1)//�񌅖ڂ�2 ���@�ꌅ�ڂ����オ��
                OUT_CARRY <= 1'b1;              //���オ�肠��   
            else                             //�񌅖ڂ�5�ȊO  
                OUT_CARRY <= 1'b0;              //���オ��Ȃ�   
        else                                 //���Z       
            if(CNT3 == 2'h00 && CARRY == 1'b1)                //�񌅖ڂ�0    
                OUT_CARRY <= 1'b1;              //���オ�肠��   
             else                            //�񌅖ڂ�0�ȊO  
                OUT_CARRY <= 1'b0;              //���オ��Ȃ�   
end
endmodule