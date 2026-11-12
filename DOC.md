# 📢 THÔNG BÁO PHÂN CÔNG — HPMR-KTS (Processor SystemVerilog)

## 1. Tổng quan

Mục tiêu: xây dựng processor 9-bit chạy 4 lệnh **MV, MVI, ADD, SUB**, gồm control unit (FSM T0–T3), register hierarchy, datapath (MUX + ALU) và top-level `proc.sv`.

| TV | Vai trò |
|----|---------|
| TV1 | Control Unit & FSM |
| TV2 | Register Subsystem |
| TV3 | Combinational Datapath |
| TV4 | Top-level Integration & Verification |

## 2. Sơ đồ phụ thuộc

```
TV2 (regn, register_*)  ─┐
TV3 (multiplexer, alu)  ─┼──►  TV4 (proc.sv, tb_proc)
TV1 (control_unit)      ─┘
```

TV1, TV2, TV3 làm song song. TV4 tích hợp sau khi các module có interface ổn định.
**Cần chốt sớm:** tên port, độ rộng bus (9-bit), thứ tự one-hot của tín hiệu chọn MUX.

## 3. Chi tiết từng thành viên

### TV1 — Control Unit & FSM (28%)
**Thiết kế điều khiển và instruction execution.**

| File | Ghi chú |
|------|---------|
| `RTL/Control_Unit/control_unit.sv` | Sửa/hoàn thiện |
| `Testbench/tb_control_unit.sv` | Sửa/hoàn thiện |
| `RTL/Common/Decoder/dec3to8.sv` | **File mới** |

**Trách nhiệm:**
- Thiết kế state transition **T0–T3**.
- Instruction decoder, Rx/Ry decoder (dùng `dec3to8`).
- Toàn bộ control signals.
- Xây dựng **control-signal table** cho MV, MVI, ADD, SUB.

### TV2 — Register Subsystem (25%)
**Thiết kế các phần tử lưu trữ và register hierarchy.**

| File | Ghi chú |
|------|---------|
| `RTL/Datapath/register_file.sv` | Sửa/hoàn thiện |
| `RTL/Datapath/register_A.sv` | Sửa/hoàn thiện |
| `RTL/Datapath/register_G.sv` | Sửa/hoàn thiện |
| `RTL/Datapath/register_instruction.sv` | Sửa/hoàn thiện |
| `RTL/Common/Register/regn.sv` | **File mới** |
| Testbench A, G, IR, RF hiện có | Cập nhật nếu cần |

**Trách nhiệm:**
- Register 9-bit có enable (`regn`).
- 8 general-purpose registers, IR, A và G.
- **Tái sử dụng `regn`**, không viết lại logic thanh ghi nhiều lần.

### TV3 — Combinational Datapath (22%)
**Thiết kế đường truyền dữ liệu và tính toán.**

| File | Ghi chú |
|------|---------|
| `RTL/Datapath/multiplexer.sv` | Sửa/hoàn thiện |
| `RTL/Datapath/alu.sv` | Sửa/hoàn thiện |
| `Testbench/tb_multiplexer.sv` | Sửa/hoàn thiện |
| `Testbench/tb_alu.sv` | Sửa/hoàn thiện |

**Trách nhiệm:**
- MUX 10-to-1, bus 9-bit.
- Add/Sub ALU 9-bit.
- Kiểm tra các nguồn dữ liệu, chọn one-hot và kết quả số học.

### TV4 — Top-level Integration & Verification (25%)
**Tích hợp và kiểm chứng toàn bộ processor.**

| File | Ghi chú |
|------|---------|
| `RTL/Top/proc.sv` | Sửa/hoàn thiện |
| `Testbench/tb_proc.sv` | Sửa/hoàn thiện |
| `processor_spec.md` | **File mới** |

**Trách nhiệm:**
- Viết top-level, kết nối tất cả module.
- Quản lý danh sách source files trong Quartus (thêm cả file mới của TV1, TV2).
- Xây dựng system-level testbench; debug; kiểm tra **RTL Viewer**.


