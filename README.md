# calculator-asm

A menu-driven calculator written in 16 bit 8086 Assembly Language. 
This program is designed to run in a DOS environment and handles basic arithmetic operations.

## Features
- **Supported Operations:** +-*/
- **Multi-Digit Support:** Accepts and processes inputs up to 16-bit values.
- **Error Handling:** Includes specific logic to catch and report division by zero errors.

## Development Environment
This project was developed and tested using:
* **Visual Studio Code**
* **MASM/TASM Extension:** Used for assembling, linking, and emulating the code directly within the IDE.

## How to Run
1. Open this project in **VS Code**.
2. Ensure the **MASM/TASM** extension is installed.
3. Right-click the `calculator.asm` file.
4. Select **"Run ASM code"** (This will automatically trigger the assembler and open the DOSBox emulator).

## Technical Logic
- **Input handling:** Uses a custom `read_number` procedure to convert ASCII keyboard input into 16-bit words.
- **Output handling:** Uses a custom `print_number` procedure and the system stack to convert numeric results back into displayable ASCII strings.
- **Register Usage:** Primary calculations are performed in the `AX` register.

## Limitations
- **Size Constraint:** Cannot handle input numbers or results greater than a **16-bit word** (max value 65,535).
- **Signed Numbers:** Does not support negative numbers or signed arithmetic.
- **Float/Decimals:** Only supports integer math; division results will show the quotient only.
