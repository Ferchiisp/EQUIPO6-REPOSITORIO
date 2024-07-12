CREA TABLE ESPECIALIDADES(
IdEspecialidades SERIAL,
Nombre VARCHAR(30) NOT NULL,
PRIMARY KEY(IdEspecialidades));

CREATE TABLE MEDICOS(
IdMedicos SERIAL,
Idspecialidades INT NOT NULL,
Nombre VARCHAR (25) NOT NULL,
ApPaterno VARCHAR(25) NOT NULL,
ApMaterno VARCHAR(25) NOT NULL.
FechaNacimiento DATE NOT NULL,
Cedula INT UNIQUE NOT NULL,
PRIMARY KEY(IsMedicos),
FOREIGN KEY(IdEspecialidades) REFERENCES ESPECIALIDADES(IdEspecialidades)
);

    CREATE TABLE PACIENTES(
	IdPacientes INT NOT NULL,
    NombreCompleto TEXT NOT NULL,
    FechaNacimiento DATE NOT NULL,
    NSS VARCHAR(11) UNIQUE NOT NULL,
    Created_at TIMESTAMP DEFAULT NOW(),
    modified_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (IdPaciente));
	
	CREATE TABLE INGRESOS(
	Id SERIAL,
	IdMedico INT NOT NULL,
	IdPaciente INT NOT NULL,
	Habitacion INT NOT NULL,
	cama INT NOT NULL,
	FechaIngreso TIMESTAMP, DEFAULT NOW(),
	created_at TIMESTAMP DEFAULT NOW()
	modified_at TIMESTAMP DEFAULT NOOW(),
	PRIMARY KEY(Id),
	FOREIGN KEY (IdMedico) REFERENCES MEDICOS(IdMedicos),
	FOREIGN KEY (IdPaciente) REFERENCES PACIENTES(IdPacientes),
	);
	
	
	CREATE TABLE log_Pacientes_Ingresos(
	    Id           SERIAL,
	    table_name   TEXT NOT NULL,
	    table_Id     TEXT NOT NULL,
	    description TEXT NOT NULL,
		created_at TIMESTAMP DEFAULT NOW(),
		PRIMARY KEY (Id)
	);
	
	
	
	CREATE OR REPLACE FUNCTION Ingreso_Pacientes()RETURN trigger AS $BODY$
	DECLARE
	  vDescription TEXT;
	  vId INT;
	  vReturn RECORD;
	BEGIN
	   vDescription := TG_TABLE_NAME ||' ';
	   IF(TG_OP = 'INSERT') THEN
	     vId := NEW.Id;
		 vDescription :=vDescription ||  'addesd. Id: ' || vId;
		 vReturn :=NEW;
	   ELSIF(TG_OP = 'UPDATE') THEN
	     vId := OLD.Id;
		 vDescription :=vDescription ||  'updated. Id: ' || vId;
		 vReturn :=OLD;
	   END IF;
	   
	   
	 RAISE NOTICE 'TRIGGER called on % -Log: %', TG_TABLE_NAME, vDescription;
	 
	 INSERT INTO log_pacientes_ingresos
	      (table_name, table_id, description, created_at)
		  VALUES
		  (TG_TABLE_NAME, vId, vDescription, NOW());
		  
	   RETURN vReturn;
	END %BODY% LANGUAGE plpgsql;
	
	
	
	
	CREATE TRIGGER Trigger_Ingreso_Paciente
	After INSERT OOR UPDATE OR DELETE 
	ON INGRESOS
	FOR EACH ROW
	EXECUTE PROCEDURE Ingresi_Pacientes();
	
	
	BEGIN;
	INSERT INTO ESPECIALIDADES (Nombre)
	values('Dermatologo'),
	('Pediatra'),
	('Urologo'),
	('Cardiologo'),
	('Ortodoncista'),
	COMMIT;
	
	
	
	BEGIN
	INSERT INTO MEDICOS(IdEspecialidades,Nombre,ApPaterno,ApMaterno,FechaNacimento,Cedula)
	VALUES(1,'Viridiana','Escobar','Garcia','1983-09-11',4897752),
	(4,'Jesus','Flores','Luna','2000-09-25',3568974),
	(4,'Ursula','Prats','Carmona','19798-01-23',5689742),
	(3,'Marco Alfredo','Lopez','Zetina','1974-03-112',9657127),
	(5,'Uriel','Flores','Luna','1997-89-26',7778963);
	COMMIT;
	
	
	
	
	