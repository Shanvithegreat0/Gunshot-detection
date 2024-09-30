# Gunshot Detection FPGA Project

## Introduction

This project implements a real-time gunshot detection system on an FPGA using Mel-frequency cepstral coefficients (MFCCs) for feature extraction and Hidden Markov Models (HMMs) for classification. The system is designed to accurately detect gunshot sounds in audio streams by leveraging the parallel processing capabilities of FPGAs for efficient computation.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup Instructions](#setup-instructions)
- [Usage](#usage)
  - [Simulation](#simulation)
  - [Synthesis and Implementation](#synthesis-and-implementation)
  - [Programming the FPGA](#programming-the-fpga)
- [Project Components](#project-components)
  - [MFCC Feature Extraction](#mfcc-feature-extraction)
  - [Hidden Markov Model Classification](#hidden-markov-model-classification)
- [Hardware Requirements](#hardware-requirements)
- [Software Requirements](#software-requirements)
- [Customization](#customization)
  - [Adjusting Fixed-Point Precision](#adjusting-fixed-point-precision)
  - [Training the HMM](#training-the-hmm)
  - [Modifying Constraints](#modifying-constraints)
- [Testing and Verification](#testing-and-verification)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Project Overview

The goal of this project is to create a robust and efficient gunshot detection system that can be deployed in real-world environments. By implementing the algorithm on an FPGA, we achieve low-latency processing suitable for real-time applications. The system combines:

- **MFCCs**: To extract meaningful audio features that represent the spectral properties of gunshot sounds.
- **HMMs**: To model the temporal dynamics and sequence patterns inherent in gunshot audio signals.

---

## Features

- **Real-Time Processing**: Capable of analyzing audio streams in real-time with minimal latency.
- **High Accuracy**: Utilizes advanced signal processing and statistical modeling for accurate detection.
- **Modular Design**: Clean separation of components for ease of understanding and modification.
- **Scalability**: Designed to be scalable to different FPGA platforms and resource constraints.
- **Customizable Parameters**: Allows adjustments to precision, frame sizes, and HMM parameters.

---

## Directory Structure

```
gunshot_detection_fpga/
├── README.md
├── docs/
│   └── design_documentation.pdf
├── src/
│   ├── mfcc/
│   │   ├── mfcc_top.vhd
│   │   ├── pre_emphasis.vhd
│   │   ├── framing.vhd
│   │   ├── windowing.vhd
│   │   ├── fft.vhd
│   │   ├── mel_filter_bank.vhd
│   │   ├── log_module.vhd
│   │   └── dct.vhd
│   ├── hmm/
│   │   ├── hmm_top.vhd
│   │   ├── forward_algorithm.vhd
│   │   └── viterbi_algorithm.vhd
│   ├── top_level.vhd
│   └── pkg/
│       └── fixed_point_pkg.vhd
├── sim/
│   ├── tb_mfcc.vhd
│   ├── tb_hmm.vhd
│   └── tb_top_level.vhd
├── scripts/
│   ├── compile.tcl
│   ├── simulate.tcl
│   └── synthesize.tcl
├── constraints/
│   └── constraints.xdc
└── data/
    ├── test_audio_samples/
    └── trained_hmm_parameters/
```

---

## Getting Started

### Prerequisites

- **FPGA Development Board**: Such as Xilinx Zynq-7000 series or Intel Cyclone series.
- **FPGA Development Tools**:
  - For Xilinx: Vivado Design Suite.
  - For Intel: Quartus Prime Software.
- **Hardware Description Language Knowledge**: Familiarity with VHDL.
- **Basic Understanding of Signal Processing and HMMs**.

### Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/your_username/gunshot_detection_fpga.git
   ```

2. **Navigate to the Project Directory**

   ```bash
   cd gunshot_detection_fpga
   ```

3. **Install FPGA Development Tools**

   - Download and install the appropriate FPGA development tools for your hardware platform.

4. **Set Up Environment Variables**

   - Ensure that your FPGA tools are added to your system's PATH.

5. **Review the Constraints File**

   - Open `constraints/constraints.xdc` and adjust pin assignments according to your FPGA board.

---

## Usage

### Simulation

Before synthesizing and implementing the design on hardware, it's essential to simulate and verify its functionality.

1. **Compile the VHDL Files**

   ```bash
   vivado -mode batch -source scripts/compile.tcl
   ```

2. **Run Simulations**

   ```bash
   vivado -mode batch -source scripts/simulate.tcl
   ```

3. **View Waveforms**

   - Use the simulation tool's GUI to inspect signal waveforms and verify module behaviors.

### Synthesis and Implementation

1. **Synthesize the Design**

   ```bash
   vivado -mode batch -source scripts/synthesize.tcl
   ```

2. **Check Synthesis Reports**

   - Review resource utilization and timing estimates.

3. **Implement the Design**

   - Implementation steps are included in `synthesize.tcl`.

4. **Generate Bitstream**

   - The bitstream file (`.bit`) will be generated after successful implementation.

### Programming the FPGA

1. **Connect the FPGA Board**

   - Ensure your FPGA board is connected via USB or JTAG.

2. **Program the FPGA**

   ```bash
   vivado -mode tcl
   Vivado% open_hw
   Vivado% connect_hw_server
   Vivado% open_hw_target
   Vivado% program_hw_devices -bitfile <path_to_bitstream>
   Vivado% exit
   ```

3. **Verify Operation**

   - Observe the `detection` output signal (e.g., an LED or GPIO pin) to confirm gunshot detection.

---

## Project Components

### MFCC Feature Extraction

The MFCC module extracts spectral features from the input audio signal. It consists of several sub-modules:

- **Pre-Emphasis Filter (`pre_emphasis.vhd`)**: Amplifies high-frequency components.
- **Framing (`framing.vhd`)**: Segments the audio signal into frames.
- **Windowing (`windowing.vhd`)**: Applies a Hamming window to each frame.
- **FFT (`fft.vhd`)**: Converts the time-domain signal to the frequency domain.
- **Mel Filter Bank (`mel_filter_bank.vhd`)**: Applies Mel-scaled filters.
- **Logarithm Module (`log_module.vhd`)**: Computes the logarithm of filter bank energies.
- **Discrete Cosine Transform (`dct.vhd`)**: Produces the final MFCCs.

**Key Features:**

- **Fixed-Point Arithmetic**: Optimized for FPGA resource constraints.
- **Modular Design**: Each stage is implemented as a separate module for clarity and reuse.
- **Scalability**: Parameters like frame size and number of coefficients can be adjusted.

### Hidden Markov Model Classification

The HMM module classifies the MFCC feature vectors to detect gunshot sounds.

- **HMM Top Module (`hmm_top.vhd`)**: Integrates the forward algorithm and controls the classification process.
- **Forward Algorithm (`forward_algorithm.vhd`)**: Calculates the likelihood of the observed sequence.
- **Viterbi Algorithm (`viterbi_algorithm.vhd`)**: (Optional) Determines the most probable state sequence.

**Key Features:**

- **Pre-Trained Parameters**: HMM parameters are loaded from constants initialized with trained values.
- **Fixed-Point Computation**: Ensures efficient use of FPGA resources.
- **Threshold-Based Detection**: Outputs a detection signal when a gunshot is identified.

---

## Hardware Requirements

- **FPGA Development Board**: Ensure the board has sufficient resources (logic cells, DSP slices, BRAM).
- **Audio Input Interface**: Microphone module or ADC to provide audio samples.
- **Output Interface**: LEDs or GPIO pins to indicate detection.

---

## Software Requirements

- **FPGA Development Environment**:
  - **Xilinx Vivado Design Suite** for Xilinx FPGAs.
  - **Intel Quartus Prime Software** for Intel FPGAs.
- **Simulation Tools**: Integrated within the FPGA development environment.
- **Synthesis Tools**: Part of the FPGA development suite.

---

## Customization

### Adjusting Fixed-Point Precision

Modify `fixed_point_pkg.vhd` to adjust the word length and fractional bits:

```vhdl
subtype fp16_6 is signed(15 downto 0);  -- 16 bits total, 6 integer bits
constant FP_WIDTH : integer := 16;
constant FP_FRACTIONAL : integer := 10; -- Number of fractional bits
```

- **FP_WIDTH**: Total number of bits.
- **FP_FRACTIONAL**: Number of bits used for the fractional part.

### Training the HMM

- **Data Collection**: Gather gunshot and non-gunshot audio samples.
- **Feature Extraction**: Use software tools (e.g., Python with librosa) to extract MFCCs.
- **HMM Training**: Train the HMM using algorithms like Baum-Welch.
- **Export Parameters**: Initialize the HMM parameters (`A`, `B`, `Pi`) in the VHDL code with the trained values.

### Modifying Constraints

- **Pin Assignments**: Update `constraints/constraints.xdc` with your FPGA board's pin mappings.
- **Clock Definitions**: Adjust clock frequencies and waveforms as per your design.
- **IO Standards**: Ensure IO standards match your hardware requirements.

---

## Testing and Verification

- **Module-Level Testing**: Use testbenches in `sim/` to verify individual modules.
- **Integrated Testing**: Simulate `tb_top_level.vhd` to test the entire system.
- **Hardware Testing**: After programming the FPGA, test with actual audio inputs.
- **Performance Metrics**: Evaluate detection accuracy, latency, and resource utilization.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the Repository**
2. **Create a Feature Branch**

   ```bash
   git checkout -b feature/your_feature
   ```

3. **Commit Your Changes**

   ```bash
   git commit -am 'Add new feature'
   ```

4. **Push to the Branch**

   ```bash
   git push origin feature/your_feature
   ```

5. **Open a Pull Request**

---
