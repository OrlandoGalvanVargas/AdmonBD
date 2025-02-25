-- Creación de una base de datos

create database paquitabd
on primary 
(
 Name = paquitabdData, filename = 'C:\DataNueva\paquitabd.mdf'
 ,size = 50MB -- EL tamaño minimo es de 512kb, el predeterminado es 1MB
 ,filegrowth=25% --El default es 10%, El minimo es de 64KB
 ,maxsize = 400MB
 
)
log on
(
	Name=paquitabdLog, filename = 'C:\LogNuevo\paquitabd_log_ldf'
	,size = 25MB
	,filegrowth=25%
)

-- Crear un archivo adicional
alter database paquitabd
ADD FILE
(
	NAME = 'PaquitaDataNDF',
	FILENAME = 'C:\DataNueva\paquitabd2.ndf',
	SIZE = 25MB,
	MAXSIZE=500MB,
	FILEGROWTH = 10MB --El minimo es de 64KB

)TO FILEGROUP[PRIMARY];

-- Creación de un filegroup adicional

ALTER DATABASE paquitabd
ADD FILEGROUP SECUNDARIO
GO 

-- Creación de un archivo asociado al filegroup

ALTER DATABASE paquitabd
ADD FILE (
	NAME = 'paquitabd_parte1',
	FILENAME = 'C:\DataNueva\paquitabd_SECUNDARIO.ndf'
)TO FILEGROUP SECUNDARIO

-- Crear una tabla en el grupo de archivos (filegroups) Secundario

USE paquitabd;
CREATE TABLE ratadedospatas(
	id INT NOT NULL IDENTITY(1,1),
	nombre NVARCHAR(100) NOT NULL,
	CONSTRAINT pc_ratadedospatas
	PRIMARY KEY (id),
	CONSTRAINT unico_nombre
	UNIQUE(nombre)
)ON Secundario -- Especificamos el grupo de archivo

-- Modificar el Grupo Primario

USE paquitabd;
CREATE TABLE bichorastrero(
	id INT NOT NULL IDENTITY(1,1),
	nombre NVARCHAR(100) NOT NULL,
	CONSTRAINT pc_animalrastrero
	PRIMARY KEY (id),
	CONSTRAINT unico_nombre2
	UNIQUE(nombre)
)

DROP TABLE bichorastrero;

-- Modificar el Grupo Primario

USE MASTER

ALTER DATABASE paquitabd
MODIFY FILEGROUP [SECUNDARIO] DEFAULT

USE paquitabd
CREATE TABLE comparadocontigo(
	id INT NOT NULL IDENTITY(1,1),
	nombredelbicho NVARCHAR(100) NOT NULL,
	defectos VARCHAR(MAX) NOT NULL,
	CONSTRAINT pc_comparadocontigo
	PRIMARY KEY (id),
	CONSTRAINT unico_nombre3
	UNIQUE(nombredelbicho)
)

-- Revision del estado de la opción de ajuste automatico del tamaño de archivos

SELECT DATABASEPROPERTYEX('paquitabd', 'ISAUTOSHRINK')

-- Cambia la opción de AutoShrink a True
ALTER DATABASE paquitabd
SET AUTO_SHRINK ON WITH NO_WAIT
GO


-- Revisión del estado de la opción de creación de estadisticas

SELECT DATABASEPROPERTYEX('paquitabd', 'ISAUTOCREATESTATISTICS')

ALTER DATABASE paquitabd
SET AUTO_CREATE_STATISTICS ON
GO


-- Consultar información de la base de datos

SP_helpdb paquitabd


-- Consultar la información de los grupos

use paquitabd
go
SP_helpfilegroup SECUNDARIO