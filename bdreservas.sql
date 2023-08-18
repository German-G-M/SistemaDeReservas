-- Base de datos Para el sistema de reservas (Hotel, Alimentacion, Lancha)
-- Gestión de reservaciones, registros y pagos

--cración de la BD
create database bd_reservas_registros

--creación de las tablas

/*
Orden de la creación de las tablas 
(primero los que no tienen foreign keys)
- persona
- rol
- agencia
- puerto
- habitacion
(luego los que tienen foreign keys)
- usuario
- agencia_persona
- grupo
- viajero
- hospedaje
- viajelancha
- alimentacion
*/
