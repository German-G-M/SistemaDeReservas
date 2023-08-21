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
- viajero (listo)
- hospedaje (listo)
- alimentacion (listo)
- viajelancha (listo)
*/
  
create table rol (
  id int primary key,
  descripcion varchar (50) not null
);
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
);
  
create table agencia (
  id serial primary key,
  nombre varchar (100) not null,
  tipo varchar(50),
  telefono varchar (15),
  direccion varchar (50),
  observacion varchar (200)
);

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
);

/*
código puerto:
CPC (Copacabana)
ISS (Isla del sol sur- Yumani)
ISN (Isla del sol norte-Challapata)
ISC (Isla del sol centro-Challa)
ILN (Isla de la luna)
ISK (Hotel Puma Punku)
CPY (Yampupata)
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
);
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
  estado bit,
  persona_id int not null,
  rol_id int not null,
  foreign key (persona_id) references persona (id),
  foreign key (rol_id) references rol (id)
);
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


estadoUsuario: 
1 --> activo
0 --> inactivo
*/

create table agencia_persona (
  agencia_id int,
  persona_id int,
  primary key (agencia_id,persona_id),
  foreign key (agencia_id) references agencia (id),
  foreign key (persona_id) references persona (id)
);
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
  estado varchar (10),
  foreign key (agencia_id) references agencia (id)
);
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

==========================================
  estadoGrupo: es igual a los estados de hospedaje
*/

create table viajero (
  id serial primary key,
  dni varchar (20),
  nombre varchar (50),
  nombre2 varchar (50),
  apellido1 varchar (50),
  apellido2 varchar (50),
  nacionalidad varchar (50),
  tipo varchar (20),
  grupo varchar (20),
  foreign key (grupo) references grupo (codigo)
);
/*
tipoViajero:
Turista
Guia
Asistente
*/

create table hospedaje (
  id serial primary key,
  fecha_in date,
  recibido_por varchar (5),
  fecha_out date,
  despachado_por varchar (5) ,
  estado varchar (10),
  costo_por_persona int,
  costo_por_habitacion int,
  esta_pagado bit,
  fecha_reserva timestamp not null,
  observaciones varchar (200),
  viajero int,
  grupo int not null,
  habitacion int,
  foreign key (viajero) references viajero (id),
  foreign key (grupo) references grupo (id),
  foreign key (habitacion) references habitacion (id)
);
/*
estadoHospedaje:
RA-->Reserva activa
SM-->Solicitud modificada
SC-->Solicitud cancelada
VR-->Viajero recibido
VD-->Viajero despachado
NS-->No-show
VS-->Viajero servido

===========================
recibido_por, sera el codigo del usuario que registro la entrada (chekin)
despachado_por, sera el codigo del usuario que registro la salida (chekout)
*/

create table alimentacion (
  id serial primary key,
  fecha_consumo date,
  producto varchar (100),
  cantidad int,
  precio_unitario int,
  precio_total int,
  es_reserva bit,
  estado varchar (10),
  esta_pagado bit,
  observaciones varchar(200),
  fecha_reserva date,
  viajero int,
  grupo int not null,
  habitacion int,
  foreign key (viajero) references viajero (id),
  foreign key (grupo) references grupo (id),
  foreign key (habitacion) references habitacion (id)
);

/*
estadoAlimentacion: es igual a los estados de hospedaje
*/

create table viajelancha (
  id serial primary key,
  fecha_viaje date,
  puerto_salida varchar (5),
  hora_salida string (10),
  puerto_llegada varchar (5),
  tiempo_viaje varchar (5),
  hora_llegada string (10),
  precio_pasajero int,
  precio_grupo int,
  cantidad_turistas int,
  cantidad_guias int,
  es_reserva bit,
  fecha_reserva timestamp,
  esta_pagado bit,
  estado varchar (10),
  tipo_viaje varchar (15),
  observaciones varchar (200),
  viajero int,
  grupo int not null,
  foreign key (viajero) references viajero (id),
  foreign key (grupo) references grupo (id)
);
/*
Hora_salida: 123456789101112 00,15,30,45 am,pm
tiempo_viaje:0:30,1:00,1:30, 2:00, 2:30, 3:00, 3:30 (horas aprox)
estadoViajelancha: es igual a los estados de hospedaje

tipoViajelancha:
Privado
Compartido
*/


--LLENADO DE DATOS (INSERCIONES)

insert into rol (id,descripcion) values (1,'SuperAdministrador');
insert into rol (id,descripcion) values (2,'Administrador');
insert into rol (id,descripcion) values (3,'Segundo Administrador');
insert into rol (id,descripcion) values (4,'Recepcionista');
insert into rol (id,descripcion) values (5,'Personal de Alimentos');
insert into rol (id,descripcion) values (6,'Personal de Limpieza');
insert into rol (id,descripcion) values (7,'Personal de Mantenimiento');
insert into rol (id,descripcion) values (8,'Responsable de la reserva');
insert into rol (id,descripcion) values (9,'Guia');
insert into rol (id,descripcion) values (10,'Acompañante');


insert into persona (ci,nombre,nombre2,appellido1,apellido2,telefono1,telefono2,correo,direccion,observaciones)
  values ('6072590','German','','Gutierrez','','76543210','','','','');
insert into persona (ci,nombre,nombre2,appellido1,apellido2,telefono1,telefono2,correo,direccion,observaciones)
  values ('88888','Carlos','','Conrado','','65432107','','','','');
insert into persona (ci,nombre,nombre2,appellido1,apellido2,telefono1,telefono2,correo,direccion,observaciones)
  values ('55555','Clark','','Kent','','6541230','','','','');
insert into persona (ci,nombre,nombre2,appellido1,apellido2,telefono1,telefono2,correo,direccion,observaciones)
  values ('4444444','Bruno','','Diaz','','123456789','','','','');


insert into agencia (nombre,tipo,telefono,direccion,observacion) values ('travel tour','Operadora','6543217','sagarnaga 1023', '');
insert into agencia (nombre,tipo,telefono,direccion,observacion) values ('Trans tour','Operadora','78549612','copacabana 210', '');
insert into agencia (nombre,tipo,telefono,direccion,observacion) values ('Viajes del sol','Agencia','6543217','sucre 256', '');
insert into agencia (nombre,tipo,telefono,direccion,observacion) values ('Particular','Particular','6543217','', 'sin agencia');
insert into agencia (nombre,tipo,telefono,direccion,observacion) values ('Otro','Otro','6543217','', 'sin agencia');


insert into puerto (codigo,descripcion) values ('CPC','Copacabana');
insert into puerto (codigo,descripcion) values ('ISS','Yumani - Isla del sol Sur');
insert into puerto (codigo,descripcion) values ('ISN','Challapata - Isla del sol Norte');
insert into puerto (codigo,descripcion) values ('ISC','Challa - Isla del sol Centro');
insert into puerto (codigo,descripcion) values ('ILN','Isla de la Luna');
insert into puerto (codigo,descripcion) values ('ISK','Hotel Puma Punku');
insert into puerto (codigo,descripcion) values ('CPY','Yampupata');


create table habitacion (
  id serial primary key,
  nombre_numero varchar(20) not null,
  tipo float,
  cantidad_camas int,
  incluye varchar(50),
  estado_activo bit,
  estado_limpieza bit,
  observaciones varchar(50)
);
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('101',1,1,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('102',1,1,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('103',2.1,1,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('104',2.1,1,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('201',2.2,2,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('202',2.2,2,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('203',2.2,2,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('301',3.3,3,'',B'1',B'1','');
insert into habitacion (nombre_numero,tipo, cantidad_camas,incluye,estado_activo,estado_limpieza,observaciones)
  values ('302',3.3,3,'',B'1',B'1','');


--Revisar inserción
insert into usuario (id,usuario,password,estado,persona_id,rol_id)
  values ('A1','usuario','password',B'1',1,1);
insert into usuario (id,usuario,password,estado,persona_id,rol_id)
  values ('A2','usuario','password',B'1',1,1);
insert into usuario (id,usuario,password,estado,persona_id,rol_id)
  values ('A3','usuario','password',B'1',1,1);


--Revisar inserción
insert into agencia_persona (agencia_id,persona_id) values (1,1);
insert into agencia_persona (agencia_id,persona_id) values (2,2);
insert into agencia_persona (agencia_id,persona_id) values (3,3);




--Revisar inserción
insert into grupo (nombre,codigo,tipo,cantidad_turistas,cantidad_asistentes,cantidad_nacionales,cantidad_extranjeros,reservado_por,responsable_grupo, obsercaciones, estado)
  values ('grupo1','g1','tipo',5,1,1,5,'reservado por','agencia_id','registrado_por','responsable1','observacion','igual a estado hospedaje');



--Revisar inserción
insert into viajero (dni,nombre,nombre2,apellido1,apellido2,nacionalidad,tipo,grupo)
  values ('dni','nombre','nombre2','apellido1','apellido2','nacionalidad','tipo','grupo');



create table hospedaje (
  id serial primary key,
  fecha_in date,
  recibido_por varchar (5),
  fecha_out date,
  despachado_por varchar (5) ,
  estado varchar (10),
  costo_por_persona int,
  costo_por_habitacion int,
  esta_pagado bit,
  fecha_reserva timestamp not null,
  observaciones varchar (200),
  viajero int,
  grupo int not null,
  habitacion int,
  foreign key (viajero) references viajero (id),
  foreign key (grupo) references grupo (id),
  foreign key (habitacion) references habitacion (id)
);
--Revisar inserción
insert into hospedaje (fecha_in,recibido_por,fecha_out,despachado_por,estado, costo_por_persona, costo_por_habitacion,esta_pagado,fecha_reserva,observaciones,viajero,grupo,habitacion)
  values ('aa-mm-dd','R1','aa-mm-dd','R1','RA',150,0,B'1','aa-mm-dd','sin observaciones',1,1,1);
