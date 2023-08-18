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
- usuario (listo)
- agencia_persona (listo)
- grupo (listo)
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
  nombre varchar (100) not null,
  tipo varchar(50),
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
3 -> triple (3.2 / 3.3)
4 ->cuadruple (4.2 / 4.3 / 4.4)
5 ->quintuple (5.3 / 5.4 / 5.5)
6 ->sextuple (6.3 / 6.4 / 6.5 / 6.6)
7 ->septuple (7.4 / 7.5 / 7.6 / 7.7)
8 ->          (8.4 / 8.5 / 8.6 / 8.7 / 8.8)
9 ->
10 ->
*/

--TABLAS CON LLAVES FORANEAS

create table usuario (
  id varchar (5) primary key,
  usuario varchar (50) not null,
  password varchar (50) not null,
  estado varchar (15),
  persona_id int not null,
  rol_id int not null,
  foreign key (persona_id) references persona (id),
  foreign key (rol_id) references rol (id)
)
/*
el ID de usuario será de acuerdo al Rol: 
1) SuperAdministrador ---> SA1,SA2,SA3, ...
2) Administrador ----> A1,A2,A3
3) Segundo Administrador -----> 
4) Recepcionista ------>R1,R2,R3
5) Personal de Alimentos ---->A1,A2
6) Personal de Limpieza ---->L1,L2
7) Personal de Mantenimiento ---->M1,M2
8) Responsable de la reserva ---->RR1,RR2,RR3
9) Guia ---->G1,G2,G3


estadoUsuario: activo/inactivo/eliminado
*/

create table agencia_persona (
  agencia_id int,
  persona_id int,
  primary key (agencia_id,persona_id),
  foreign key (agencia_id) references agencia (id),
  foreign key (persona_id) references persona (id)
)
--La tabla agencia_persona tendrá una llave compuesta

create table grupo (
  id serial primary key,
  nombre varchar (50),
  codigo varchar (20),
  tipo varchar (10)
  cantidad_turistas int,
  cantidad_asistentes int,
  cantidad_nacionales int,
  cantidad_extranjeros int,
  reservado_por varchar(10),
  agencia_id int
  registrado_por varchar (50),
  responsable_grupo varchar (20),
  observaciones varchar (200),
  foreign key (agencia_id) references agencia (id)
)
/*
tipoGrupo:
RSV----->Reserva
SVD ----->ServicioDirecto
==========================================
codigoGrupo:
(tipoReserva)-(aamm)-1
(tipoReserva)-(aamm)-2
(tipoReserva)-(aamm)-3
......
ejemplo:
RSV-2308-01
RSV-2308-02
RSV-2308-03
SVD-2308-01
SVD-2308-02
....
SVD-2308-999
=========================================
En 'reservado_por' irá el código del usuario (que esté realizando el uso de la WebApp). ejem: A1,A2,A3
En 'agencia' ira el código de la agencia responsable si existe ()
En 'registrado_por' irá el código del usuario (que esté realizando el uso de la WebApp). ejem: R1,R2,R3
En 'responsable_grupo', al principio estará vacío. cuando llegue el grupo se lo podrá seleccionar desde "viajero"
*/

