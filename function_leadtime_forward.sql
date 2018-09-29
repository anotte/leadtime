  DELIMITER $$

USE `database`$$

DROP FUNCTION IF EXISTS `function_leadtime_forward`$$

CREATE DEFINER=`root`@`localhost` FUNCTION `function_leadtime_forward`(DataRef DATETIME, TaskLeadtime INT) RETURNS VARCHAR(211) CHARSET latin1
    DETERMINISTIC
BEGIN
  DECLARE exp_ini TIME DEFAULT 0;
  DECLARE exp_fim TIME DEFAULT 0;
  DECLARE debug BIT DEFAULT 0;
  DECLARE dia INT DEFAULT 0;
  DECLARE feriado INT DEFAULT 0;
  DECLARE lt_remain INT DEFAULT 0;
  DECLARE lt_real INT DEFAULT 0;
  DECLARE wl_day INT DEFAULT 0;
  DECLARE step VARCHAR(255) DEFAULT '';
  SET lt_remain = TaskLeadtime;
	lead_loop : LOOP
		/*IF (lt_remain <= 0) THEN*/
		IF (lt_remain <= 0) THEN
			/*return concat(step, ' = ', lt_real, ' = ', DataRef);*/
			RETURN lt_real;
      LEAVE lead_loop;
    END IF;
		SET feriado = (SELECT COUNT(*) FROM tab_feriados WHERE DATE(dt_feriado_data) = DATE(DATE_ADD(DataRef, INTERVAL dia DAY)));
		
		IF (feriado = 1) THEN
			SET exp_ini = (SELECT tm_ini_expediente FROM tab_feriados WHERE DATE(dt_feriado_data) = DATE(DATE_ADD(DataRef, INTERVAL dia DAY)));
			SET exp_fim = (SELECT tm_fim_expediente FROM tab_feriados WHERE DATE(dt_feriado_data) = DATE(DATE_ADD(DataRef, INTERVAL dia DAY)));
			SET wl_day = (SELECT function_workload_day(exp_ini,exp_fim,DataRef,1));
			SET feriado = 0;
			IF (debug = 1) THEN
				SET step = CONCAT(step, 'F');
			END IF;
		ELSE
			SET exp_ini = (SELECT tm_ini_expediente FROM tab_horario_util WHERE int_dia_semana = DAYOFWEEK(DATE_ADD(DataRef, INTERVAL dia DAY)));
			SET exp_fim = (SELECT tm_fim_expediente FROM tab_horario_util WHERE int_dia_semana = DAYOFWEEK(DATE_ADD(DataRef, INTERVAL dia DAY)));
			SET wl_day = (SELECT function_workload_day(exp_ini,exp_fim,DataRef,1));
			SET step = CONCAT(step, '[WL:', 'wl_day]');
			IF (debug = 1) THEN
				SET step = CONCAT(step, '[NF]');
			END IF;
		END IF;
		
		IF (dia = 0) THEN
			IF (debug = 1) THEN
				SET step = CONCAT(step, '[D0]');
			END IF;
			IF (wl_day >= lt_remain) THEN
				SET lt_real = lt_real + lt_remain;
				SET lt_remain = 0;
			IF (debug = 1) THEN
				SET step = CONCAT(step, ' [w>=l] ', wl_day, '-', lt_remain, '-', lt_real, '\n');
			END IF;
			ELSE
				SET lt_remain = lt_remain - wl_day;
				SET lt_real = (lt_real + (SELECT ROUND(TIME_TO_SEC(TIMEDIFF('23:59:59', (DATE_FORMAT(DATE_ADD(DataRef, INTERVAL dia DAY),'%H:%i:%S'))))/60,0)));
				IF (debug = 1) THEN
					SET step = CONCAT(step, ' [w<=l] ', wl_day, '-', lt_remain, '-', lt_real, '\n');
				END IF;
			END IF;
		ELSE
			IF (debug = 1) THEN
				SET step = CONCAT(step, '-', 'D', dia);
			END IF;
			IF (wl_day >= lt_remain) THEN
				SET lt_real = (lt_real + (SELECT ROUND(TIME_TO_SEC(TIMEDIFF(exp_ini, ('00:00:00')))/60,0)) + lt_remain);
				SET lt_remain = 0;
				IF (debug = 1) THEN
					SET step = CONCAT(step, ' [w>=l] ', wl_day, '-', lt_remain, '-', lt_real, '-', exp_ini, '-', '\n');
				END IF;
			ELSE
				SET lt_remain = lt_remain - wl_day;
				SET lt_real = (lt_real + 1440);
			IF (debug = 1) THEN
				SET step = CONCAT(step, ' [w<=l] ', wl_day, '-', lt_remain, '-', lt_real, '\n');
			END IF;
			END IF;		
		END IF;
		
   	SET dia = dia + 1;
    SET DataRef = (CONCAT(DATE(DataRef), ' 00:00:00'));
  END LOOP;
END$$

DELIMITER ;
