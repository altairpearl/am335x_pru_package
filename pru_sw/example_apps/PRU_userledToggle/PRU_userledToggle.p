.origin 0
.entrypoint START

#include "PRU_userledToggle.hp"
//#define AM33XX

START:
// clear the SYSCFG to enable OCP master port
    LBCO r0, C4, 4, 4
    CLR r0, r0, 4
    SBCO r0, C4, 4, 4

    MOV r1, 10
BLINK:
    MOV r2, 15<<21
    MOV r3, GPIO1 | GPIO_SETDATAOUT
    SBBO r2, r3, 0, 4

    MOV r0, 0x00f00000
DELAY:
    SUB r0, r0, 1
    QBNE DELAY, r0, 0

    MOV r2, 15<<21
    MOV r3, GPIO1 | GPIO_CLEARDATAOUT
    SBBO r2, r3, 0, 4

    MOV r0, 0x00f00000
DELAY2:
    SUB r0, r0, 1
    QBNE DELAY2, r0, 0

    SUB r1, r1, 1
    QBNE BLINK, r1, 0

    // Send notification to Host for program completion
    MOV R31.b0, PRU0_ARM_INTERRUPT+16

HALT

