# Database design for a Pharmaceutical System
## Project Overview

This repository delivers a **fully normalized Oracle SQL and PL/SQL database** for NOVA, a fictional pharmaceutical retail chain. It models and manages core operations for:

- Pharmacies  
- Pharmaceutical manufacturers  
- Patients  
- Doctors  
- Prescriptions  

All business workflows are captured in a relational schema and enforced through PL/SQL logic.

---

## 🕹️ Design Highlights

- **Third Normal Form (3NF)** schema: Eliminates data redundancy, ensures consistency, and maintains referential integrity.  
- **11 interrelated tables** covering both master data and transactions:  
  - Core entities: `PHARMACY`, `DOCTOR`, `PATIENT`, `DRUG`, `PHARMACEUTICAL_COMPANY`  
  - Transactional/associative tables: `PRESCRIPTION`, `PRESC_DETAILS`, `SELLS`, `CONTRACTS`, `TREATED_BY`  
- **Scalable dataset**: Tested with 500+ realistic rows to simulate real-world usage.

---

## ⚙️ Implementation Details

- **20+ PL/SQL modules** including:  
  - **Procedures** for reusable business logic  
  - **Functions** to encapsulate complex queries and return computed values  
  - **Cursors** for efficient row-by-row processing  
  - **Triggers** enforcing critical rules:
    - One prescription per patient per day  
    - Minimum stock levels per pharmacy  
    - No overlapping contracts and valid supervisor assignments  

- **Comprehensive constraints** at both schema and code levels:  
  - `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE` for structural integrity  
  - `CHECK` constraints for domain validation  
  - Conditional logic in triggers and procedures for rule enforcement  

---

## 🔮 Extensibility & Best Practices

- **Modular design** allows easy addition of features such as user roles, GUI front-ends, or audit logging.  
- **Adheres to relational database best practices**, ensuring maintainable, performant, and reliable data management.  

