USE scheduler;
DELIMITER $$

DROP PROCEDURE IF EXISTS deletePreparedStatements;
CREATE PROCEDURE deletePreparedStatements()
BEGIN
    DEALLOCATE PREPARE insertJobsStmt;
    DEALLOCATE PREPARE updateJobsStmt;
    DEALLOCATE PREPARE deleteJobsStmt;
    DEALLOCATE PREPARE deleteMakeJobsStmt;
END $$


DROP PROCEDURE IF EXISTS makePreparedStatements;
CREATE PROCEDURE makePreparedStatements()
BEGIN
    PREPARE insertJobsStmt FROM 'INSERT INTO scheduler.jobs (type, trigger_at, user_id, item_parent_id, item_id, metadata, next_trigger_at, status)
                            VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE last_updated = CURRENT_TIMESTAMP()';
    PREPARE updateJobsStmt FROM 'UPDATE scheduler.jobs
                            SET type = ?, trigger_at = ?, user_id = ?, item_parent_id = ?, item_id = ?,  metadata = ?, next_trigger_at = ?, status = ?
                            WHERE id = ?';
    PREPARE deleteJobsStmt FROM 'DELETE FROM scheduler.jobs WHERE id = ?';
    PREPARE deleteMakeJobsStmt FROM 'DELETE FROM scheduler.make_jobs WHERE id = ?';
END $$


DROP PROCEDURE IF EXISTS move_one_job;
CREATE PROCEDURE move_one_job(v_id BIGINT UNSIGNED, v_job_id BIGINT UNSIGNED, v_type BIGINT UNSIGNED, v_type_name CHAR(255), v_trigger_at BIGINT UNSIGNED,
                                 v_user_id CHAR(255), v_item_parent_id BIGINT UNSIGNED, v_item_id BIGINT UNSIGNED, v_metadata MEDIUMTEXT, 
                              v_status CHAR(255), v_next_trigger_at BIGINT UNSIGNED, v_last_updated TIMESTAMP, v_operation CHAR(255))
BEGIN
    DECLARE tempId BIGINT UNSIGNED;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN 
            ROLLBACK; 
            IF(v_last_updated < NOW() - INTERVAL 20 MINUTE) THEN 
                SET autocommit = true;
                SET @s_temp_id = v_id;
                EXECUTE deleteMakeJobsStmt USING @s_temp_id;
            END IF;
        END;
            
            SET @s_v_id = v_id, @s_v_type = v_type, @s_v_trigger_at = v_trigger_at, @s_v_user_id = v_user_id, @s_v_item_parent_id = v_item_parent_id,
                @s_v_item_id = v_item_id, @s_v_metadata = v_metadata, @s_v_next_trigger_at = v_next_trigger_at, @s_v_status = v_status;
            SET autocommit = false;
            START TRANSACTION;
                SELECT id INTO tempId FROM scheduler.make_jobs WHERE id = v_id FOR UPDATE;

                IF (v_operation <> 'DELETE' AND v_type IS NULL OR v_type = 0) THEN 
                    SELECT id INTO v_type FROM scheduler.type WHERE name = v_type_name LIMIT 1; 
                END IF; 
          
                IF (v_operation <> 'INSERT' AND v_job_id IS NULL OR v_job_id = 0) THEN 
                    SELECT id INTO v_job_id FROM scheduler.jobs 
                        WHERE type = v_type AND trigger_at = v_trigger_at AND user_id = v_user_id AND item_parent_id = v_item_parent_id AND item_id = v_item_id LIMIT 1; 
                END IF ;  
                SET @s_v_job_id = v_job_id;
                 
                IF (v_type IS NOT NULL AND v_type <> 0  AND v_operation = 'INSERT') THEN 
                   EXECUTE insertJobsStmt USING @s_v_type, @s_v_trigger_at, @s_v_user_id, @s_v_item_parent_id, @s_v_item_id, @s_v_metadata, @s_v_next_trigger_at, @s_v_status;
                END IF; 
            
                /*SELECT @s_v_type, @s_v_trigger_at, @s_v_user_id, @s_v_item_parent_id, @s_v_item_id, @s_v_metadata, @s_v_next_trigger_at, @s_v_status, @s_v_job_id;*/
                IF (v_type IS NOT NULL AND v_type <> 0 AND v_job_id IS NOT NULL AND v_job_id <> 0) THEN 
                    IF (v_operation = 'UPDATE') THEN 
                        /*SELECT @s_v_type, @s_v_trigger_at, @s_v_user_id, @s_v_item_parent_id, @s_v_item_id, @s_v_metadata, @s_v_next_trigger_at, @s_v_status, @s_v_job_id;*/
                        EXECUTE updateJobsStmt USING @s_v_type, @s_v_trigger_at, @s_v_user_id, @s_v_item_parent_id, @s_v_item_id, 
                        @s_v_metadata, @s_v_next_trigger_at, @s_v_status, @s_v_job_id;
                    END IF ; 
                END IF;

                IF (v_job_id IS NOT NULL AND v_job_id > 0 AND v_operation = 'DELETE') THEN 
                    EXECUTE deleteJobsStmt USING @s_v_job_id ;
                END IF;  
                EXECUTE deleteMakeJobsStmt USING @s_v_id ;
            COMMIT;
END; 


DROP EVENT IF EXISTS move_jobs; 
DROP PROCEDURE IF EXISTS move_jobs;
CREATE EVENT move_jobs ON SCHEDULE EVERY 20 SECOND DO
/* CREATE PROCEDURE move_jobs() */
    BEGIN 
        DECLARE v_id, v_job_id, v_type, v_trigger_at, v_item_parent_id, v_item_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
        DECLARE v_type_name, v_user_id, v_status, v_operation CHAR(255) DEFAULT NULL;
        DECLARE v_metadata MEDIUMTEXT;
        DECLARE v_last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP();
        DECLARE finished BOOLEAN DEFAULT false;
        DECLARE insertJobsStmt, updateJobsStmt, deleteJobsStmt, deleteMakeJobsStmt VARCHAR(4096);
        DECLARE readyJobs CURSOR FOR 
            SELECT id, job_id, type, type_name, trigger_at, user_id, item_parent_id, item_id, metadata, status, 
                next_trigger_at, last_updated, operation FROM scheduler.make_jobs; 
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = true; 
        
        CALL makePreparedStatements();        
        /* 
        SELECT id, job_id, type, type_name, trigger_at, user_id, item_parent_id, item_id, metadata, status, 
            next_trigger_at, last_updated, operation FROM scheduler.make_jobs; 
        */
        
        SET finished = false;
        OPEN readyJobs; 
        move_job: LOOP 
            
            FETCH readyJobs INTO v_id, v_job_id, v_type, v_type_name, v_trigger_at, v_user_id, v_item_parent_id, v_item_id, 
                v_metadata, v_status, v_next_trigger_at, v_last_updated, v_operation; 
            IF finished IS NOT false THEN LEAVE move_job; END IF; 
            call move_one_job(v_id, v_job_id, v_type, v_type_name, v_trigger_at, v_user_id, v_item_parent_id, v_item_id, v_metadata, 
                            v_status, v_next_trigger_at, v_last_updated, v_operation);

            /* 
            SET @s_temp_id = v_id;
            EXECUTE deleteMakeJobsStmt USING @s_temp_id;
            */
         END LOOP;
         
         CLOSE readyJobs; 
         CALL deletePreparedStatements();
    END$$


DELIMITER ;
