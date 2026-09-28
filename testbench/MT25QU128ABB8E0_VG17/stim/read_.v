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

//----------------------------------------------------------------------------------------
// Description:
// This testcase cycles through the different Read commands in SIO, DIO, QIO modes.
//
//----------------------------------------------------------------------------------------

    initial begin
        
        $display("\n SIMNAME: read_.v \n");

        tasks.init;

        readArray("pass0");

        loop_around_dummy;
        
//        $display("\n***DIO mode via VECR[7:6]***\n");
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'hAF, `ON);
//
//        readArray("pass1");
//
//        $display("\n***QIO mode via VECR[7:6]***\n");
//        tasks.write_nonarray(`CMD_WRVECR,'hFF,'h6F, `ON);
//
//        readArray("pass2");

        tasks.wrapUp;
    end

task loop_around_dummy;
    integer dummy;
    begin
        for (dummy = 0; dummy <=14; dummy = dummy + 1) begin
            $display("[%0t] DUMMY == %0d", $time, dummy);
            tasks.send_command(`CMD_WREN);
            #1
            tasks.S = 1;
            tasks.clock_active = 0;
            #T;
#100;
            tasks.send_command('h81);
            tasks.send_data({dummy[3:0],4'hF});
            #1
            #T;
            tasks.S = 1;
            tasks.clock_active = 0;
#100;
            //tasks.write_nonarray(`CMD_WRVCR,dummy,dummy, `ON);
            readArray("pass0");
        end
    end
endtask //loop_arround_dummy

task readArray;
    input [40*dataDim-1:0] cycle;
    begin
//        tasks.fillExpVal(64'hFFFF_FFFF_FFFF_FFFF);
//        tasks.read_array_(`CMD_READ,`DIE0_SECTOR_07_SS0_B,3);
//
//        tasks.fillExpVal(64'hFFFF_FF04_0302_0100);
//        tasks.read_array_(`CMD_READ,`DIE0_SECTOR_08_B,5);

        tasks.fillExpVal(64'hFFFF_FFFF_FF10_9F9E);
        tasks.read_array_(`CMD_FAST_READ,`DIE0_SECTOR_08_L,3);
        tasks.read_array_(`CMD_FAST_READ,`DIE0_SECTOR_00_B,3);
//        tasks.read_array_(`CMD_DOFR,`DIE0_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DIOFR,`DIE0_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QOFR, `DIE0_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QIOFR,`DIE0_SECTOR_08_L,3);

//        tasks.enter_4_byte;
//
//        $display("\n***DIE1 reads - 4byte mode via EN4BYTE***\n");
//
//        tasks.fillExpVal(64'hFFFF_FF04_0302_0100);
//        tasks.read_array_(`CMD_READ,`DIE1_SECTOR_08_B,5);
//
//        tasks.fillExpVal(64'hFFFF_FFFF_FF10_9F9E);
//        tasks.read_array_(`CMD_FAST_READ,`DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DOFR,`DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DIOFR,`DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QOFR, `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QIOFR,`DIE1_SECTOR_08_L,3);
//
//        $display("\n***DIE0 reads - 4byte mode via EN4BYTE***\n");
//
//        tasks.fillExpVal(64'hFFFF_FF04_0302_0100);
//        tasks.read_array_(`CMD_READ,`DIE0_SECTOR_08_B,5);
//
//        tasks.fillExpVal(64'hFFFF_FFFF_FF10_9F9E);
//        tasks.read_array_(`CMD_FAST_READ,`DIE0_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DOFR,`DIE0_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DIOFR,`DIE0_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QOFR, `DIE0_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QIOFR,`DIE0_SECTOR_08_L,3);
//
//        tasks.read_array_(`CMD_READ4BYTE,     `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_FAST_READ4BYTE,`DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DOFR4BYTE,     `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DIOFR4BYTE,    `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QOFR4BYTE,     `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QIOFR4BYTE,    `DIE1_SECTOR_08_L,3);
//
//        tasks.exit_4_byte;
//
//        tasks.fillExpVal(64'hFFFF_FFFF_FF10_9F9E);
//        tasks.read_array_(`CMD_READ4BYTE,     `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_FAST_READ4BYTE,`DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DOFR4BYTE,     `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_DIOFR4BYTE,    `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QOFR4BYTE,     `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_QIOFR4BYTE,    `DIE1_SECTOR_08_L,3);
//        tasks.read_array_(`CMD_4READ4D,       `DIE1_SECTOR_08_L,3);
//
//        $display("\n ---Crossing from Die0 to Die1--- \n");
//        tasks.fillExpVal(64'hFFFF_FFFF_0100_FFFF);
//        tasks.read_array_(`CMD_FAST_READ4BYTE,`DIE0_SECTOR_1023_L,6);

    end
endtask //readArray

endmodule    
