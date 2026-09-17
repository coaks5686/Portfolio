-- SQL & The Chili Spill Data Recovery Task Force
-- 11/18/2025
-- Deliverables

CREATE DATABASE HIIS ;

USE HIIS ;

CREATE TABLE specialties (
SID INT (4) ,
SName VARCHAR(100) ,
SDescription VARCHAR(100) ,
PRIMARY KEY (SID)
) ;
SET FOREIGN_Key_checks = 0 ;

CREATE TABLE doctor (
DID INT (4) ,
DFName VARCHAR (100) ,
DLName VARCHAR (100) ,
DPID INT (4) ,
PRIMARY KEY (DID) ,
FOREIGN KEY (DPID) REFERENCES Department (DPID) 
) ;

CREATE TABLE department (
DPID INT (4) ,
DPName VARCHAR(100) ,
DPBuilding_Name VARCHAR(100) ,
DPFloor_Number INT ,
DPHead INT (4) ,
PRIMARY KEY (DPID) ,
FOREIGN KEY (DPHead) REFERENCES Doctor (DID) 
) ;

SET FOREIGN_KEY_CHECKS = 1 ;

CREATE TABLE patient (
PID INT (4),
PFName VARCHAR(100) ,
PLName VARCHAR(100) ,
PDOB VARCHAR(50) ,
PPhone VARCHAR(100) ,
PEmail VARCHAR(100) ,
PRIMARY KEY (PID) 
) ;

CREATE TABLE emergency_contact (
ECID INT(4) ,
ECFName VARCHAR(100) ,
ECLName VARCHAR(100) ,
ECPhone VARCHAR(100) ,
ECEmail VARCHAR(100) ,
ECRelationship VARCHAR(100),
PRIMARY KEY (ECID)
) ;

CREATE TABLE admission (
AID INT (4) ,
ECID INT (4) ,
PID INT (4) ,
DID INT (4) ,
Admit_Date VARCHAR (100) ,
Release_Date VARCHAR (100) ,
PRIMARY KEY (AID) ,
FOREIGN KEY (ECID) REFERENCES emergency_contact (ECID) ,
FOREIGN KEY (PID) REFERENCES patient (PID) ,
FOREIGN KEY (DID) REFERENCES doctor (DID)
) ;

CREATE TABLE treatment (
TID INT (4) , 
TDate VARCHAR (12) ,
TDescription VARCHAR (255) ,
AID INT (4) ,
DID INT (4) ,
PRIMARY KEY (TID) ,
FOREIGN KEY (AID) REFERENCES admission (AID) ,
FOREIGN KEY (DID) REFERENCES doctor (DID)
) ;

CREATE TABLE doctor_specialty (
DSID INT (4) ,
SID INT (4) ,
DID INT (4) ,
PRIMARY KEY (DSID) ,
FOREIGN KEY (SID) REFERENCES specialties(SID) ,
FOREIGN KEY (DID) REFERENCES doctor (DID)
)  ;

-- Insert Statements 

INSERT INTO Specialties (SID, SName, SDescription) VALUES (1000, 'Cardiology', 'Diagnosis and treatment of heart disorders');
INSERT INTO Specialties (SID, SName, SDescription) VALUES (2000, 'Interventional Cardiology', 'Catheter-based treatment of heart diseases');
INSERT INTO Specialties (SID, SName, SDescription) VALUES (3000, 'Neurology', 'Diagnosis and treatment of nervous system disorders');

SET FOREIGN_KEY_CHECKS = 0 ;
 
INSERT INTO Doctor (DID, DFName, DLName, DPID) VALUES (1001, 'John', 'Smith', 10);
INSERT INTO Doctor (DID, DFName, DLName, DPID) VALUES (1002, 'Emily', 'Clark', 20);
INSERT INTO Doctor (DID, DFName, DLName, DPID) VALUES (1003, 'Susan', 'Lee', 10);

INSERT INTO Department (DPID, DPName, DPBuilding_Name, DPFloor_Number, DPHead) VALUES (10, 'Cardiology', 'North Wing', 3, 1001);
INSERT INTO Department (DPID, DPName, DPBuilding_Name, DPFloor_Number, DPHead) VALUES (20, 'Neurology', 'East Wing', 4, 1002);

SET FOREIGN_KEY_CHECKS = 1 ;
 
INSERT INTO Patient (PID, PFName, PLName, PDOB, PPhone, PEmail) VALUES (5001, 'Michael', 'Brown', '1985-06-15', '555-0101', 'michael.brown@.com
');
INSERT INTO Patient (PID, PFName, PLName, PDOB, PPhone, PEmail) VALUES (5002, 'Laura', 'Garcia', '1992-11-02', '555-0202', 'laura.garcia@.com
');
 
INSERT INTO Emergency_Contact (ECID, ECFName, ECLName, ECPhone, ECEmail, ECRelationship) VALUES (9001, 'Anna', 'Brown', '555-0303', 'anna.brown@.com
', 'Spouse');
INSERT INTO Emergency_Contact (ECID, ECFName, ECLName, ECPhone, ECEmail, ECRelationship) VALUES (9002, 'Carlos', 'Garcia', '555-0404', 'carlos.garcia@.com
', 'Father');
 
INSERT INTO Admission (AID, PID, Admit_Date, Release_Date, DID, ECID) VALUES (7001, 5001, '2025-11-20', '2025-11-23', 1001, 9001);
INSERT INTO Admission (AID, PID, Admit_Date, Release_Date, DID, ECID) VALUES (7002, 5002, '2025-11-22', NULL, 1002, 9002);
 
INSERT INTO Treatment (TID, AID, TDate, TDescription, DID) VALUES (8001, 7001, '2025-11-21', 'Appendectomy', 1003);
INSERT INTO Treatment (TID, AID, TDate, TDescription, DID) VALUES (8002, 7001, '2025-11-22', 'Post-op follow-up and medication adjustment', 1001);
INSERT INTO Treatment (TID, AID, TDate, TDescription, DID)VALUES (8003, 7002, '2025-11-23', 'Neurological assessment and MRI order', 1002);

INSERT INTO Doctor_Specialty (DSID, DID, SID) VALUES (1, 1001, 1000);
INSERT INTO Doctor_Specialty (DSID, DID, SID) VALUES (2, 1001, 2000);
INSERT INTO Doctor_Specialty (DSID, DID, SID) VALUES (3, 1002, 3000);
INSERT INTO Doctor_Specialty (DSID, DID, SID) VALUES (4, 1003, 1000);

-- Select Statements

# For each inpatient, list all his admission records including patient’s ID, name, the dates that the patient is admitted and released from the hospital, and the doctor (ID and name) who is in charge of this patient for this admission.
 
SELECT DISTINCT p.PID, p.PFName, p.PLName, a.Admit_Date, a.Release_Date, d.DID, d.DFName, d.DLName
FROM patient AS p 
INNER JOIN admission AS a
ON p.PID = a.PID
INNER JOIN doctor AS d
ON a.DID = d.DID
;
 
# For each patient, list the patient’s ID and name, the ID and name of the doctors who have ever been in charge of that patient’s admissions (not treatments!), and the number of times that doctor has been the doctor-in-charge for that patient.
 
SELECT p.PID, p.PFName, p.PLName, d.DID, d.DFName, d.DLName, COUNT(*) AS Num_DocInCharge
FROM patient AS p
INNER JOIN admission AS a
ON p.PID = a.PID
INNER JOIN doctor AS d
ON a.DID = d.DID
GROUP BY p.PID, p.PFName, p.PLName, d.DID, d.DFName, d.DLName
;
 
# For each inpatient, list the patient’s ID, name, and all his emergency contact persons’ ID and name.
 
SELECT DISTINCT p.PID, p.PFName, p.PLName, e.ECID, e.ECFName, e.ECLName
FROM patient AS p
INNER JOIN admission AS a
ON p.PID = a.PID
INNER JOIN emergency_contact AS e
ON a.ECID = e.ECID
;
 
# For a specific inpatient’s specific admission record (you can choose anyone in your system), list all his treatments including the patient’s ID, name, the dates of the treatments, each treatment description, and each treatment’s doctor’s ID and name.
 
SELECT p.PID, p.PFName, p.PLName, t.TDate, t.TDescription, t.DID, d.DFName, d.DLName
FROM patient AS p
INNER JOIN admission AS a
ON p.PID = a.PID
INNER JOIN treatment AS t
ON t.AID = a.AID
INNER JOIN doctor AS d
ON a.DID = d.DID
WHERE p.PFName = "Michael" AND p.PLName = "Brown"
;
 
# For each doctor, list the doctor’s ID, name and all his specialties.
 
SELECT d.DID, d.DFName, d.DLName, s.SName
FROM doctor AS d
INNER JOIN doctor_specialty AS ds
ON d.DID = ds.DID
INNER JOIN specialties AS s
ON ds.SID = s.SID
;
 
# For each department, list the department name, its head doctor’s ID, name and his specialties.
 
SELECT dp.DPName, dp.DPHead, d.DFName, d.DLName, s.SName
FROM department AS dp
INNER JOIN doctor AS d
ON dp.DPHead = d.DID
INNER JOIN doctor_specialty AS ds
ON d.DID = ds.DID
INNER JOIN specialties AS s
ON s.SID = ds.SID
;
 
# For each department, list the department name, all of its doctors’ IDs, names and the number of each doctor’s specialties.
 
SELECT dp.DPName, d.DID, d.DFName, d.DLName, COUNT(ds.DID) AS Num_Specialties
FROM department AS dp
INNER JOIN doctor AS d
ON dp.DPID = d.DPID
INNER JOIN doctor_specialty AS ds
ON d.DID = ds.DID
GROUP BY dp.DPName, d.DID, d.DFName, d.DLName
ORDER BY d.DID
;
