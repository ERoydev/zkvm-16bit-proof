
## ZK-Friendly Hashes

ZK-friendly hash functions are designed to require far fewer constraints to prove and verify in zero-knowledge (zk) circuits than traditional cryptographic hash functions.

- **Traditional hashes** (e.g., SHA256, Keccak256) rely heavily on bitwise operations such as XOR and bit rotations. These functions decompose bytes into bits, which is slow and inefficient for zk circuits.
- **ZK-friendly hashes** operate directly on field elements using simple arithmetic operations like addition and multiplication. This makes them much more efficient for zero-knowledge proofs, as all operations are limited to modular addition and multiplication.

---

## Resources

- [ZK-Friendly Hashes — RareSkills](https://rareskills.io/post/zk-friendly-hash)