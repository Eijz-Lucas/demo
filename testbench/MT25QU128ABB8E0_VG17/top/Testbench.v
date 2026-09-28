//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//
//  Verilog Behavioral Model
//  Version 1.6
//
//  Copyright (c) 2013 Micron Inc.
//
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//
// This file and all files delivered herewith are Micron Confidential Information.
// 
// 
// Disclaimer of Warranty:
// -----------------------
// This software code and all associated documentation, comments
// or other information (collectively "Software") is provided 
// "AS IS" without warranty of any kind. MICRON TECHNOLOGY, INC. 
// ("MTI") EXPRESSLY DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO, NONINFRINGEMENT OF THIRD PARTY
// RIGHTS, AND ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS
// FOR ANY PARTICULAR PURPOSE. MTI DOES NOT WARRANT THAT THE
// SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE OPERATION OF
// THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. FURTHERMORE,
// MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR THE
// RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS,
// ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT
// OF USE OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO
// EVENT SHALL MTI, ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE
// LIABLE FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR
// SPECIAL DAMAGES (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS
// OF PROFITS, BUSINESS INTERRUPTION, OR LOSS OF INFORMATION)
// ARISING OUT OF YOUR USE OF OR INABILITY TO USE THE SOFTWARE,
// EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
// Because some jurisdictions prohibit the exclusion or limitation
// of liability for consequential or incidental damages, the above
// limitation may not apply to you.
// 
// Copyright 2013 Micron Technology, Inc. All rights reserved.
//
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//
//
//  Verilog Behavioral Model
//  Version 1.6 
//
//  Copyright (c) 2013 Micron Inc.
//
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
//-MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON--MICRON-
/*---------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

            TESTBENCH

-----------------------------------------------------------
-----------------------------------------------------------
---------------------------------------------------------*/


`timescale 1ns / 1ps

module Testbench;


    `include "include/UserData.h"
    `include "include/DevParam.h"

    wire S, C;
    wire [`VoltageRange] Vcc; 
    wire clock_active;

    
    wire DQ0, DQ1;
  

    wire Vpp_W_DQ2; 



// initial begin
// $vcdpluson;
// end                     //generate the waveform for dve



// initial begin
//   $fsdbAutoSwitchDumofile(800,"waveform.fsdb",50);
//   $fsdbDumpvars(0,Testbench);
//   $fsdbDumpMDA(0,Testbench);
//   $fsdbDumpon;  
// end











    `ifdef HOLD_pin
        wire HOLD_DQ3; 
    `endif
    

    `ifdef RESET_pin
        wire RESET_DQ3; 
    `endif
    
    
    `ifdef  N25Q256A33E
    
        `ifdef Stack1024Mb
            N25QxxxTop DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif Stack512Mb
            N25QxxxTop DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif  N25Q256A33Exxx1y
    
        `ifdef Stack1024Mb
            N25QxxxTop DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif Stack512Mb
            N25QxxxTop DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif  N25Q256A13E
    
        `ifdef Stack1024Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif Stack512Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif  N25Q256A13Exxx1y
    
        `ifdef Stack1024Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif Stack512Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif  N25Q256A73E
    
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    
    `elsif  N25Q256A83E
    
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif  N25Q256A81E
    
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif  N25Q256A83Exxx1y
    
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q256A31E
        
        `ifdef Stack1024Mb
            N25QxxxTop DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif Stack512Mb
            N25QxxxTop DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif  N25Q256A11E
    
        `ifdef Stack1024Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif Stack512Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif  N25Q256A11Exxx1y
    
        `ifdef Stack1024Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif Stack512Mb
            N25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif N25Q128A11E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q128A11Exxx1y
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q128A11B
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q128A13E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q128A13Exxx1y
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q128A13B
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25W128A11E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25W128A11B
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q064A13E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif N25Q064B11E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif N25Q064B13E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif N25Q064B33E
        
        N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif N25Q064B31E
        
        N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif N25Q064A11E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q032A13E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);
    
    `elsif N25Q032A11E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q016A11E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q016A13E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif N25Q008A11E
        
        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8E0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8E0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8E0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8E0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8Exx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8Exx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8Exx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8Exx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1E0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1E0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1Exx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1Exx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1E0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1E0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1Exx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1Exx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8F0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8Fxx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8F0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB8Fxx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8F0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8Fxx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8F0

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB8Fxx1

        wire RESET2;
        
        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1F0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1Fxx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1F0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU512ABB1Fxx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1F0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1Fxx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1F0

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL512ABB1Fxx1

        `ifdef STACKED_MEDT_1G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `elsif STACKED_MEDT_2G
            MT25QxxxTop DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `else
            N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);
        `endif

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL128ABB1F0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU128ABB1F0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL128ABB1E0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL128ABB8E0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL256ABB1E0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL256ABB8E0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL128ABB8Exx1

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, RESET2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QL128ABB1Exx1

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU128ABB1E0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU256ABB1E0

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU128ABB1Exx1

        N25Qxxx DUT (S, C, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, HOLD_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU128ABB8E0

        N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU256ABB8E0

        N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `elsif MT25QU128ABB8Exx1

        N25Qxxx DUT (S, C, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        Stimuli stim (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2);

        StimTasks tasks (S, RESET_DQ3, DQ0, DQ1, Vcc, Vpp_W_DQ2, clock_active);

        ClockGenerator ck_gen (clock_active, C);

    `endif



endmodule    
