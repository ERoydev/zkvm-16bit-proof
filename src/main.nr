use poseidon;

fn hash_field(one_field: Field) -> Field {
    // Typically this takes a bn254 compatible field of Sha256 and hashes it using Poseidon
    poseidon::poseidon::bn254::hash_1([one_field])
}

fn main(
    // Public Inputs
    program_hash: Field, // bn254 hash of the sha256 field
    input_hash: Field,
    output_hash: Field,
    // Private Witness
    program: Field, // sha256 hash of the program, converted to bn254 field
    // Registers trace on each step
    registers: [[Field; 7]; 7], // provide before and after execution
    // Pc trace on each step
    pc: [Field; 7],
    // Opcode for each step
    opcode: [Field; 7],
    // reg pairs
    reg_pairs: [[Field; 3]; 7],
    // memory_subset
    memory_subset: [Field; 14],
) {
    // Enforce program hash matches our program
    let calculated_program_hash = hash_field(program);
    assert(calculated_program_hash == program_hash);

    for i in 0..6 {
        let op: Field = opcode[i];
        let before: [Field; 7] = registers[i];
        let after: [Field; 7] = registers[i + 1];
        // dst, src, imm for each step
        let dst_reg = reg_pairs[i][0];
        let src_reg = reg_pairs[i][1];
        let imm = reg_pairs[i][2];

        let low_byte = memory_subset[i * 2];
        let high_byte = memory_subset[i * 2 + 1];
        let memory_at_addr: Field = high_byte * 256 + low_byte;

        // Handle each opcode
        if op == 0 {
            println("opcode is 0 = HALT");
            // after register R0 == before R1 + 1 (example)
            assert(after[0] == before[1] + 1);
            // other registers unchanged
            for j in 1..7 {
                assert(after[j] == before[j]);
            }
        } else if op == 1 {
            println("opcode is 1 = COPY");
            // Copy from src to dst register
        } else if op == 2 {
            println("opcode is 2 = LOAD");
            // load memory into dst register from src register (src register holds address to a location in memory)
        } else if op == 3 {
            println("opcode is 3 = WRITE");
            // Write src register value into memory at address location in memory held in dst register
        } else if op == 4 {
            println("opcode is 4 = ADD");
            // src + dst and store in dst
        } else if op == 5 {
            println("Opcode is 5 = LOAD_IMM");
            // Load imm value to the IMM register
        } else if op == 6 {
            // opcode 6 logic placeholder
            println("opcode is 6 = STORE_OUT");
            // Store the r0 as a result in the memory
        } else {
            // NOP for other opcodes
            assert(after == before);
        }

        // PC moves forward by 2 bytes each instruction, so for each iteration i have one step forward
        assert(pc[i + 1] == pc[i] + 2);
    }

    // Final state commitment
    // constrain hash_registers(registers[2]) == output_hash;
}

#[test]
fn test_main() {
    // ===== Public inputs =====
    let program_hash = 10299258156576067376321481439471656619278056506920354124431265275224066876462;
    let input_hash = 0;
    let output_hash = 10746340777721269091166620128903435181954602251522780056306054141228417734284;

    // ===== Private witness =====
    // Bellow are the actual values that my 16-bit VM logged into .log after program execution
    // This is the raw program hashed using sha256
    let program = 12630064940486355474560008940412951592852515982109303420759129898107056307488;
    
    let opcode = [5, 1, 5, 1, 4, 6, 0];
    let registers = [
        [0, 0, 0, 0, 258, 22021, 0],
        [0, 0, 0, 0, 260, 4192, 5],
        [5, 0, 0, 0, 262, 22019, 5],
        [5, 0, 0, 0, 264, 4448, 3],
        [5, 3, 0, 0, 266, 16400, 3],
        [8, 3, 0, 0, 268, 24576, 3],
        [8, 3, 0, 0, 270, 0, 3],
    ];
    let reg_pairs = [[6, 0, 5], [0, 6, 0], [6, 0, 3], [1, 6, 0], [0, 1, 0], [0, 0, 0], [0, 0, 0]];
    let pc = [258, 260, 262, 264, 266, 268, 270];
    // have in mind that for 16-bit system i need to take 2 bytes in order to get one memory address, one slot (memory_subset[0] + [1])
    let memory_subset = [8, 0, 96, 16, 3, 86, 96, 17, 16, 64, 0, 96, 0, 0];

    main(
        program_hash,
        input_hash,
        output_hash,
        program,
        registers,
        pc,
        opcode,
        reg_pairs,
        memory_subset,
    );
}
