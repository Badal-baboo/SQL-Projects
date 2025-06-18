use hospital;
create database HOSPITALDB;

-- Step 2: Create tables
-- Department table: Stores department details and head physician
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    head_physician INT,
    FOREIGN KEY (head_physician) REFERENCES Physician(physician_id)
);

-- Physician table: Stores physician details
CREATE TABLE Physician (
    physician_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    ssn VARCHAR(11) UNIQUE
);

-- Affiliated_with table: Links physicians to departments
CREATE TABLE Affiliated_with (
    physician_id INT,
    dept_id INT,
    primary_affiliation BOOLEAN,
    PRIMARY KEY (physician_id, dept_id),
    FOREIGN KEY (physician_id) REFERENCES Physician(physician_id),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- Medical_Procedure table: Stores procedure details (renamed from Procedure to avoid keyword conflict)
CREATE TABLE Medical_Procedure (
    code INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost DECIMAL(10, 2)
);

-- Trained_in table: Links physicians to procedures they are trained in
CREATE TABLE Trained_in (
    physician_id INT,
    procedure_code INT,
    PRIMARY KEY (physician_id, procedure_code),
    FOREIGN KEY (physician_id) REFERENCES Physician(physician_id),
    FOREIGN KEY (procedure_code) REFERENCES Medical_Procedure(code)
);

-- Patient table: Stores patient details
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15),
    insurance_id VARCHAR(50)
);

-- Nurse table: Stores nurse details
CREATE TABLE Nurse (
    nurse_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    registered BOOLEAN,
    ssn VARCHAR(11) UNIQUE
);

-- Appointment table: Stores appointment details
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    physician_id INT,
    nurse_id INT,
    start_time DATETIME,
    end_time DATETIME,
    examination_room VARCHAR(10),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (physician_id) REFERENCES Physician(physician_id),
    FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_id)
);

-- Medication table: Stores medication details
CREATE TABLE Medication (
    code INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(50),
    description TEXT
);

-- Prescribes table: Links physicians, patients, and medications
CREATE TABLE Prescribes (
    physician_id INT,
    patient_id INT,
    medication_code INT,
    date_prescribed DATE,
    dose VARCHAR(50),
    PRIMARY KEY (physician_id, patient_id, medication_code),
    FOREIGN KEY (physician_id) REFERENCES Physician(physician_id),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (medication_code) REFERENCES Medication(code)
);

-- Block table: Stores hospital block details
CREATE TABLE Block (
    block_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Room table: Stores room details
CREATE TABLE Room (
    room_number INT,
    block_id INT,
    room_type VARCHAR(50),
    unavailable BOOLEAN,
    PRIMARY KEY (room_number, block_id),
    FOREIGN KEY (block_id) REFERENCES Block(block_id)
);

-- On_call table: Stores nurse on-call schedules
CREATE TABLE On_call (
    nurse_id INT,
    block_id INT,
    on_call_start DATETIME,
    on_call_end DATETIME,
    PRIMARY KEY (nurse_id, block_id, on_call_start),
    FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_id),
    FOREIGN KEY (block_id) REFERENCES Block(block_id)
);

-- Stay table: Stores patient stay details
CREATE TABLE Stay (
    stay_id INT PRIMARY KEY,
    patient_id INT,
    room_number INT,
    block_id INT,
    stay_start DATE,
    stay_end DATE,
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (room_number, block_id) REFERENCES Room(room_number, block_id)
);

-- Undergoes table: Links patients, procedures, stays, and physicians
CREATE TABLE Undergoes (
    patient_id INT,
    procedure_code INT,
    stay_id INT,
    physician_id INT,
    date_performed DATE,
    PRIMARY KEY (patient_id, procedure_code, date_performed),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (procedure_code) REFERENCES Medical_Procedure(code),
    FOREIGN KEY (stay_id) REFERENCES Stay(stay_id),
    FOREIGN KEY (physician_id) REFERENCES Physician(physician_id)
);

-- Step 3: Insert records into tables

-- Physician records
INSERT INTO Physician (physician_id, name, position, ssn) VALUES
(1, 'Dr. Smith', 'Cardiologist', '123-45-6789'),
(2, 'Dr. Adams', 'Neurologist', '234-56-7890'),
(3, 'Dr. Clark', 'Surgeon', '345-67-8901'),
(4, 'Dr. Lewis', 'Dermatologist', '456-78-9012'),
(5, 'Dr. Johnson', 'Pediatrician', '567-89-0123');

-- Department records
INSERT INTO Department (dept_id, name, head_physician) VALUES
(1, 'Cardiology', 1),
(2, 'Neurology', 2),
(3, 'Surgery', 3),
(4, 'Dermatology', 4),
(5, 'Pediatrics', 5);

-- Affiliated_with records
INSERT INTO Affiliated_with (physician_id, dept_id, primary_affiliation) VALUES
(1, 1, TRUE),
(2, 2, TRUE),
(3, 3, TRUE),
(4, 4, TRUE),
(5, 5, TRUE);

-- Medical_Procedure records
INSERT INTO Medical_Procedure (code, name, cost) VALUES
(101, 'Angioplasty', 12000.00),
(102, 'EEG', 800.00),
(103, 'Appendectomy', 5000.00),
(104, 'Skin Biopsy', 450.00),
(105, 'Immunization', 100.00);

-- Trained_in records
INSERT INTO Trained_in (physician_id, procedure_code) VALUES
(1, 101),
(2, 102),
(3, 103),
(4, 104),
(5, 105);

-- Patient records
INSERT INTO Patient (patient_id, name, address, phone, insurance_id) VALUES
(1, 'John Doe', '123 Main St', '555-1111', 'INS123'),
(2, 'Jane Smith', '456 Elm St', '555-2222', 'INS124'),
(3, 'Alice Johnson', '789 Oak St', '555-3333', 'INS125'),
(4, 'Bob Lee', '321 Maple St', '555-4444', 'INS126'),
(5, 'Carol King', '654 Pine St', '555-5555', 'INS127');

-- Nurse records
INSERT INTO Nurse (nurse_id, name, position, registered, ssn) VALUES
(1, 'Nancy White', 'Head Nurse', TRUE, '999-11-1111'),
(2, 'Mike Brown', 'Staff Nurse', TRUE, '999-22-2222'),
(3, 'Susan Green', 'Staff Nurse', FALSE, '999-33-3333'),
(4, 'James Blue', 'ICU Nurse', TRUE, '999-44-4444'),
(5, 'Linda Black', 'ER Nurse', TRUE, '999-55-5555');

-- Appointment records
INSERT INTO Appointment (appointment_id, patient_id, physician_id, nurse_id, start_time, end_time, examination_room) VALUES
(1, 1, 1, 1, '2023-06-01 09:00:00', '2023-06-01 09:30:00', 'A1'),
(2, 2, 2, 2, '2023-06-01 10:00:00', '2023-06-01 10:30:00', 'A2'),
(3, 3, 3, 3, '2023-06-01 11:00:00', '2023-06-01 11:30:00', 'A3'),
(4, 4, 4, 4, '2023-06-01 12:00:00', '2023-06-01 12:30:00', 'A4'),
(5, 5, 5, 5, '2023-06-01 13:00:00', '2023-06-01 13:30:00', 'A5');

-- Medication records
INSERT INTO Medication (code, name, brand, description) VALUES
(201, 'Aspirin', 'Bayer', 'Pain relief'),
(202, 'Amoxicillin', 'Moxatag', 'Antibiotic'),
(203, 'Ibuprofen', 'Advil', 'Anti-inflammatory'),
(204, 'Lisinopril', 'Zestril', 'Blood pressure'),
(205, 'Metformin', 'Glucophage', 'Diabetes');

-- Prescribes records
INSERT INTO Prescribes (physician_id, patient_id, medication_code, date_prescribed, dose) VALUES
(1, 1, 201, '2023-06-01', '100mg'),
(2, 2, 202, '2023-06-02', '250mg'),
(3, 3, 203, '2023-06-03', '200mg'),
(4, 4, 204, '2023-06-04', '10mg'),
(5, 5, 205, '2023-06-05', '500mg');

-- Block records
INSERT INTO Block (block_id, name) VALUES
(1, 'North Wing'),
(2, 'East Wing'),
(3, 'South Wing'),
(4, 'West Wing'),
(5, 'Central Wing');

-- Room records
INSERT INTO Room (room_number, block_id, room_type, unavailable) VALUES
(101, 1, 'Single', FALSE),
(102, 2, 'Double', FALSE),
(103, 3, 'ICU', TRUE),
(104, 4, 'ER', FALSE),
(105, 5, 'General', FALSE);

-- On_call records
INSERT INTO On_call (nurse_id, block_id, on_call_start, on_call_end) VALUES
(1, 1, '2023-06-01 08:00:00', '2023-06-01 16:00:00'),
(2, 2, '2023-06-01 08:00:00', '2023-06-01 16:00:00'),
(3, 3, '2023-06-01 08:00:00', '2023-06-01 16:00:00'),
(4, 4, '2023-06-01 08:00:00', '2023-06-01 16:00:00'),
(5, 5, '2023-06-01 08:00:00', '2023-06-01 16:00:00');

-- Stay records
INSERT INTO Stay (stay_id, patient_id, room_number, block_id, stay_start, stay_end) VALUES
(1, 1, 101, 1, '2023-06-01', '2023-06-05'),
(2, 2, 102, 2, '2023-06-02', '2023-06-06'),
(3, 3, 103, 3, '2023-06-03', '2023-06-07'),
(4, 4, 104, 4, '2023-06-04', '2023-06-08'),
(5, 5, 105, 5, '2023-06-05', '2023-06-09');

-- Undergoes records
INSERT INTO Undergoes (patient_id, procedure_code, stay_id, physician_id, date_performed) VALUES
(1, 101, 1, 1, '2023-06-02'),
(2, 102, 2, 2, '2023-06-03'),
(3, 103, 3, 3, '2023-06-04'),
(4, 104, 4, 4, '2023-06-05'),
(5, 105, 5, 5, '2023-06-06');

show tables;
#Questions
-- List all departments along with the names of their head physicians.
SELECT Department.dept_id, Department.name, Physician.name AS Head_Physicians
FROM Department
JOIN Physician ON Department.head_physician = Physician.physician_id;

-- 2  List all physicians and the departments they are affiliated with.
SELECT Physician.physician_id, Physician.name, Department.name
FROM Physician
LEFT JOIN Affiliated_with ON Physician.physician_id = Affiliated_with.physician_id
LEFT JOIN Department ON Affiliated_with.dept_id = Department.dept_id;

select * from physician;

-- 3 Show the name of each patient along with the name of the physician who conducted their appointment.
SELECT Patient.name, Physician.name
FROM Patient
JOIN Appointment ON Patient.patient_id = Appointment.patient_id
JOIN Physician ON Appointment.physician_id = Physician.physician_id;

-- 4 List all procedures along with the names of physicians trained in them.
SELECT Medical_Procedure.code, Medical_Procedure.name, Physician.name
FROM Medical_Procedure
LEFT JOIN Trained_in ON Medical_Procedure.code = Trained_in.procedure_code
LEFT JOIN Physician ON Trained_in.physician_id = Physician.physician_id;

-- 5 Show all nurses who were on call in each block.
SELECT Nurse.name AS nurse_name, Block.name AS block_name
FROM Nurse
JOIN On_call ON Nurse.nurse_id = On_call.nurse_id
JOIN Block ON On_call.block_id = Block.block_id;

-- 6 List all patients along with the medications prescribed to them and the prescribing physician’s name.
SELECT Patient.name AS patient_name, Medication.name AS medication_name, Physician.name AS physician_name
FROM Patient
LEFT JOIN Prescribes ON Patient.patient_id = Prescribes.patient_id
LEFT JOIN Medication ON Prescribes.medication_code = Medication.code
LEFT JOIN Physician ON Prescribes.physician_id = Physician.physician_id;

-- 7 Show the room details for each stay of a patient.

SELECT Patient.name AS patient_name, Stay.stay_id, Stay.stay_start, Stay.stay_end, Room.room_number, Room.block_id, Room.room_type, Room.unavailable
FROM Patient
JOIN Stay ON Patient.patient_id = Stay.patient_id
JOIN Room ON Stay.room_number = Room.room_number AND Stay.block_id = Room.block_id;

-- 8 List all appointments with patient names, physician names, and nurse names.

SELECT Appointment.appointment_id, Patient.name AS patient_name, Physician.name AS physician_name, Nurse.name AS nurse_name
FROM Appointment
JOIN Patient ON Appointment.patient_id = Patient.patient_id
JOIN Physician ON Appointment.physician_id = Physician.physician_id
JOIN Nurse ON Appointment.nurse_id = Nurse.nurse_id;

-- 9 List physicians who are affiliated with more than one department.

SELECT Physician.physician_id, Physician.name AS physician_name, COUNT(Affiliated_with.dept_id) AS department_count
FROM Physician
JOIN Affiliated_with ON Physician.physician_id = Affiliated_with.physician_id
GROUP BY Physician.physician_id, Physician.name
HAVING COUNT(Affiliated_with.dept_id) > 1;

-- 10 Display all procedures each patient has undergone, along with the physician who performed them.
SELECT Patient.name AS patient_name, Medical_Procedure.name AS procedure_name, Physician.name AS physician_name
FROM Patient
JOIN Undergoes ON Patient.patient_id = Undergoes.patient_id
JOIN Medical_Procedure ON Undergoes.procedure_code = Medical_Procedure.code
JOIN Physician ON Undergoes.physician_id = Physician.physician_id;

-- 11 List all nurses who were on call during the appointment time of any patient.
SELECT DISTINCT Nurse.name AS nurse_name
FROM Nurse
JOIN On_call ON Nurse.nurse_id = On_call.nurse_id
JOIN Appointment ON On_call.on_call_start <= Appointment.end_time AND On_call.on_call_end >= Appointment.start_time;

select * from On_call;
select * from Nurse;

-- 12 Show the names of physicians and the procedures they are trained in but haven’t performed yet.

SELECT Physician.name AS physician_name, Medical_Procedure.name AS procedure_name
FROM Physician
JOIN Trained_in ON Physician.physician_id = Trained_in.physician_id
JOIN Medical_Procedure ON Trained_in.procedure_code = Medical_Procedure.code
LEFT JOIN Undergoes ON Trained_in.physician_id = Undergoes.physician_id 
AND Trained_in.procedure_code = Undergoes.procedure_code
WHERE Undergoes.procedure_code IS NULL;

select * from Trained_in;
select * from Medical_Procedure;
select * from Undergoes;

#every Procedure is performed so thee table is showing null.

-- 13 List all patients who had a stay in an unavailable room.
SELECT Patient.name AS patient_name, Room.room_number, Room.block_id
FROM Patient
JOIN Stay ON Patient.patient_id = Stay.patient_id
JOIN Room ON Stay.room_number = Room.room_number AND Stay.block_id = Room.block_id
WHERE Room.unavailable = True ;

-- 14 List all patients who were prescribed medications not related to the department of the prescribing physician.

SELECT Patient.name AS patient_name, Medication.name AS medication_name, Physician.name AS physician_name, Department.name AS department_name
FROM Patient
JOIN Prescribes ON Patient.patient_id = Prescribes.patient_id
JOIN Medication ON Prescribes.medication_code = Medication.code
JOIN Physician ON Prescribes.physician_id = Physician.physician_id
JOIN Affiliated_with ON Physician.physician_id = Affiliated_with.physician_id
JOIN Department ON Affiliated_with.dept_id = Department.dept_id
WHERE Affiliated_with.primary_affiliation = TRUE;

-- 15 List the names of physicians who prescribed medications to patients but never performed a procedure on them.

SELECT DISTINCT Physician.name AS physician_name
FROM Physician
JOIN Prescribes ON Physician.physician_id = Prescribes.physician_id
LEFT JOIN Undergoes ON Physician.physician_id = Undergoes.physician_id
WHERE Undergoes.physician_id IS NULL;

# The empty result is expected because every physician in the Prescribes table has a corresponding record in the Undergoes table, indicating they performed a procedure.

-- 16 Find departments that do not have any affiliated physicians.

SELECT Department.dept_id, Department.name AS department_name
FROM Department
LEFT JOIN Affiliated_with ON Department.dept_id = Affiliated_with.dept_id
WHERE Affiliated_with.physician_id IS NULL;

-- 17 Show patients who have undergone a procedure and also had an appointment with the same physician.

SELECT Patient.name AS patient_name, Physician.name AS physician_name
FROM Patient
JOIN Undergoes ON Patient.patient_id = Undergoes.patient_id
JOIN Appointment ON Patient.patient_id = Appointment.patient_id
JOIN Physician ON Undergoes.physician_id = Physician.physician_id AND Appointment.physician_id = Physician.physician_id;

-- 18 Find the total cost of procedures each patient has undergone.
SELECT Patient.name AS patient_name, SUM(Medical_Procedure.cost) AS total_cost
FROM Patient
JOIN Undergoes ON Patient.patient_id = Undergoes.patient_id
JOIN Medical_Procedure ON Undergoes.procedure_code = Medical_Procedure.code
GROUP BY Patient.patient_id, Patient.name;

-- 19 Find the count of different procedures each physician is trained in and how many they’ve performed.
SELECT Physician.name AS physician_name, 
    COUNT(DISTINCT Trained_in.procedure_code) AS trained_procedure_count, 
    COUNT(DISTINCT Undergoes.procedure_code) AS performed_procedure_count
FROM Physician
LEFT JOIN Trained_in ON Physician.physician_id = Trained_in.physician_id
LEFT JOIN Undergoes ON Physician.physician_id = Undergoes.physician_id
GROUP BY Physician.physician_id, Physician.name;

-- List all patients with multiple stays in different blocks, along with the names of the blocks.

SELECT Patient.name AS patient_name, GROUP_CONCAT(Block.name) AS block_names
FROM Patient
JOIN Stay ON Patient.patient_id = Stay.patient_id
JOIN Block ON Stay.block_id = Block.block_id
GROUP BY Patient.patient_id, Patient.name
HAVING COUNT(DISTINCT Stay.block_id) > 1;
#each patient in the Stay table has only one stay, and thus no patient has stays in multiple blocks.
# lets check after inserting 
INSERT INTO Stay (stay_id, patient_id, room_number, block_id, stay_start, stay_end)
VALUES (6, 1, 102, 2, '2023-06-10', '2023-06-12'); 
#the query run sucessfully 