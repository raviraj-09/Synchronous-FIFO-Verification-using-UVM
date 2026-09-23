# Synchronous FIFO Verification using UVM

## 📌 Overview

This project implements a **UVM-based functional verification environment for a synchronous FIFO (First-In First-Out)**.

The FIFO is designed with an **8-bit data width** and a **depth of 16**, and the verification environment checks FIFO read/write behavior, `full` and `empty` conditions, and data correctness.

The testbench uses **SystemVerilog and UVM** and is simulated using **QuestaSim 10.7c**.

---

## 🧩 DUT Specifications

| Parameter                |            Value |
| ------------------------ | ---------------: |
| Data Width               |           8 bits |
| FIFO Depth               |               16 |
| Type                     | Synchronous FIFO |
| Clock                    |     Single clock |
| Reset                    |       Active-low |
| Simulation Tool          |  QuestaSim 10.7c |
| Verification Methodology |              UVM |

### FIFO Interface

* `clk` – Clock
* `rst_n` – Active-low reset
* `wr_en` – Write enable
* `rd_en` – Read enable
* `din` – 8-bit input data
* `dout` – 8-bit output data
* `full` – FIFO full status
* `empty` – FIFO empty status

---

## 🏗️ UVM Verification Architecture

```text
                 +----------------+
                 |   UVM Test     |
                 +-------+--------+
                         |
                         v
                 +----------------+
                 |    Sequence    |
                 +-------+--------+
                         |
                         v
                 +----------------+
                 |   Sequencer    |
                 +-------+--------+
                         |
                         v
                 +----------------+
                 |    Driver      |
                 +-------+--------+
                         |
                         v
                 +----------------+
                 |      DUT       |
                 |  Synchronous   |
                 |      FIFO      |
                 +-------+--------+
                         |
                         v
                 +----------------+
                 |    Monitor     |
                 +-------+--------+
                         |
                         v
                 +----------------+
                 |   Scoreboard   |
                 +----------------+
```

### Data Flow

```text
Sequence
   ↓
Sequencer
   ↓
Driver
   ↓
FIFO DUT
   ↓
Monitor
   ↓
Analysis Port
   ↓
Scoreboard
```

---

## 📂 Project Structure

```text
Synchronous-FIFO-UVM/
│
├── rtl/
│   └── sync_fifo.sv
│
├── interface/
│   └── fifo_if.sv
│
├── uvm/
│   ├── fifo_seq_item.sv
│   ├── fifo_sequence.sv
│   ├── fifo_sequencer.sv
│   ├── fifo_driver.sv
│   ├── fifo_monitor.sv
│   ├── fifo_agent.sv
│   ├── fifo_scoreboard.sv
│   ├── fifo_env.sv
│   └── fifo_test.sv
│
├── tb/
│   └── tb_top.sv
│
├── sim/
│   └── simulation_logs/
│
└── README.md
```

---

## 🔹 UVM Components

### 1. Sequence Item

`fifo_seq_item` represents one FIFO transaction.

It contains signals such as:

```systemverilog
wr_en
rd_en
din
dout
full
empty
```

The sequence item is randomized by the sequence.

---

### 2. Sequence

`fifo_sequence` generates FIFO transactions.

The project uses constrained-random stimulus with a distribution for read and write operations.

Example:

```systemverilog
wr_en dist {
    1 := 60,
    0 := 40
};

rd_en dist {
    1 := 60,
    0 := 40
};
```

This allows different combinations of FIFO read/write operations to be exercised automatically.

---

### 3. Sequencer

The sequencer transfers sequence items from the sequence to the driver.

```text
Sequence → Sequencer → Driver
```

---

### 4. Driver

The driver receives transactions from the sequencer and drives the FIFO interface.

```text
UVM Transaction
      ↓
    Driver
      ↓
FIFO Interface
      ↓
    DUT
```

---

### 5. Monitor

The monitor observes the FIFO interface without driving it.

It samples:

* Read enable
* Write enable
* Input data
* Output data
* Full flag
* Empty flag

The observed transaction is sent to the scoreboard through a **UVM analysis port**.

---

### 6. Scoreboard

The scoreboard performs data checking using a SystemVerilog queue as a **reference FIFO**.

For a valid write:

```text
DUT FIFO       ← data
Reference FIFO ← same data
```

For a valid read:

```text
DUT output       → actual data
Reference FIFO   → expected data
```

The scoreboard compares:

```text
Expected Data == Actual Data
```

and reports:

```text
READ PASS
READ FAIL
```

---

## 🧠 Reference Model

The scoreboard maintains:

```systemverilog
bit [7:0] reference_fifo[$];
```

### Write

```text
Valid WRITE
    ↓
push_back(din)
```

### Read

```text
Valid READ
    ↓
pop_front()
    ↓
Expected Data
```

This models FIFO behavior:

```text
First Data Written
       ↓
First Data Read
```

---

## 🔍 Verification Checks

The environment verifies:

* FIFO write operation
* FIFO read operation
* FIFO data ordering
* FIFO full condition
* FIFO empty condition
* Simultaneous read/write behavior
* Read data correctness
* Randomized transactions
* DUT vs. reference FIFO comparison

---

## 🧪 Testbench Flow

```text
Reset
  ↓
Generate Random Transactions
  ↓
Sequence
  ↓
Sequencer
  ↓
Driver
  ↓
FIFO DUT
  ↓
Monitor
  ↓
Scoreboard
  ↓
Expected vs Actual Comparison
  ↓
PASS / FAIL
```

---

## 🛠️ Tools & Technologies

* **SystemVerilog**
* **UVM 1.1d**
* **QuestaSim 10.7c**
* **Functional Verification**
* **Constrained-Random Verification**
* **UVM Scoreboard**
* **UVM Analysis Port**
* **SystemVerilog Queue**

---

## 📊 Verification Result

The testbench was run with randomized FIFO transactions and the scoreboard was used to compare DUT output against the reference FIFO model.

The simulation generates UVM reports indicating:

```text
READ PASS
READ FAIL
```

along with the final pass/fail count.
<img width="1143" height="793" alt="image" src="https://github.com/user-attachments/assets/e4ecf184-13c0-4b2a-a31d-4ae072c31e4d" />

<img width="1210" height="373" alt="image" src="https://github.com/user-attachments/assets/a5cf6df2-dc3d-4208-90a1-b054901923c0" />

---

## 🎯 Key Learning Outcomes

Through this project, I worked with:

* UVM testbench architecture
* `uvm_sequence_item`
* `uvm_sequence`
* `uvm_sequencer`
* `uvm_driver`
* `uvm_monitor`
* `uvm_agent`
* `uvm_scoreboard`
* `uvm_env`
* `uvm_test`
* `uvm_analysis_port`
* `uvm_analysis_imp`
* `uvm_config_db`
* Virtual interface
* Constrained-random stimulus
* Reference model implementation
* FIFO data checking
* QuestaSim compilation and simulation
* Debugging RTL/UVM timing issues

---

## 🚀 Future Improvements

Possible extensions to this project include:

* Functional coverage
* Assertions for FIFO protocol checking
* Separate coverage collector
* More extensive corner-case testing
* Directed tests for full/empty transitions
* Simultaneous read/write corner cases
* Regression testing
* Improved clock/reset synchronization

---

## 👨‍💻 Author

**Ravi Raj**

M.Tech – VLSI Design

LinkedIn: [Ravi Raj](https://www.linkedin.com/in/ravi-raj-06s1/)

---

## 📜 License

This project is intended for **educational and verification practice purposes**.
