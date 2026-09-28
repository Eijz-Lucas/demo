//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//
//  MT25QU128ABA1E0
//
//  Verilog Behavioral Model
//  Version 1.6
//
//  Copyright (c) 2013 Micron Inc.
//
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
`timescale 1ns / 1ns
// the port list of current module is contained in "StimGen_interface.h" file
`include "top/StimGen_interface.h"

initial 
    begin
    
        $display("\n SIMNAME: TDP.v \n");

        tasks.init;

        tdp_transactions;

        tasks.wrapUp;

    end

`define TDP_READ_x1     'b0000_0000
`define TDP_READ_x2     'b0001_0000
`define TDP_READ_x4     'b0010_0000
`define TDP_PROGRAM_x1  'b0100_0000
`define TDP_PROGRAM_x2  'b0101_0000
`define TDP_PROGRAM_x4  'b0110_0000
`define TDP_ERASE       'b1000_0000

integer i;

task tdp_transactions;
    begin
        tasks.fillExpVal(512'hFF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,64,`_,`_);
        tasks.fillExpVal(512'hFFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
        tasks.fillExpVal(512'hFFFD_FFFD_DFFF_BFFF_BBFF_F7FF_F77F_7BDE_FFF0_FFF0_0FFC_CC3C_CC33_CCCF_FEFF_FFEE_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x4,64,`_,`_);
//        tasks.fillExpVal(512'hFFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
//        tasks.fillExpVal(512'hFF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,64,`_,`_);
//
//        tasks.fillExpVal(40'hFF_FFFF_FFFF);
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'hBF, `ON);
//        tasks.read_nonarray(`CMD_RDVECR,1);
//
//        tasks.fillExpVal(512'hFFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,64,`_,`_);
//        tasks.fillExpVal(512'hFFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
//        tasks.fillExpVal(512'hFFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x4,64,`_,`_);
//
//        tasks.fillExpVal(40'hFF_FFFF_FFFF);
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'h7F, `ON);
//        tasks.read_nonarray(`CMD_RDVECR,1);
//
//        tasks.fillExpVal(512'hFFFD_FFFD_DFFF_BFFF_BBFF_F7FF_F77F_7BDE_FFF0_FFF0_0FFC_CC3C_CC33_CCCF_FEFF_FFEE_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,64,`_,`_);
//        tasks.fillExpVal(512'hFFFD_FFFD_DFFF_BFFF_BBFF_F7FF_F77F_7BDE_FFF0_FFF0_0FFC_CC3C_CC33_CCCF_FEFF_FFEE_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x4,64,`_,`_);
//
//        tasks.fillExpVal(40'hFF_FFFF_FFFF);
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'hFF, `ON);
//        tasks.read_nonarray(`CMD_RDVECR,1);
//
//        tasks.fillExpVal(512'hFF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,64,`_,`_);
//        tasks.fillExpVal(512'hFFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
//        tasks.fillExpVal(512'hFFFD_FFFD_DFFF_BFFF_BBFF_F7FF_F77F_7BDE_FFF0_FFF0_0FFC_CC3C_CC33_CCCF_FEFF_FFEE_FFDF_FFDD_FFFB_FFFB_BFFF_7FFF_77F7_BDEF_FF0F_FF00_FFCC_C3CC_C33C_CCFF_FEFF_FEEF);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x4,64,`_,`_);
//
//        //erase
//        tasks.TDP_ops(`CMD_TDP,`TDP_ERASE,`_,`_,`_);
//
//        //do a x1,x2,and x4 read after erasing TDP registers
//        tasks.fillExpVal(512'h0);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,64,`_,`_);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x4,64,`_,`_);
//
//        //do a x1 program and then a x1 read
//        tasks.TDP_ops(`CMD_TDP,`TDP_PROGRAM_x1,15,'h0,"linear");
//        tasks.fillExpVal(128'h0F0E_0D0C_0B0A_0908_0706_0504_0302_0100);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,16,`_,`_);
//
//        //do a x1 read after erasing TDP registers
//        tasks.TDP_ops(`CMD_TDP,`TDP_ERASE,`_,`_,`_);
//        tasks.fillExpVal(512'h0);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x1,64,`_,`_);
//
//        //do a x2 TDP program followed by a x2 read
//        tasks.fillExpVal(256'h1F1E_1D1C_1B1A_1918_1716_1514_1312_1110_0F0E_0D0C_0B0A_0908_0706_0504_0302_0100);
//        tasks.TDP_ops(`CMD_TDP,`TDP_PROGRAM_x2,31,'h0,"linear");
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,32,`_,`_);
//
//        //do a x2 read after erasing TDP registers
//        tasks.TDP_ops(`CMD_TDP,`TDP_ERASE,`_,`_,`_);
//        tasks.fillExpVal(512'h0);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
//
//        //do a x4 TDP program
//        tasks.fillExpVal(512'h3F3E_3D3C_3B3A_3938_3736_3534_3332_3130_2F2E_2D2C_2B2A_2928_2726_2524_2322_2120_1F1E_1D1C_1B1A_1918_1716_1514_1312_1110_0F0E_0D0C_0B0A_0908_0706_0504_0302_0100);
//        tasks.TDP_ops(`CMD_TDP,`TDP_PROGRAM_x4,63,'h0,"linear");
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x4,64,`_,`_);
//
//        //set device to DIO mode
//        tasks.fillExpVal(40'hFF_FFFF_FFFF);
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'hBF, `ON);
//        tasks.read_nonarray(`CMD_RDVECR,1);
//
//        //do a x2 program in DIO mode followed by a x2 TDP read
//        tasks.fillExpVal(256'h1F1E_1D1C_1B1A_1918_1716_1514_1312_1110_0F0E_0D0C_0B0A_0908_0706_0504_0302_0100);
//        tasks.TDP_ops(`CMD_TDP,`TDP_PROGRAM_x2,31,'h0,"linear");
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,32,`_,`_);
//
//        //do a x2 read after erasing TDP registers in DIO mode
//        tasks.TDP_ops(`CMD_TDP,`TDP_ERASE,`_,`_,`_);
//        tasks.fillExpVal(512'h0);
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x2,64,`_,`_);
//
//        //set device to QIO mode followed by a VECR read to confirm
//        tasks.fillExpVal(40'hFF_FFFF_FFFF);
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'h7F, `ON);
//        tasks.read_nonarray(`CMD_RDVECR,1);
//
//        //do a x4 program in QIO mode followed by a x4 TDP read
//        tasks.fillExpVal(512'h3F3E_3D3C_3B3A_3938_3736_3534_3332_3130_2F2E_2D2C_2B2A_2928_2726_2524_2322_2120_1F1E_1D1C_1B1A_1918_1716_1514_1312_1110_0F0E_0D0C_0B0A_0908_0706_0504_0302_0100);
//        tasks.TDP_ops(`CMD_TDP,`TDP_PROGRAM_x4,63,'h0,"linear");
//        tasks.TDP_ops(`CMD_TDP,`TDP_READ_x4,64,`_,`_);
//
//        //do array reads
//        tasks.fillExpVal(64'hFFFF_FFFF_FFFF_FFFF);
//        tasks.read_array_(`CMD_READ,`DIE0_SECTOR_07_SS0_B,3);
//        tasks.fillExpVal(64'hFFFF_FFFF_FF10_9F9E);
//        tasks.read_array_(`CMD_FAST_READ,`DIE0_SECTOR_08_L,3);
//
//        //set device to SIO mode followed by a VECR read to confirm
//        tasks.fillExpVal(40'hFF_FFFF_FFFF);
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'hFF, `ON);
//        tasks.read_nonarray(`CMD_RDVECR,1);
//
//        //do array reads
//        tasks.fillExpVal(64'hFFFF_FFFF_FFFF_FFFF);
//        tasks.read_array_(`CMD_READ,`DIE0_SECTOR_07_SS0_B,3);
//        tasks.fillExpVal(64'hFFFF_FFFF_FF10_9F9E);
//        tasks.read_array_(`CMD_FAST_READ,`DIE0_SECTOR_08_L,3);
    end
endtask //tdp_transactions
        
endmodule    
