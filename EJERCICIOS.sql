----DOCUMENTO E31
--TEMA: SQL SERVER
--SUBTEMA: CONSULTAS BASICAS
USE Capacitacion
--1. Realizar la siguiente consulta de Alumnos
select * from Alumnos
--2. Realizar la siguiente consulta de Instructores
select * from Instructores
--3. Realizar la siguiente consulta de CatCusos
select * from CatCursos
--4. Realizar la consulta de los 5 alumnos más jóvenes
SELECT TOP 5 * FROM Alumnos
order by fechaNacimiento desc;
--5. Crear la Base de datos Ejercicios
CREATE DATABASE Ejercicios
--6. Copiar las tablas de Alumnos e Instructores desde la Base de Datos Capacitacion a la de Ejercicios
USE Capacitacion
SELECT * INTO Ejercicios.dbo.AlumnosCopia FROM Alumnos
--otra forma
USE Ejercicios
SELECT * INTO Alumnos FROM Capacitacion.dbo.Alumnos
---------------------------------------------------
--DOCUMENTO E32
--TEMA: SQL SERVER
--SUBTEMA: CONSULTAS MULTIPLES TABLAS
USE Capacitacion
--1. Realizar la siguiente consulta de Instructores
SELECT nombre,primerApellido,segundoApellido,rfc,cuotaHora,activo FROM Instructores
--2.Realizar la siguiente consulta de Cursos
SELECT CatCursos.nombre, CatCursos.horas, Cursos.fechaInicio, Cursos.fechatermino
FROM CatCursos CROSS JOIN Cursos 
--3 Realizar la siguiente consulta de alumnos
SELECT Alumnos.nombre_alumno, Alumnos.primerApellido_alumno, Alumnos.segundoApellido_alumno, Alumnos.curp, Estados.Nombre
FROM Alumnos 
LEFT JOIN Estados ON Alumnos.idEstadoOrigen = Estados.id_Estados
UNION 
SELECT Alumnos.nombre_alumno, Alumnos.primerApellido_alumno, Alumnos.segundoApellido_alumno, Alumnos.curp, EstatusAlumnos.Nombre
FROM Alumnos 
RIGHT JOIN EstatusAlumnos ON Alumnos.idEstatus = EstatusAlumnos.id_EstatusAlumnos
WHERE Alumnos.nombre_alumno IS NOT NULL;
--4 Realizar la siguiente consulta de Instructores, en que cursos ha participado
SELECT CONCAT (inst.nombre, '' , primerApellido, '', segundoApellido) Instructores , cuotaHora, cc.nombre, fechaInicio, fechatermino
FROM Instructores AS inst
INNER JOIN CursosInstructores AS ci ON inst.id_Instructores = ci.idInstructor
INNER JOIN Cursos AS c ON c.id_Cursos = ci.idInstructor
INNER JOIN CatCursos AS cc ON c.idCatCurso = cc.id_CatCursos
--5 consulta de Alumnos, mostrando los cursos ha tomado
SELECT nombre_alumno, primerApellido_alumno, segundoApellido_alumno, 
E.nombre, cc.nombre, ca.fechaInscripcion, ca.calificacion,
c.fechaInicio, c.fechatermino 
FROM Alumnos AS A
INNER JOIN Estados AS E
ON A.idEstadoOrigen = E.id_Estados
INNER JOIN CursosAlumnos AS ca
ON ca.idAlumno= A.id_alumnos
INNER JOIN Cursos AS c
ON c.id_Cursos = ca.idCurso
INNER JOIN CatCursos AS cc
ON c.idCatCurso = cc.id_CatCursos
--6 Consulta de alumnos: Nombre y apellidos, curso, fecha inicial, 
--fecha final, calificación. Ordenado de la calificación más alta a la más baja
SELECT nombre_alumno, primerApellido_alumno, segundoApellido_alumno, 
E.nombre, cc.nombre, ca.fechaInscripcion, ca.calificacion,
c.fechaInicio, c.fechatermino 
FROM Alumnos AS A
INNER JOIN Estados AS E
ON A.idEstadoOrigen = E.id_Estados
INNER JOIN CursosAlumnos AS ca
ON ca.idAlumno= A.id_alumnos
INNER JOIN Cursos AS c
ON c.id_Cursos = ca.idCurso
INNER JOIN CatCursos AS cc
ON c.idCatCurso = cc.id_CatCursos
ORDER BY ca.calificacion DESC;
--7. Realizar la siguiente consulta de los Cursos con su correspondiente curso de prerrequisito
SELECT a.clave, a.nombre, a.horas, b.nombre
FROM CatCursos AS a
INNER JOIN CatCursos AS b 
ON a.idPreRequisito = b.id_CatCursos
--8. Realizar una consulta con los datos del alumno y curso, dentro de ellos la calificación, 
--obteniendo el nivel alcanzado 9-10 Excelente, 7-8 Bien, 6 Suficiente, <6 N/A
SELECT a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, ca.nombre, c.fechaInicio, c.fechatermino, cc.calificacion,

CASE
    WHEN calificacion > 9 THEN 'Excelente'
    WHEN calificacion =7 AND calificacion =8 THEN 'Bien'
	WHEN calificacion = 6 THEN 'suficiente' 
	WHEN calificacion <6 THEN 'N/A'
END AS nivel

FROM Alumnos AS a
INNER JOIN CursosAlumnos AS cc
ON a.id_alumnos = cc.idAlumno
INNER JOIN Cursos AS c
ON cc.idCurso = c.id_Cursos
INNER JOIN CatCursos AS ca
ON c.idCatCurso = ca.id_CatCursos
----------------------------------------
--DOCUMENTO E33
--TEMA: SQL SERVER
--SUBTEMA: FUNCIONES FECHA
--Realizar la siguiente consulta de Alumnos, con edad actual y edad en 5 Meses
SELECT nombre_alumno, primerApellido_alumno, segundoApellido_alumno, fechaNacimiento, GETDATE() AS hoy, DATEDIFF(year, fechaNacimiento, GETDATE()) AS EdadActual, DATEDIFF (YEAR, fechaNacimiento,DATEADD(MONTH,5,GETDATE())) AS Edad5Meses
FROM Alumnos 
---------------------------------------
--DOCUMENTO E34
--EJERCICIOS
--1. Realizar la siguiente Consulta con obtenida de la tabla TablaISR
--Los valores corresponden a las columnas LimInf, LimSup, CuotaFija, ExedLimInf, Subsidio respectivamente
--------------------------------------
--DOCUMENTO E36
----TEMA: SQL SERVER
--SUBTEMA: CONSULTAS FUNCIONES AGREGACION
---1.Realizar la siguiente consulta Alumnos por Estado
SELECT COUNT (idEstadoOrigen) AS TotalA, e.nombre
FROM Estados e
INNER JOIN Alumnos ON e.id_Estados = Alumnos.idEstadoOrigen
GROUP BY e.nombre
---2.Realizar la siguiente consulta Alumnos por Estatus
SELECT COUNT (idEstatus) AS Total, ea.Nombre
FROM EstatusAlumnos ea
INNER JOIN Alumnos 
ON ea.id_EstatusAlumnos = Alumnos.idEstatus
GROUP BY ea.Nombre
---3.Realizar la siguiente consulta Resumen de Calificaciones
SELECT 'Calificaciones Alumnos' AS ResumenCalificaciones, COUNT (calificacion) AS Total,
 MAX (calificacion) AS Maximo,
 MIN (calificacion) AS Minimo,
 AVG (calificacion) AS Promedio
FROM CursosAlumnos
---4.Realizar la siguiente consulta Resumen de Calificaciones por Curso
SELECT cc.nombre, c.fechaInicio, c.fechatermino, COUNT (calificacion) AS Total,
 MAX (calificacion) AS Maximo,
 MIN (calificacion) AS Minimo,
 AVG (calificacion) AS Promedio
FROM CatCursos cc
INNER JOIN Cursos c
ON cc.id_CatCursos = c.idCatCurso
INNER JOIN CursosAlumnos ca
ON c.id_Cursos = ca.idCurso
GROUP BY cc.nombre, c.fechaInicio, c.fechatermino
---5.Realizar la siguiente consulta Resumen de Calificaciones por Estado, considerando únicamente 
--a los Estados que tienen promedio mayor a 6
SELECT e.nombre, COUNT (calificacion) AS Total,
 MAX (calificacion) AS Maximo,
 MIN (calificacion) AS Minimo,
 AVG (calificacion) AS Promedio
FROM Estados e
INNER JOIN Alumnos a
ON e.id_Estados = a.idEstadoOrigen
INNER JOIN CursosAlumnos ca
ON ca.idAlumno = a.id_alumnos
where calificacion >6 
GROUP BY e.nombre
---------------------------
--DOCUMENTO E35
--EJERCICIOS
--1. Realizar la siguiente Consulta con el nombre y apellidos en Mayúsculas
SELECT UPPER (nombre_alumno) AS Nombre, UPPER (primerApellido_Alumno) AS PrimerApellido, UPPER (segundoApellido_alumno) AS SegundoApellido, UPPER (fechaNacimiento) AS FechNaci, GETDATE() AS hoy, DATEDIFF(year, fechaNacimiento, GETDATE()) AS EdadActual, DATEDIFF (YEAR, fechaNacimiento,DATEADD(MONTH,5,GETDATE())) AS Edad5Meses
FROM Alumnos
--2.Realizar la consulta Anterior agregando columna con la fecha de nacimiento extraída del CURP
SELECT a.id_alumnos, a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.fechaNacimiento, a.curp,  
CONCAT (datepart(YEAR,convert(datetime,(SUBSTRING(curp, 5,6)))), '-' , datepart(MONTH,convert(datetime,(SUBSTRING(curp, 5,6)))), '-', datepart(DAY,convert(datetime,(SUBSTRING(curp, 5,6))))) AS FechaCURP
FROM Alumnos a
--3. Realizar una consulta con los datos del alumnos y una columna adicional indicando el género con la palabra ‘Hombre’ o ‘Mujer’ según corresponda de acuerdo con lo indicado en la columna 11 del curp
SELECT a.id_alumnos, a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.fechaNacimiento, a.curp,
       CASE (SUBSTRING(curp, 11,1)) 
           WHEN 'H' THEN 'Hombre'
           WHEN 'M' THEN 'Mujer'
           ELSE 'Unknown'
       END AS Genero
FROM Alumnos a
GO
--4. Realizar la siguiente consulta de Alumnos, cambiando el correo de Gmail por hotmail
SELECT a.id_alumnos, a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.fechaNacimiento, a.correo,
REPLACE(a.correo,'gmail', 'hotmail')
FROM Alumnos a
------------------------------------------------
--DOCUMENTO E37
--TEMA: SQL SERVER
--SUBTEMA: CONSULTAS - FILTROS
--1. Alumnos cuyo apellido sea “Mendoza”
SELECT * FROM Alumnos 
WHERE primerApellido_alumno = 'Mendoza' or segundoApellido_alumno = 'Mendoza'
--2. Alumnos cuyo estatus sea “En Capacitación”
SELECT COUNT (idEstatus) AS Total, ea.Nombre
FROM EstatusAlumnos ea
INNER JOIN Alumnos 
ON ea.id_EstatusAlumnos = Alumnos.idEstatus
WHERE Nombre = 'En Capacitación'
GROUP BY ea.Nombre
--3. Instructores que sean mayores de 30 años
SELECT * FROM Instructores
WHERE DATEDIFF(YEAR, fechaNacimiento, GETDATE())>30
--4. Alumnos que estén entre 20 y 25 años
SELECT * FROM Alumnos
WHERE DATEDIFF(YEAR, fechaNacimiento, GETDATE()) >20 
     AND DATEDIFF(YEAR, fechaNacimiento, GETDATE()) <25
--5. Alumnos que sea del Estado de “Oaxaca” y su estatus sea “En Capacitación”, o que sean de “Campeche” 
--y que estén en estatus “Prospecto”
SELECT a.nombre_alumno, e.nombre, ea.Nombre
FROM Alumnos a
INNER JOIN Estados e
ON e.id_Estados = a.idEstadoOrigen
INNER JOIN EstatusAlumnos ea
ON ea.id_EstatusAlumnos = a.idEstatus
WHERE e.nombre = 'Oaxaca' or e.nombre = 'Campeche' AND ea.nombre = 'En Capacitación' or ea.nombre = 'Prospecto'
GROUP BY ea.Nombre, e.nombre, a.nombre_alumno
--6. Alumnos cuyo correo sea de gmail
SELECT * FROM Alumnos
WHERE correo LIKE '%gmail%'
--7. Alumnos que cumplen años en el mes de marzo
SELECT * FROM Alumnos
WHERE fechaNacimiento LIKE '%03%'
--8. Alumnos que cumplen 30 años dentro de 5 años en relación con la fecha actual
SELECT * FROM Alumnos
WHERE DATEDIFF (YEAR, fechaNacimiento, DATEADD(YEAR,5,GETDATE())) = 30
--9. Alumnos cuyo nombre exceda de 10 caracteres
SELECT * FROM Alumnos
WHERE LEN (nombre_alumno) > 10
--10. Alumnos cuyo último carácter del curp sea numérico
SELECT * FROM Alumnos
WHERE SUBSTRING(curp, 18,1) BETWEEN '0' and '9'
--11. Alumnos cuya calificación sea mayor que 8
SELECT a.nombre_alumno
FROM CursosAlumnos ca
INNER JOIN Alumnos a
ON ca.idAlumno = a.id_alumnos
where calificacion >8 
GROUP BY a.nombre_alumno
--12. Alumnos que se encuentren en estatus laborando o liberado con un sueldo superior a 15,000
SELECT * FROM EstatusAlumnos ea
INNER JOIN Alumnos a
ON ea.id_EstatusAlumnos = a.idEstatus
WHERE (ea.Nombre = 'Laborando' OR ea.Nombre = 'Liberado') AND a.sueldo > 15000 
--13. Alumnos cuyo año de nacimiento esté entre 1990 y 1995 y que su primer apellido empiece con B, C ó Z
SELECT * FROM Alumnos
WHERE ((datepart(YEAR,fechaNacimiento))BETWEEN 1990 AND 1995) AND primerApellido_alumno LIKE 'B%' OR primerApellido_alumno 
					LIKE 'C%' OR primerApellido_alumno LIKE 'Z%'
--14. Alumnos cuyo fecha de Nacimiento no coincide con la fecha de nacimiento del
--curp
--• Nombre del alumno • Curp • Fecha de Nacimiento
SELECT nombre_alumno, curp, fechaNacimiento 
FROM Alumnos
WHERE DATEPART (YEAR, fechaNacimiento) <> (datepart(YEAR,convert(datetime,(SUBSTRING(curp, 5,6)))))
--15. Alumnos cuyo primer apellido inicie con ‘A’ y el mes de nacimiento sea abril que tengan entre 21 y 30 años
SELECT * FROM Alumnos
WHERE (primerApellido_alumno LIKE 'A%' AND datepart(MONTH,fechaNacimiento) = 04)
AND DATEDIFF(YEAR,fechaNacimiento,GETDATE()) BETWEEN 21 AND 30
--16. Obtener una lista de alumnos que se llaman Luis aunque sea compuesto
SELECT * FROM Alumnos
WHERE nombre_alumno LIKE '%Ana%' 
--17. Obtener una consulta de los cursos que se han impartido en el año de 2021,
--nombre del curso -fecha de inicio - fecha final - cantidad de alumnos - promedio de calificaciones.
SELECT cc.nombre, c.fechaInicio, c.fechatermino, AVG (ca.calificacion) AS PromedioCalificacion, COUNT(ca. idAlumno) AS CantidadAlumnos
FROM CatCursos cc
INNER JOIN Cursos c
ON cc.id_CatCursos = c.id_Cursos 
INNER JOIN CursosAlumnos ca
ON c.idCatCurso = ca.idCurso
WHERE DATEPART(YEAR,fechaInicio) = 2021
GROUP BY ca.idCurso, cc.nombre, c.fechaInicio, c.fechatermino
--18. Realizar la siguiente consulta Resumen de Calificaciones por Estado,
--considerando únicamente a los alumnos que tienen calificación mayor a 6
--mostrando únicamente a los estados cuyo total de alumnos (con promedio
--mayor a 6) sea mayor a 1
SELECT e.nombre, COUNT(e.nombre) AS ToTaL, ca.calificacion, a.nombre_alumno
FROM Alumnos a
INNER JOIN Estados e
ON a.idEstadoOrigen = e.id_Estados
INNER JOIN CursosAlumnos ca
ON ca.idAlumno = a.id_alumnos
WHERE calificacion > 0 
GROUP BY e.nombre, ca.calificacion, a.nombre_alumno
HAVING COUNT (e.nombre) = 1

-----------------------------------------------------------
--DOCUMENTO E38
--TEMA: SQL SERVER
--SUBTEMA: SUBCONSULTAS
--EJERCICIOS
--1. Obtener el nombre del alumno cuya longitud es la más grande
SELECT nombre_alumno FROM Alumnos
WHERE LEN (nombre_alumno) = (SELECT MAX(LEN(nombre_alumno))FROM Alumnos)
--2. Mostrar el o los alumnos menos jóvenes
SELECT * FROM Alumnos
WHERE fechaNacimiento = (SELECT DATEDIFF(year, fechaNacimiento, GETDATE()) FROM Alumnos)
--3. Obtener una lista de los alumnos que tuvieron la máxima calificación
SELECT * FROM Alumnos
WHERE id_alumnos = (SELECT MAX(calificacion) FROM CursosAlumnos)
--4. Obtener la siguiente consulta con los datos de cada uno de los cursos
SELECT cc.nombre, cu.fechaInicio, cu.fechaTermino, COUNT(A.id_alumnos) AS total, MAX(ca.calificacion) AS cmax,
MIN(ca.calificacion) AS cmin, AVG(ca.calificacion) AS promedio FROM CatCursos cc
INNER JOIN (SELECT id_Cursos, idCatCurso, fechaInicio, fechaTermino FROM Cursos) AS cu ON cu.idCatCurso = cc.id_CatCursos
INNER JOIN (SELECT idCurso, idAlumno, id_CursosAlumnos, calificacion FROM CursosAlumnos) AS ca ON ca.idCurso = cu.id_Cursos
INNER JOIN Alumnos a ON a.id_alumnos = ca.idAlumno GROUP BY cc.nombre, cu.fechaInicio, cu.fechaTermino; 
--5. Obtener una consulta de los alumnos que tienen una calificación igual o menor que el promedio de calificaciones.
SELECT * FROM Alumnos 
WHERE id_alumnos IN (SELECT id_alumnos FROM CursosAlumnos
WHERE calificacion<= (SELECT AVG(calificacion) FROM CursosAlumnos));
--6. Obtener una lista de los alumnos que tuvieron la máxima calificación en cada uno de los cursos.
SELECT a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.fechaNacimiento, 
	cc.Nombre AS Curso, c.fechaInicio, c.fechatermino, acm.calificacion
FROM Alumnos a INNER JOIN 
(SELECT ca.idCurso, ca.idAlumno, ca.calificacion
FROM CursosAlumnos ca INNER JOIN
(SELECT idCurso, MAX(calificacion)AS mc
FROM CursosAlumnos ca
GROUP BY idCurso) AS cm
ON ca.idCurso = cm.idCurso AND ca.calificacion = cm.mc) AS acm
ON a.id_alumnos = acm.idAlumno INNER JOIN Cursos c
ON acm.idCurso = c.id_Cursos INNER JOIN CatCursos cc
ON c.idCatCurso = cc.id_CatCursos
----------------------------------------------
--DOCUMENTO E39
--1. Obtener una consulta que contenga el Nombre y apellidos, 
--mes y día de nacimiento de todos los alumnos y profesores, 
--ordenado por tipo mes y día de nacimiento
SELECT 'Alumno' AS TipoPersona, nombre_alumno, primerApellido_alumno, segundoApellido_alumno, fechaNAcimiento,
datepart(MONTH,fechaNacimiento) AS Mes, datepart(DAY,fechaNacimiento) AS Dia
FROM Alumnos 
UNION
SELECT 'Profesor' AS TipoPersona, nombre, primerApellido, segundoApellido, fechaNacimiento,
datepart(MONTH,fechaNacimiento) As Mes, datepart(DAY,fechaNacimiento) AS Dia
FROM Instructores ORDER BY Mes, Dia ASC;
----------------------------------------------------------------
--DOCUMENTO E41
--TEMA: SQL SERVER
--SUBTEMA: ACTUALIZACIONES
--EJERCICIOS
--1. Actualizar el estatus del Alumnos de los que están en propedéutico a capacitación
SELECT * FROM EstatusAlumnos
UPDATE EstatusAlumnos 
	SET Clave = 'CAP', Nombre = 'En capacitación'
	FROM EstatusAlumnos
	WHERE Nombre = 'En curso propedéutico'
--2. Actualizar el segundo apellido del Alumno a Mayúsculas
SELECT * FROM Alumnos
UPDATE Alumnos 
	SET segundoApellido_alumno = UPPER(RTRIM(segundoApellido_alumno))
	FROM Alumnos
--3. Actualizar el segundo Apellido para que la primera letra sea mayúsculas y el resto minúsculas
SELECT * FROM Alumnos
UPDATE Alumnos 
	SET segundoApellido_alumno = UPPER(LEFT(segundoApellido_alumno, 1))
							   + LOWER(SUBSTRING(segundoApellido_alumno, 2, LEN(segundoApellido_alumno)))
	FROM Alumnos
--4. Actualizar el número telefónico de los instructores para que los dos primeros dígitos sean 55, en caso de que de acuerdo al curp sean del DF
SELECT * FROM Instructores

UPDATE Instructores
	SET telefono = REPLACE (telefono, SUBSTRING(telefono, 1, 2),'55' )
	FROM Instructores
	WHERE SUBSTRING(curp, 12,2) = 'DF' 
--5. Subirles un punto en la calificación a los alumnos de Hidalgo y Oaxaca, y del Curso impartido en junio de 2021. 
--Se deberá considerar que al incrementar el punto no exceda del máximo de la calificación permitida.
SELECT * FROM CursosAlumnos

UPDATE CursosAlumnos 
SET calificacion = IIF(calificacion>=10, calificacion, calificacion+1)
WHERE idAlumno IN (SELECT id_alumnos FROM Alumnos
WHERE (idEstadoOrigen=19 OR idEstadoOrigen=12) AND idCurso=1);
--6. Subirle el 10% de la cuota por hora a los profesores que han impartido el curso de Desarrollador .Net
SELECT * FROM Instructores

UPDATE Instructores 
SET cuotaHora = cuotaHora + (cuotaHora * .10)
WHERE id_Instructores IN (SELECT idInstructor FROM CursosInstructores
WHERE idCurso=1)
--7. En la Base de Datos Ejercicios realice lo siguiente:
--a. Copiar la Tabla de Alumnos de la Base de Datos InstitutoTich a la Tabla AlumnosTodos
USE Capacitacion
SELECT * INTO AlumnosTodos FROM Capacitacion.dbo.Alumnos
--b. Copiar a los alumnos de Hidalgo de la Tabla de Alumnos de la Base de Datos InstitutoTich a la Tabla AlumnosHgo
USE Capacitacion
SELECT * INTO AlumnosHgo
FROM Capacitacion.dbo.Alumnos
WHERE Alumnos.idEstadoOrigen = '12'
--c. En la Tabla AlumnosHgo cambiarles el número telefónico inicie con 77, mediante la instrucción update
USE Capacitacion
UPDATE AlumnosHgo
SET telefono = REPLACE (telefono, SUBSTRING(telefono, 1, 2),'77' )
	FROM AlumnosHgo
	SELECT * FROM AlumnosHgo
--d. Actualizar el teléfono de la tabla AlumnosTodos obtenidos desde la taba AlumnosHgo
USE Capacitacion
SELECT * FROM AlumnosTodos

UPDATE AlumnosTodos
SET telefono = REPLACE (telefono,SUBSTRING(telefono, 1, 10),'0000000')
WHERE id_alumnos IN (SELECT id_alumnos FROM AlumnosHgo)
------------------------------------------------------------------
--DOCUMENTO 51
--TEMA: SQL SERVER
--SUBTEMA: FUNCIONES ESCALARES
--1. Crear una función Suma que reciba dos números enteros y regrese la suma de ambos números
CREATE FUNCTION Suma (
@VALOR_1 FLOAT,
@VALOR_2 FLOAT
)
RETURNS FLOAT
AS

BEGIN
DECLARE @RESULTADO FLOAT;
SET @RESULTADO = (@VALOR_1+@VALOR_2 );
RETURN @RESULTADO;
END
GO
---------
select dbo.Suma (5,4)
--2. Crear la función GetGenero la cual reciba como parámetros el curp y regrese el género al que pertenece
alter function GetGenero(
@curp varchar (18)
)
returns varchar(6)
as
begin
declare @genero char(2), @dato varchar(6);
set @genero= SUBSTRING(@curp,11,1);
if @genero = 'H' set @dato = 'Hombre'
if @genero = 'M' set @dato = 'Mujer'
return @dato;
end
go

SELECT dbo.GetGenero('MADA971212MVZRMN04')
--3. Crear la función GetFechaNacimien
alter function GetFechaNacimiento(
@curp varchar  (18)
)
returns date
as
begin
declare @anio varchar (6), @dato date;
set @anio= SUBSTRING(@curp,5,6);
set @dato= Convert (date, @anio);
return @dato;
end
go

SELECT dbo.GetFechaNacimiento('MADA971212MVZRMN04')
--4. Crear la función GetidEstado la cual reciba como
ALTER function GetidEstado(
@curp varchar  (18)
)
returns varchar(2)
as
begin
declare @etdo varchar (2), @id int;
set @etdo= SUBSTRING(@curp,12,2);
if @etdo = 'AS' set @id = '1'
if @etdo = 'BC' set @id = '2'
if @etdo = 'BS' set @id = '3'
if @etdo = 'CC' set @id = '4'
if @etdo = 'CH' set @id = '5'
if @etdo = 'CS' set @id = '6'
if @etdo = 'CL' set @id = '7'
if @etdo = 'CM' set @id = '8'
if @etdo = 'DG' set @id = '9'
if @etdo = 'GT' set @id = '10'
if @etdo = 'GR' set @id = '11'
if @etdo = 'HG' set @id = '12'
if @etdo = 'JC' set @id = '13'
if @etdo = 'MC' set @id = '14'
if @etdo = 'MN' set @id = '15'
if @etdo = 'MS' set @id = '16'
if @etdo = 'NT' set @id = '17'
if @etdo = 'NL' set @id = '18'
if @etdo = 'OC' set @id = '19'
if @etdo = 'PL' set @id = '20'
if @etdo = 'QT' set @id = '21'
if @etdo = 'QR' set @id = '22'
if @etdo = 'SP' set @id = '23'
if @etdo = 'SL' set @id = '24'
if @etdo = 'SR' set @id = '25'
if @etdo = 'TC' set @id = '26'
if @etdo = 'TS' set @id = '27'
if @etdo = 'TL' set @id = '28'
if @etdo = 'VZ' set @id = '29'
if @etdo = 'YN' set @id = '30'
if @etdo = 'ZS' set @id = '31'
return @id;
end
go
-------
SELECT dbo.GetidEstado('MADA971212MVZRMN04')
--5. Realizar una función llamada
create 
alter FUNCTION dbo.Calculadoraa
(
	@pnum1 int,
	@pnum2 int,
	@oper varchar(5)
)
returns decimal (9,2)
AS
begin
DECLARE @res decimal (9,2);
 SET @res = (case @oper 
	when '+' then (@pnum1 + @pnum2)
	when '-' then (@pnum1 - @pnum2)
	when '*' then (@pnum1 * @pnum2)
	when '%' then @pnum1 / NULLIF(@pnum2, 0)
	when '/' then CONVERT(FLOAT, @pnum1) / NULLIF(@pnum2, 0)
end)
RETURN @res
END;
GO
---------
select dbo.Calculadoraa(5, 0, '%')
--6. Realizar una función llamada GetHonorarios
USE Capacitacion
CREATE FUNCTION dbo.GetHonorario
(
@idInstructor INT, 
@idCurso INT
) 
RETURNS NUMERIC(9,2)
AS
BEGIN
	DECLARE @importe NUMERIC(9,2);
	SELECT @importe = (instructores.cuotaHora * catCursos.horas) 
	FROM Instructores
INNER JOIN CursosInstructores ON CursosInstructores.idInstructor = Instructores.id_Instructores
INNER JOIN Cursos ON CursosInstructores.idCurso = Cursos.id_Cursos
INNER JOIN catCursos ON catCursos.id_CatCursos = Cursos.idCatCurso
WHERE CursosInstructores.id_CursosInstructores = @idInstructor;
RETURN @importe
END
GO
-------
SELECT dbo.GetHonorario(3, 3);
--7. Crear la función GetEdad la cual reciba como parámetros la fecha de nacimiento 
ALTER FUNCTION dbo.GetEdad
(
@FECHANACIMIENTO DATE, 
@FECHACALCULAR DATE  
 )
 RETURNS INT  
AS 
BEGIN
	DECLARE @EDAD INT 
	SET @EDAD = DATEDIFF (year, 
				IIF ((MONTH (@FECHANACIMIENTO) > MONTH (@FECHACALCULAR))
					OR (DAY (@FECHANACIMIENTO) > DAY (@FECHACALCULAR)),  
						DATEADD(YEAR,1,@FECHANACIMIENTO),@FECHANACIMIENTO), @FECHACALCULAR)
RETURN @EDAD
END;
-------------
SELECT dbo.GetEdad ('1997-02-25', '2022-01-15') AS EDAD
 --8. Crear la función Factorial la cual reciba como parámetros
 alter FUNCTION dbo.Factorial (
@num INT
)
RETURNS numeric
AS

BEGIN
DECLARE @RESULTADO numeric;
IF @num = 0 OR @num = 1
    SELECT @RESULTADO = 1
  ELSE
    SELECT @RESULTADO = dbo.FACTORIAL(@num-1) * @num
RETURN @RESULTADO;
END
GO
---------
select dbo.Factorial (7)
--9. Crear la función ReembolsoQuincenal la cual reciba como parámetros un SueldoMensual 
CREATE FUNCTION dbo.ReembolsoQuincenal
(
@sueldomensual DECIMAL (9,2)
)
RETURNS DECIMAL (9,2)
AS
BEGIN 
RETURN (@sueldomensual * 2.5) /12 
END;
--------
SELECT dbo.ReembolsoQuincenal (50000)
--10. Realizar una función que calcule el impuesto que debe pagar un instructor 
CREATE FUNCTION dbo.Impuesto
(
@instructor int , 
@curso int 
) 
RETURNS DECIMAL 
AS
BEGIN 
DECLARE @SUELDO NUMERIC(9) ,@ESTADO CHAR (2) ,@IMPUESTO NUMERIC  ;
SELECT @SUELDO = (instructores.cuotaHora * catCursos.horas) FROM instructores
					INNER JOIN CursosInstructores ON CursosInstructores.idInstructor = Instructores.id_Instructores
					INNER JOIN Cursos ON CursosInstructores.id_CursosInstructores = Cursos.id_Cursos
					INNER JOIN catCursos ON catCursos.id_CatCursos = Cursos.idCatCurso
WHERE CursosInstructores.id_CursosInstructores = @instructor;
set @IMPUESTO = case SUBSTRING((SELECT  curp from Instructores where id_Instructores = @instructor) , 12,2)
		when 'CS' THEN  @SUELDO -(@SUELDO * 0.05)
		when 'SR' THEN @SUELDO -(@SUELDO * 0.10)
		when 'VZ' THEN @SUELDO -(@SUELDO * 0.07)
ELSE @SUELDO -(@SUELDO * 0.08) end 
RETURN @IMPUESTO
END
-------
SELECT dbo.Impuesto (3,3) AS SUELDO
--11. Haciendo uso de la función GetEdad, obtener una relación de alumnos, 
--con la edad a la fecha de inscripción, y la edad actual. 
--De aquellos alumnos  que actualmente tengan más de 25 años.
 SELECT Alumnos.*, dbo.GetEdad(Alumnos.fechaNacimiento, CursosAlumnos.fechaInscripcion) AS edadCuandoSeInscribieron, 
 dbo.GetEdad(Alumnos.fechaNacimiento, CURRENT_TIMESTAMP) AS edadActual 
 FROM Alumnos 
 INNER JOIN CursosAlumnos ON CursosAlumnos.idAlumno = Alumnos.id_alumnos
 WHERE dbo.GetEdad(Alumnos.fechaNacimiento, CURRENT_TIMESTAMP)>25;

 SELECT * FROM CursosAlumnos
 --12. Realizar una función que determine el porcentaje a descontar en los reembolsos
CREATE FUNCTION PorcentajeDescuento(
@sueldo FLOAT, 
@mes INT
)
 RETURNS VARCHAR(8)
 AS
 BEGIN
	DECLARE @porcentaje VARCHAR(8);
	IF @mes = 1
	SET @porcentaje = CONVERT(VARCHAR, @sueldo/1000) + '%'
	IF @mes = 2
	SET @porcentaje = CONVERT(VARCHAR, (@sueldo/1000)/2) + '%'
	IF @mes = 3
	SET @porcentaje = CONVERT(VARCHAR, (@sueldo/1000)/4) + '%'
	IF @mes = 4
	SET @porcentaje = CONVERT(VARCHAR, (@sueldo/1000)/8) + '%'
	IF @mes = 5
	SET @porcentaje = CONVERT(VARCHAR, (@sueldo/1000)/16) + '%'
	IF @mes = 6
	SET @porcentaje = '0%'
RETURN @porcentaje
END
-------
SELECT dbo.PorcentajeDescuento(40000, 6);
--13. Hacer una función que convierta a mayúsculas la primera letra de cada palabra de un cadena de caracteres recibida.
CREATE 
ALTER FUNCTION dbo.MAYUSCULAS(
@cadena VARCHAR(255)
)
 RETURNS VARCHAR(255)
 AS
 BEGIN
 DECLARE @iniCap VARCHAR(255)
 SET @iniCap = UPPER(LEFT(@cadena, 1)) + LOWER(SUBSTRING(@cadena, 2, LEN(@cadena)))
 RETURN @iniCap
 END
-----
PRINT dbo.MAYUSCULAS('jabneel ortiz')
------------------------------------------------------------
-- DOCUMENTO 52
--TEMA: SQL SERVER
--SUBTEMA: FUNCION VALUADA EN TABLA
--1. Hacer una función valuada en tabla que obtenga
ALTER FUNCTION dbo. Amortizacion
(
@idAlumno INT
)
RETURNS @ResTable 
TABLE (
	Quincena INT, 
	SaldoAnterior DECIMAL(9,2),
	Pago DECIMAL(9,2),
	SaldoNuevo DECIMAL(9,2)
 )AS
BEGIN
	DECLARE @Quincena INT,
			@SaldoAnterior DECIMAL(9,2),
			@SaldoNuevo DECIMAL(9,2),
			@Pago DECIMAL(9,2);
	SET @Quincena = 1;
	SET @SaldoAnterior = (SELECT (a.sueldo * 2.5)
						  FROM Alumnos a
						  WHERE a.id_alumnos = @idAlumno);
	SET @SaldoNuevo = (SELECT @SaldoAnterior - dbo.ReembolsoQuincenal(a.sueldo)
					   FROM Alumnos a
					   WHERE a.id_alumnos = @idAlumno);
	SET @Pago = (SELECT dbo.ReembolsoQuincenal(a.sueldo)
				 FROM Alumnos a
				 WHERE a.id_alumnos = @idAlumno);
	WHILE @Quincena <= 12
	BEGIN
		INSERT  @ResTable
			SELECT @Quincena, @SaldoAnterior, @Pago, @SaldoNuevo;
	SET @Quincena = @Quincena + 1 ;
	SET @SaldoAnterior = @SaldoNuevo;
	SET @SaldoNuevo = @SaldoAnterior - @Pago;
	END;
	RETURN
END;
-------
SELECT * FROM dbo.Amortizacion(1);
--2. Hacer una función valuada en tabla que obtenga la tabla de amortización
CREATE FUNCTION AmortizacionInst
(
@idInst INT
)
RETURNS @AmortizacionTabla TABLE
( 
Quincena INT,
DineroPrestamo DECIMAL(9,2),
Pago DECIMAL(9,2),
Debiendo DECIMAL(9,2)
 )
AS
 BEGIN
	DECLARE @Quincena INT,
			@DineroPrestamo DECIMAL(9,2),
			@Pago DECIMAL(9,2),
			@Debiendo DECIMAL(9,2),
			@Interes DECIMAL(9,2)
			SET @Interes = IIF((SELECT ins.cuotaHora FROM Instructores ins WHERE ins.id_instructores = @idInst)>200, 1.24, 1.18)
			SET @Quincena  = 1
			SET @DineroPrestamo = (SELECT (ins.cuotaHora * 200)
								  FROM Instructores ins
								  WHERE ins.id_Instructores = @idInst)
			SET @Pago = (@DineroPrestamo / 12)*@Interes
			SET @Debiendo = @DineroPrestamo - @Pago

		WHILE @Quincena <= 12
		BEGIN
			INSERT INTO @AmortizacionTabla VALUES(@Quincena, @DineroPrestamo, @Pago, @Debiendo)
			SET @Quincena = @Quincena + 1
			SET @DineroPrestamo = @Debiendo
			SET @Debiendo = @DineroPrestamo - @Pago
		END
	RETURN
 END;
 -------
 SELECT * FROM AmortizacionInst(1);
 --------------------------------------------------
--DOCUMENTO 61
-- TEMA: SQL SERVER
--SUBTEMA: STORE PROCEDURES
--1. Crear un store procedureCodigoAscii que imprima los
ALTER PROCEDURE dbo.procedureCodigoAscii
AS
BEGIN
	DECLARE @codigo VARCHAR(20), @texto VARCHAR(255), @i INT, @valor INT;
	SET @i = 32;
	WHILE @i <= 255
	BEGIN
	    SET @i = @i+1
		SET @codigo = CHAR(@i)
		SET @valor = ASCII(@codigo)
		SET @texto = @codigo + ' ASCII => ' + CAST(@valor AS NCHAR(10));
		PRINT @texto
	END
END
-------
 EXECUTE dbo.procedureCodigoAscii
--2. Crear el store procedure Factorial que reciba como parámetro
ALTER PROCEDURE dbo.CalcularFactorial
(
@num INT
)
AS
BEGIN
DECLARE @RESULTADO numeric;
IF @num = 0 OR @num = 1
    SELECT @RESULTADO = 1
  ELSE
    SELECT @RESULTADO = dbo.FACTORIAL(@num-1) * @num
PRINT @RESULTADO;
END
GO
-------
EXECUTE dbo.CalcularFactorial 5
--3. Crear las siguientes Tablas
USE Capacitacion
create table saldos(
  id int PRIMARY KEY IDENTITY NOT NULL,
  nombre varchar(100) NULL,
  saldo NUMERIC (18,2) 
 );

 create table Transacciones(
  id int PRIMARY KEY IDENTITY NOT NULL,
  idOrigen INT NOT NULL,
  idDestino int NOT NULL,
  monto NUMERIC (18,2) 
 );
--4. Crear un store procedure “Transacciones” que recibirá como parámetros el
CREATE PROCEDURE TransaccionesSTOREPROCEDURES
(@idOrigen INT,
@idDestino INT,
@Monto DECIMAL(9,2)
)
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
		UPDATE saldos
		SET saldo = saldo - @Monto
		WHERE id = @idOrigen;
		UPDATE saldos
		SET saldo = saldo + @Monto
		WHERE id = @idDestino;
INSERT INTO Transacciones VALUES (@idOrigen, @idDestino, @Monto);			
			COMMIT TRANSACTION
		PRINT 'Transaccion Exitosa';
	END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION
		PRINT 'Transaccion No se pudo';
	END CATCH
END;

EXECUTE dbo.TransaccionesSTOREPROCEDURES @idOrigen = 2, @idDestino = 1, @Monto = 300000.00;
--------------------------------------------------------------
--DOCUMENTO 71
--TEMA: SQL SERVER
--SUBTEMA: ACTIVIDADES FINALES
--1. Realizar una vista vAlumnos que obtenga el siguiente resultado
CREATE VIEW dbo.vAlumnos
AS  
SELECT a.id_alumnos,a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno,
a.correo, a.telefono, a.curp, e.nombre AS Estado, ea.nombre AS EStatus
FROM Alumnos AS a
INNER JOIN Estados e
ON a.id_alumnos = e.id_Estados
INNER JOIN  EstatusAlumnos ea
ON e.id_Estados = ea.id_EstatusAlumnos 
GO
------
SELECT * FROM dbo.vAlumnos
--2. Realizar el procedimiento almacenado consultarEstados el cual
ALTER PROCEDURE dbo.consultarEstados
(
@idRegistro INT
)
AS
BEGIN
DECLARE @CONSULTA VARCHAR (100)
IF @idRegistro = -1
SELECT * FROM Estados;
ELSE
SELECT * FROM Estados WHERE id_Estados = @idRegistro
END
GO
-----
EXECUTE dbo.consultarEstados -1
--3. Realizar el procedimiento almacenado consultarEstatusAlumnos
ALTER PROCEDURE dbo.consultarEstatusAlumnos
(
@idRegistro INT
)
AS
BEGIN
DECLARE @CONSULTA VARCHAR (100)
IF @idRegistro = -1
SELECT ea.id_EstatusAlumnos, ea.Nombre FROM EstatusAlumnos AS ea;
ELSE
SELECT ea.id_EstatusAlumnos, ea.Nombre FROM EstatusAlumnos AS ea WHERE id_EstatusAlumnos = @idRegistro
END
GO
-----
EXECUTE dbo.consultarEstatusAlumnos 5
--4. Realizar el procedimiento almacenado consultarAlumnos el cua
ALTER PROCEDURE dbo.consultarAlumnos
(
@idRegistro INT
)
AS
BEGIN
DECLARE @CONSULTA VARCHAR (100)
IF @idRegistro = -1
SELECT a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.correo, a.fechaNacimiento, a.telefono, a.curp,
e.nombre, ea.Nombre
FROM Alumnos AS a
INNER JOIN Estados e
ON a.idEstadoOrigen = e.id_Estados
INNER JOIN EstatusAlumnos ea
ON a.idEstatus = ea.id_EstatusAlumnos
ELSE
SELECT a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.correo, a.fechaNacimiento, a.telefono, a.curp,
e.nombre, ea.Nombre 
FROM Alumnos AS a
INNER JOIN Estados e
ON a.idEstadoOrigen = e.id_Estados
INNER JOIN EstatusAlumnos ea
ON a.idEstatus = ea.id_EstatusAlumnos WHERE id_alumnos = @idRegistro
END
GO
-----
EXECUTE dbo.consultarAlumnos 5

SELECT * FROM Alumnos
--5. Realizar el procedimiento almacenado consultarEAlumnos e
ALTER PROCEDURE dbo.consultarEAlumnos
(
@idRegistro INT
)
AS
BEGIN
DECLARE @CONSULTA VARCHAR (100)
IF @idRegistro = -1
SELECT a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.fechaNacimiento, a.correo,  a.telefono, a.curp,
a.idEstadoOrigen, a.idEstatus
FROM Alumnos a
ELSE
SELECT a.nombre_alumno, a.primerApellido_alumno, a.segundoApellido_alumno, a.fechaNacimiento, a.correo,  a.telefono, a.curp,
a.idEstadoOrigen, a.idEstatus
FROM Alumnos  a
WHERE a.id_alumnos = @idRegistro 
END
GO
-----
EXECUTE dbo.consultarEAlumnos -1
--6. Realizar el procedimiento almacenado actualizarEstatusAlumnos el
ALTER PROCEDURE dbo.actualizarEstatusAlumnos
(
@idAlumno INT,
@nuevoEstatus INT
)
AS
BEGIN
UPDATE Alumnos SET idEstatus = @nuevoEstatus 
WHERE id_alumnos = @idAlumno
END
GO
--
EXECUTE dbo.actualizarEstatusAlumnos 9,2 

SELECT * FROM Alumnos
--7. Realizar el procedimiento almacenado agregarAlumnos el cual recibirá
CREATE PROCEDURE agregarAlumnos
(
@nombre VARCHAR (80), @primerApellido VARCHAR (80),
@segundoApellido VARCHAR (80), @correo VARCHAR (80),
@telefono NCHAR(10), @fechaNacimiento DATE,
@curp char(18), @sueldo DECIMAL(9,2), @id_estado INT, @id_estatus INT
)
AS
BEGIN
INSERT INTO Alumnos(nombre_alumno, primerApellido_alumno, segundoApellido_alumno,
correo, telefono, fechaNacimiento, curp, sueldo, idEstadoOrigen, idEstatus)
VALUES (@nombre, @primerApellido, @segundoApellido, @correo, @telefono,
@fechaNacimiento, @curp, @sueldo, @id_estado, @id_estatus);
	SELECT MAX(id_alumnos)
	FROM Alumnos;
END

EXECUTE agregarAlumnos 
'Jahaziel', 'Ortiz', 'Muñoz', 'jazi@gmail.com', '772589614', 
'1994-08-20', 'JOMU940820HHGRÑH03', 25000, 12, 5

SELECT * FROM Alumnos
--8. Realizar el procedimiento almacenado actualizarAlumnos el cual
CREATE PROCEDURE actualizarAlumnos
(
@ID INT, @nombre VARCHAR (80), @primerApellido VARCHAR (80),
@segundoApellido VARCHAR (80), @correo VARCHAR (80),
@telefono NCHAR(10), @fechaNacimiento DATE,
@curp char(18), @sueldo DECIMAL(9,2), @id_estado INT, @id_estatus INT
)
AS
BEGIN
UPDATE Alumnos SET nombre_alumno = @nombre, primerApellido_alumno = @primerApellido, segundoApellido_alumno = @segundoApellido,
correo = @correo, telefono = @telefono, fechaNacimiento = @fechaNacimiento, curp = @curp, sueldo = @sueldo, idEstadoOrigen = @id_estado, idEstatus = @id_estatus
WHERE id_alumnos = @ID
SELECT MAX(id_alumnos)
	FROM Alumnos;
END

EXECUTE actualizarAlumnos
19,'Jahaziel', 'Ortiz', 'Muñoz', 'jazi@gmail.com', '772589614', 
'1994-08-20', 'JOMU940820HHGRÑH03', 25000, 12, 5

SELECT * FROM Alumnos
--9. Realizar el procedimiento almacenado eliminarAlumnos el cual recib
CREATE PROCEDURE eliminarAlumnos 
(
@idAlumno INT
)
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION DELETE FROM CursosAlumnos WHERE idAlumno = @idAlumno;
			DELETE FROM Alumnos WHERE id_alumnos = @idAlumno;
		COMMIT TRANSACTION PRINT 'Transaccion';
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE() AS ErrorMessage;
		Throw;
		PRINT 'Excepcion';
	END CATCH
END

EXECUTE eliminarAlumnos @idAlumno= -1;

SELECT * FROM CursosAlumnos
SELECT * FROM Alumnos
--10. Crear el trigger Trigger_EliminarAlumnos el cual se debe ejecutar
CREATE TRIGGER Trigger_EliminarAlumnos
ON alumnos
AFTER DELETE
AS
BEGIN
	INSERT INTO AlumnosBaja (nombre, primerApellido, segundoApellido, fechaBaja)
	SELECT d.nombre_alumno, d.primerApellido_alumno, d.segundoApellido_alumno, GETDATE()
	FROM deleted d;
END
GO

DELETE FROM Alumnos WHERE id_alumnos = 1;

select * from alumnosBaja
--11. Obtener un respaldo de su base de datos InstitutoTich
--12. Crear una base de datos PruebasTich con el respaldo de la base
--13. Sobre la base de datos PruebasTich crear el store Procedure spEliminaAlumnosCurso e
use PruebasTich;

CREATE PROCEDURE spEliminaAlumnosCurso
(
@nombreCurso VARCHAR (50)
)
AS
BEGIN
DELETE FROM Alumnos
WHERE id_alumnos IN (SELECT a.id_alumnos FROM Alumnos a,
							CursosAlumnos ca,
							cursos c,
							CatCursos cat
						WHERE 1 =1
						AND cat.id_CatCursos = c.idCatCurso
						AND c.id_Cursos = ca.id_CursosAlumnos
						AND ca.idAlumno = a.id_alumnos
						AND cat.nombre = @nombreCurso)
END;
EXECUTE spEliminaAlumnosCurso @nombreCurso = 'Bases de datos SQL Server';
--14. Obtener los scripts de la base de datos InstitutoTich
--15. Obtener el script de la spEliminaAlumnosCurso