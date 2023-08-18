-- Base de datos Para el sistema de reservas (Hotel, Alimentacion, Lancha)
-- Gestión de reservaciones, registros y pagos

--cración de la BD
create database bd_reservas_registros

--creación de las tablas

/*
Orden de la creación de las tablas 
(primero los que no tienen foreign keys)
- rol (listo)
- persona (listo)
- agencia (listo)
- puerto (listo)
- habitacion (listo)
(luego los que tienen foreign keys)
- usuario
- agencia_persona
- grupo
- viajero
- hospedaje
- viajelancha
- alimentacion
*/
  
create table rol (
  id int primary key,
  descripcion varchar (50) not null
)
/*
  roles:
1) SuperAdministrador
2) Administrador
3) Segundo Administrador
4) Recepcionista
5) Personal de Alimentos
6) Personal de Limpieza
7) Personal de Mantenimiento
8) Responsable de la reserva
9) Guia
*/
  
create table persona (
  id serial primary key,
  ci varchar(12),
  nombre varchar(50) not null,
  nombre2 varchar(50),
  apellido1 varchar(50) not null,
  apellido2 varchar(50),
  telefono1 varchar(15),
  telefono2 varchar(15),
  correo varchar(50),
  direccion varchar(50),
  observaciones(200)
)
  
create table agencia (
  id serial primary key,
  nombre varchar (50) not null,
  telefono varchar (15),
  direccion varchar (50),
  observacion varchar (200)
)

/*
tipo agencia:
1) Agencia de  viajes
2) Operadora
3) Particular
4) Otro
*/

create table puerto (
  id serial primary key,
  codigo varchar (5) not null,
  descripcion varchar not null(50)
)

/*
código puerto:
CPC (Copacabana)
ISS (Isla del sol sur- Yumani)
ISN (Isla del sol norte-Challapata)
ISC (Isla del sol centro-Challa)
ILN (Isla de la luna)
ISSK (Hotel Puma Punku)
*/

create table habitacion (
  id serial primary key,
  nombre_numero varchar(20) not null,
  tipo float,
  cantidad_camas int,
  incluye varchar(50),
  estado_activo bit,
  estado_limpieza bit,
  observaciones varchar(50)
)
/*
tipo habitacion:
1 -> simple
2.1 -> matrimonial
2.2 ->doble
3 -> triple
4 ->cuadruple
5 ->quintuple
6 ->sextuple
7 ->septuple
*/

--TABLAS CON LLAVES FORANEAS

create table usuario (
  
)

