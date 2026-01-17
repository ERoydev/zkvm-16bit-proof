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
  - `program_hash`: Field — Poseidon hash of the SHA-256 digest, reduced modulo the bn254 field prime (as with sha254)
  - `output_hash`: Field — Poseidon hash of the SHA-256 digest, reduced modulo the bn254 field prime (as with sha254)
  - `pub_program_state`: [Field; 7] — Poseidon hash of the SHA-256 digest, reduced modulo the bn254 field prime (as with sha254)

- **Private Witness:**
  - `private_program_sha254`: Field — SHA-256 hash of the program, converted to bn254 field
  - `private_output_sha254`: Field — SHA-256 hash of the final program state, as bn254 field
  - `private_program_state`: [Field; 7] — SHA-256 hash of the program state at each step, as bn254 fields


Each hash is computed using SHA-256 and then converted to a bn254 field element for compatibility with the circuit. Arrays represent traces or states at each step of execution.

- Public inputs are provided as hashes (using Poseidon) for succinctness and privacy.
- Private witness values are the original data, which are hashed with SHA-256 for compression and integrity within the circuit.

## Supported Verifier Backends

This circuit has been tested with multiple verifier backends to ensure compatibility and correctness:

- **Barretenberg**: Successfully tested for proof generation and verification. (Noir v = 1.0.0-beta.3)
- **Sunspot**: Successfully tested for proof compilation and verification. (Noir v = 1.0.0-beta.13)

These tests confirm that the circuit's ACIR output and proof system are compatible with both Barretenberg and Sunspot.

## License
MIT
