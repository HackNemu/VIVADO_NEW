module ENABLE_GEN(CLK, RESET, ENABLE, ENABLE_khz);
input CLK, RESET;
output ENABLE,ENABLE_khz;
reg [26:0] tmp_count;
wire ENABLE, ENABLE_khz;    //1bit�M���Ȃ̂ŏȗ����Ă��悢���@�����ď����ׂ�

//parameter SEC1_MAX = 125000000;  //125Mhz
parameter SEC1_MAX = 1;  //125Mhz
//parameter EN_Khz_MSB_BIT = 15;  //khz����肽���Ƃ��́@�ŏ�ʃr�b�g��
//parameter EN_Khz_VAL = 16'hffff;// 65536
parameter EN_Khz_MSB_BIT = 2;  //khz����肽���Ƃ��́@�ŏ�ʃr�b�g��
parameter EN_Khz_VAL = 1;// 65536

//�P�b�J�E���g�p�̃J�E���^�[
always@(posedge CLK or posedge RESET)
begin
        if(RESET == 1'b1)
                tmp_count <= 27'h0000000;
        else if (ENABLE == 1'b1)                //ENABLE�����Ă��� �J�E���g0�ɖ߂�
                tmp_count <= 27'h0000000;
        else
               // tmp_count <= tmp_count + 27'h1; //�J�E���g����
               tmp_count <= tmp_count + 1'b1; //�J�E���g����
end                                             //�Ȃ�27'h1�Ȃ̂� bit�������킹�Ă��邾���H�@1���₷�����Ȃ�@1'b1�ł͂��߁H

//�O���փN���b�N���o�͂��鏈��
assign ENABLE = (tmp_count == (SEC1_MAX -1))? 1'b1 : 1'b0; //�O�����Z�q  ENABLE��125MHZ - 1�@�ŗ���
//125khz�̓J�E���g125000�����@�_�C�i�~�b�N�_��(���F����)�͂Q�����łP�ƍl����΁@65536*2�ő��125khz�ɂȂ�
assign ENABLE_khz = (tmp_count[EN_Khz_MSB_BIT:0] == EN_Khz_VAL)? 1'b1 : 1'b0;   //(16bit��FFFF)�ŗ���=65536�J�E���g�@

endmodule