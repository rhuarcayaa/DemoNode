-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-04-2025 a las 05:09:51
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ventas`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_busven` (IN `p_id_ven` INT)   BEGIN
    -- Buscar vendedor específico por ID
    SELECT * FROM vendedor 
    WHERE id_ven = p_id_ven;

    -- Validar si existe el vendedor
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Vendedor no encontrado';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delven` (IN `p_id_ven` INT)   BEGIN
    -- Validar que el vendedor exista
    IF NOT EXISTS (SELECT 1 FROM vendedor WHERE id_ven = p_id_ven) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El vendedor no existe';
    END IF;

    -- Eliminar vendedor
    DELETE FROM vendedor 
    WHERE id_ven = p_id_ven;

    -- Confirmar eliminación
    SELECT ROW_COUNT() AS filas_eliminadas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ingven` (IN `p_nom_ven` VARCHAR(25), IN `p_apel_ven` VARCHAR(25), IN `p_cel_ven` CHAR(9))   BEGIN
    -- Validar que los campos no estén vacíos
    IF p_nom_ven IS NULL OR p_nom_ven = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El nombre del vendedor no puede estar vacío';
    END IF;

    IF p_apel_ven IS NULL OR p_apel_ven = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El apellido del vendedor no puede estar vacío';
    END IF;

    IF p_cel_ven IS NULL OR p_cel_ven = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El número de celular del vendedor no puede estar vacío';
    END IF;

    -- Validar formato de celular (9 dígitos)
    IF LENGTH(p_cel_ven) != 9 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El número de celular debe tener 9 dígitos';
    END IF;

    -- Insertar nuevo vendedor
    INSERT INTO vendedor (nom_ven, apel_ven, cel_ven)
    VALUES (p_nom_ven, p_apel_ven, p_cel_ven);

    -- Devolver el ID del vendedor insertado
    SELECT LAST_INSERT_ID() AS nuevo_id_vendedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modven` (IN `p_id_ven` INT, IN `p_nom_ven` VARCHAR(25), IN `p_apel_ven` VARCHAR(25), IN `p_cel_ven` CHAR(9))   BEGIN
    -- Validar que el vendedor exista
    IF NOT EXISTS (SELECT 1 FROM vendedor WHERE id_ven = p_id_ven) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El vendedor no existe';
    END IF;

    -- Validaciones de campos
    IF p_nom_ven IS NULL OR p_nom_ven = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El nombre del vendedor no puede estar vacío';
    END IF;

    IF p_apel_ven IS NULL OR p_apel_ven = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El apellido del vendedor no puede estar vacío';
    END IF;

    IF p_cel_ven IS NULL OR p_cel_ven = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El número de celular del vendedor no puede estar vacío';
    END IF;

    -- Validar formato de celular (9 dígitos)
    IF LENGTH(p_cel_ven) != 9 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El número de celular debe tener 9 dígitos';
    END IF;

    -- Actualizar vendedor
    UPDATE vendedor 
    SET 
        nom_ven = p_nom_ven,
        apel_ven = p_apel_ven,
        cel_ven = p_cel_ven
    WHERE id_ven = p_id_ven;

    -- Confirmar actualización
    SELECT ROW_COUNT() AS filas_actualizadas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_selven` (IN `p_filtro` VARCHAR(50), IN `p_tipo_filtro` VARCHAR(20))   BEGIN
    -- Selección según el tipo de filtro
    IF p_tipo_filtro = 'id' THEN
        SELECT * FROM vendedor 
        WHERE id_ven = CAST(p_filtro AS UNSIGNED);
    
    ELSEIF p_tipo_filtro = 'nombre' THEN
        SELECT * FROM vendedor 
        WHERE nom_ven LIKE CONCAT('%', p_filtro, '%');
    
    ELSEIF p_tipo_filtro = 'apellido' THEN
        SELECT * FROM vendedor 
        WHERE apel_ven LIKE CONCAT('%', p_filtro, '%');
    
    ELSEIF p_tipo_filtro = 'todos' THEN
        SELECT * FROM vendedor;
    
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Tipo de filtro no válido';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedor`
--

CREATE TABLE `vendedor` (
  `id_ven` int(11) NOT NULL,
  `nom_ven` varchar(25) NOT NULL,
  `apel_ven` varchar(25) NOT NULL,
  `cel_ven` char(9) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `vendedor`
--

INSERT INTO `vendedor` (`id_ven`, `nom_ven`, `apel_ven`, `cel_ven`) VALUES
(4, 'Carlo ', 'Caceres', '999999999'),
(5, 'Remigio2', 'Almeyda', '252372892');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `vendedor`
--
ALTER TABLE `vendedor`
  ADD PRIMARY KEY (`id_ven`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `vendedor`
--
ALTER TABLE `vendedor`
  MODIFY `id_ven` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
