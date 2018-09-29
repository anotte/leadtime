/*
SQLyog Community v12.5.1 (64 bit)
MySQL - 5.7.22-log : Database - leadtime_dev
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`leadtime_dev` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `leadtime_dev`;

/*Table structure for table `tab_feriados` */

DROP TABLE IF EXISTS `tab_feriados`;

CREATE TABLE `tab_feriados` (
  `int_feriado_id_pk` int(11) NOT NULL AUTO_INCREMENT,
  `str_feriado_descricao` varchar(255) NOT NULL,
  `dt_feriado_data` datetime NOT NULL,
  `bl_feriado_recorrente` tinyint(1) NOT NULL DEFAULT '0',
  `bl_ha_expediente` tinyint(4) DEFAULT NULL,
  `tm_ini_expediente` time DEFAULT NULL,
  `tm_fim_expediente` time DEFAULT NULL,
  PRIMARY KEY (`int_feriado_id_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4;

/*Table structure for table `tab_horario_util` */

DROP TABLE IF EXISTS `tab_horario_util`;

CREATE TABLE `tab_horario_util` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `int_dia_semana` int(11) DEFAULT NULL,
  `tm_ini_expediente` time DEFAULT NULL,
  `tm_fim_expediente` time DEFAULT NULL,
  `int_minutos_uteis_dia` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
