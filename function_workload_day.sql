DELIMITER $$

USE `ritz_dev`$$

DROP FUNCTION IF EXISTS `function_workload_day`$$

CREATE DEFINER=`root`@`localhost` FUNCTION `function_workload_day`(exp_ini TIME, exp_fim TIME, hour_ref TIME, sentido INT) RETURNS INT(11)
    DETERMINISTIC
BEGIN
	IF(sentido = 1) THEN
		IF(hour_ref > exp_fim) THEN
			RETURN 0;
		END IF;
		IF(hour_ref > exp_ini) THEN
			RETURN (UNIX_TIMESTAMP(exp_fim) - UNIX_TIMESTAMP(hour_ref))/60;
		ELSE
			RETURN (UNIX_TIMESTAMP(exp_fim) - UNIX_TIMESTAMP(exp_ini))/60;
		END IF;
		
	ELSE
	
		IF(hour_ref < exp_ini) THEN
			RETURN 0;
		END IF;
		IF(hour_ref > exp_fim) THEN
			RETURN (UNIX_TIMESTAMP(exp_fim) - UNIX_TIMESTAMP(exp_ini))/60;
		ELSE
			RETURN (UNIX_TIMESTAMP(hour_ref) - UNIX_TIMESTAMP(exp_ini))/60;
		END IF;
	END IF;
END$$

DELIMITER ;
