-- PATIENT TABLE
CREATE TABLE Patient (
    AadharID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Address VARCHAR(255)
);

-- DOCTOR TABLE
CREATE TABLE Doctor (
    AadharID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(100),
    YearsOfExperience INT
);

-- PHARMACEUTICAL COMPANY
CREATE TABLE PharmaceuticalCompany (
    Name VARCHAR(100) PRIMARY KEY,
    Phone VARCHAR(15)
);

-- DRUG TABLE
CREATE TABLE Drug (
    TradeName VARCHAR(100),
    Formula VARCHAR(100),
    PC_Name VARCHAR(100),
    PRIMARY KEY (TradeName,PC_Name),
    FOREIGN KEY (PC_Name) REFERENCES PharmaceuticalCompany(Name)
);


-- PHARMACY TABLE
CREATE TABLE Pharmacy (
    Name VARCHAR(100),
    Address VARCHAR(255) PRIMARY KEY,
    Phone VARCHAR(15)
);

-- CONTRACT RELATION (Between Pharmacy and PharmaceuticalCompany)
CREATE TABLE Contract (
    Address VARCHAR(255),
    PC_Name VARCHAR(100),
    Content Varchar(255),
    CompanyName VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    Supervisor VARCHAR(100),
    PRIMARY KEY (Address, PC_Name),
    FOREIGN KEY (Address) REFERENCES Pharmacy(Address),
    FOREIGN KEY (PC_Name) REFERENCES PharmaceuticalCompany(Name)
);

-- SELL RELATION (Between Drug and Pharmacy)
CREATE TABLE Sells (
    Trade_Name Varchar(100),
    PC_Name Varchar(100),
    Address_Pharmacy Varchar(255),
    Price INT,
    PRIMARY KEY (Trade_Name,PC_Name,Address_Pharmacy),
    FOREIGN KEY (Trade_Name,PC_Name) REFERENCES Drug(TradeName,PC_Name),
    FOREIGN KEY (Address_Pharmacy) REFERENCES Pharmacy(Address)
);

-- PRESCRIPTION TABLE
CREATE TABLE Prescription (
    Date DATE,
    AadharID_P VARCHAR(20),
    AadharID_D VARCHAR(20),
    PRIMARY KEY(Date,AadharID_D,AadharID_P),
    FOREIGN KEY (AadharID_D) REFERENCES Doctor(AadharID),
    FOREIGN KEY (AadharID_P) REFERENCES Patient(AadharID)
    
);

-- CONTAIN RELATION (Drugs in Prescription)
CREATE TABLE Contains (
    Date DATE,
    AadharID_P VARCHAR(20),
    AadharID_D VARCHAR(20),
    Trade_Name VARCHAR(100),
    PC_Name Varchar(100),
    Quantity INT,
    PRIMARY KEY (Date,AadharID_D,AadharID_P,Trade_Name,PC_Name),
    FOREIGN KEY (Date,AadharID_D,AadharID_P) REFERENCES Prescription(Date,AadharID_D,AadharID_P),
    FOREIGN KEY (Trade_Name,PC_Name) REFERENCES Drug(TradeName,PC_Name)
);

-- CONSULTS RELATION (Between Doctor and Patient)
CREATE TABLE Consults (
    AadharID_P VARCHAR(20),
    AadharID_D VARCHAR(20),
    PRIMARY KEY (AadharID_P, AadharID_D),
    FOREIGN KEY (AadharID_D) REFERENCES Doctor(AadharID),
    FOREIGN KEY (AadharID_P) REFERENCES Patient(AadharID)
);
----------------------------------------------
