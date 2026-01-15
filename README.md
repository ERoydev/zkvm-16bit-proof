# zkvm-16bit-circuit

This project implements a zero-knowledge proof circuit for a simple 16-bit virtual machine (VM) using Noir. The circuit verifies the correct execution of a program on the VM, supporting basic instructions and memory operations.

## Features
- 16-bit VM with 7 registers and memory subset
- Supports opcodes: HALT, COPY, LOAD, WRITE, ADD, LOAD_IMM, STORE_OUT
- Public inputs: program hash, input hash, output hash
- Private witness: program, register traces, PC trace, opcode trace, register pairs, memory subset
- Example test included

## File Structure
- `src/main.nr`: Main Noir circuit and test
- `Nargo.toml`: Project configuration
- `Prover.toml`: Prover configuration

## Usage

### 1. Install Noir
Follow the instructions at [noir-lang.org](https://noir-lang.org/docs/getting_started/installation/) to install Noir and Nargo.

### 2. Check the Circuit
Run:
```sh
nargo check
```

### 3. Run the Test
Run:
```sh
nargo test
```
This will execute the example test in `main.nr` to verify the circuit logic.

### 4. Generate a Proof
To generate a proof first fill the `Prover.toml` with the parameters and then:
```sh
nargo execute
```

## Inputs
- **Public Inputs:**
  - `program_hash`: [Field; 32]
  - `input_hash`: [Field; 32]
  - `output_hash`: [Field; 32]
- **Private Witness:**
  - `program`: [Field; 6]
  - `registers`: [[Field; 7]; 7]
  - `pc`: [Field; 7]
  - `opcode`: [Field; 7]
  - `reg_pairs`: [[Field; 3]; 7]
  - `memory_subset`: [Field; 14]

## Example
See the `test_main` function in `src/main.nr` for a sample test vector and usage.

## License
MIT
