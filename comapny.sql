CREATE DATABASE SoftwareCompany;
USE SoftwareCompany;

CREATE TABLE Clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(100) NOT NULL,
    client_contact VARCHAR(100)
);

CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    employee_role VARCHAR(100) NOT NULL
);

CREATE TABLE Projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    client_id INT,
    team_lead_id INT,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (team_lead_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL
);

CREATE TABLE Project_Team (
    project_id INT,
    team_id INT,
    PRIMARY KEY (project_id, team_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

CREATE TABLE Project_Employee (
    project_id INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Data Insertion
INSERT INTO Clients (client_name, client_contact) VALUES 
('Client A', 'contact@clienta.com'),
('Client B', 'contact@clientb.com');

INSERT INTO Employees (employee_name, employee_role) VALUES 
('Alice', 'Developer'),
('Bob', 'Designer'),
('Charlie', 'Team Lead'),
('David', 'Developer');

INSERT INTO Projects (project_name, client_id, team_lead_id) VALUES 
('Project 1', 1, 3),
('Project 2', 2, 3);

INSERT INTO Teams (team_name) VALUES 
('Team Alpha'),
('Team Beta');

INSERT INTO Project_Team (project_id, team_id) VALUES 
(1, 1),
(2, 2);

INSERT INTO Project_Employee (project_id, employee_id) VALUES 
(1, 1),
(1, 2),
(2, 4);

-- Queries
SELECT p.project_name, c.client_name
FROM Projects p
JOIN Clients c ON p.client_id = c.client_id;

-- Views
CREATE VIEW ProjectDetails AS
SELECT p.project_id, p.project_name, c.client_name, e.employee_name AS team_lead
FROM Projects p
JOIN Clients c ON p.client_id = c.client_id
JOIN Employees e ON p.team_lead_id = e.employee_id;

-- Stored Procedure
DELIMITER //
CREATE PROCEDURE GetProjectEmployees(IN proj_id INT)
BEGIN
    SELECT e.employee_name
    FROM Employees e
    JOIN Project_Employee pe ON e.employee_id = pe.employee_id
    WHERE pe.project_id = proj_id;
END //
DELIMITER ;

-- Function
DELIMITER //
CREATE FUNCTION GetClientProjects(clientId INT) RETURNS INT
BEGIN
    DECLARE projectCount INT;
    SELECT COUNT(*) INTO projectCount FROM Projects WHERE client_id = clientId;
    RETURN projectCount;
END //
DELIMITER ;

-- Trigger
DELIMITER //
CREATE TRIGGER before_project_insert
BEFORE INSERT ON Projects
FOR EACH ROW
BEGIN
    DECLARE clientExist INT;
    SELECT COUNT(*) INTO clientExist FROM Clients WHERE client_id = NEW.client_id;
    IF clientExist = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client does not exist';
    END IF;
END //
DELIMITER ;