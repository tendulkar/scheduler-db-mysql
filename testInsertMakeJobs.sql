DELIMITER $$
USE `scheduler`;

/*
    Since prepared statement optimizes the query for running multiple times,
    This code is to test the insert jobs into make_jobs and observe consequence flow
    Hence try to avoid using prepare statement to observe worst cases
*/

DROP PROCEDURE IF EXISTS insertJob;
CREATE PROCEDURE insertJob()
BEGIN
   INSERT INTO scheduler.make_jobs(type, user_id, item_parent_id, item_id, trigger_at, next_trigger_at, metadata, status)
        VALUES(2054, CONCAT('user_random_example', ROUND(1000000000.0 * RAND())), 1000, 999, UNIX_TIMESTAMP() + ROUND(100000.0 * RAND()), 
        UNIX_TIMESTAMP() + 100000 + ROUND(1000000.0 * RAND()), '{\"glossary\":{\"title\":\"example glossary\",\"GlossDiv\":{\"title\":\"S\",\"GlossList\":{\"GlossEntry\":{\"ID\":\"SGML\",\"SortAs\":\"SGML\",\"GlossTerm\":\"Standard Generalized Markup Language\",\"Acronym\":\"SGML\",\"Abbrev\":\"ISO 8879:1986\",\"GlossDef\":{\"para\":\"A meta-markup language, used to create markup languages such as DocBook.\",\"GlossSeeAlso\":[\"GML\",\"XML\"]},\"GlossSee\":\"markup\"}}}}}', 'RDY_TRIGGER_SAMPLE'); 
END $$


DROP PROCEDURE IF EXISTS insertUpdateJob;
CREATE PROCEDURE insertUpdateJob(v_id BIGINT UNSIGNED, v_type BIGINT UNSIGNED, v_item_parent_id BIGINT UNSIGNED, v_item_id BIGINT UNSIGNED, 
                v_trigger_at BIGINT UNSIGNED, v_next_trigger_at  BIGINT UNSIGNED, v_user_id CHAR(255), v_status CHAR(255), v_metadata MEDIUMTEXT)
BEGIN

    INSERT INTO scheduler.make_jobs(job_id, type, user_id, item_parent_id, item_id, trigger_at, next_trigger_at, metadata, status, operation)
        VALUES(v_id, v_type, v_user_id, v_item_parent_id, v_item_id, v_trigger_at, v_next_trigger_at, v_metadata, v_status, 'UPDATE');    
END $$

DROP PROCEDURE IF EXISTS insertUpdateJobById;
CREATE PROCEDURE insertUpdateJobById(v_id BIGINT UNSIGNED) 
BEGIN
     DECLARE v_job_id, v_type, v_trigger_at, v_item_parent_id, v_item_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
     DECLARE v_type_name, v_user_id, v_status, v_operation CHAR(255) DEFAULT NULL;
     DECLARE v_metadata MEDIUMTEXT;
     
     SELECT type, trigger_at, user_id, item_parent_id, item_id, metadata, next_trigger_at, status
        INTO v_type, v_trigger_at, v_user_id, v_item_parent_id, v_item_id, v_metadata, v_next_trigger_at, v_status
        FROM scheduler.jobs
        WHERE id = v_id;
    SET v_item_id = ROUND(1000 + 10000.0*RAND());
    CALL insertUpdateJob(v_id, v_type, v_item_parent_id, v_item_id, v_trigger_at, v_next_trigger_at, v_user_id, v_status, v_metadata);
END $$


DROP PROCEDURE IF EXISTS insertUpdateJobByUniqueKey;
CREATE PROCEDURE insertUpdateJobByUniqueKey(v_type BIGINT UNSIGNED, v_trigger_at BIGINT UNSIGNED, v_user_id CHAR(255), 
                    v_item_id BIGINT UNSIGNED, v_item_parent_id BIGINT UNSIGNED) 
BEGIN
     DECLARE v_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
     DECLARE v_type_name, v_status, v_operation CHAR(255) DEFAULT NULL;
     DECLARE v_metadata MEDIUMTEXT;
     
     SELECT id, metadata, next_trigger_at, status
        INTO v_id, v_metadata, v_next_trigger_at, v_status
        FROM scheduler.jobs
        WHERE type = v_type AND trigger_at = v_trigger_at AND user_id = v_user_id AND item_parent_id = v_item_parent_id AND item_id = v_item_id;
    SET v_item_id = ROUND(1000 + 10000.0*RAND());
    CALL insertUpdateJob(v_id, v_type, v_item_parent_id, v_item_id, v_trigger_at, v_next_trigger_at, v_user_id, v_status, v_metadata);
END $$


DROP FUNCTION IF EXISTS getJobIdByKey;
CREATE FUNCTION getJobIdByKey(v_type BIGINT UNSIGNED, v_trigger_at BIGINT UNSIGNED, v_user_id CHAR(255), 
                    v_item_id BIGINT UNSIGNED, v_item_parent_id BIGINT UNSIGNED) RETURNS BIGINT UNSIGNED NOT DETERMINISTIC READS SQL DATA
BEGIN
     DECLARE v_id, v_next_trigger_at BIGINT UNSIGNED DEFAULT NULL;
     DECLARE v_type_name, v_status, v_operation CHAR(255) DEFAULT NULL;
     DECLARE v_metadata MEDIUMTEXT;

     SELECT id INTO v_id
         FROM scheduler.jobs
         WHERE type = v_type AND trigger_at = v_trigger_at AND user_id = v_user_id AND item_parent_id = v_item_parent_id AND item_id = v_item_id;
     RETURN v_id;
END $$


DROP PROCEDURE IF EXISTS insertDeleteJob;
CREATE PROCEDURE insertDeleteJobById(IN v_id BIGINT UNSIGNED)
BEGIN
    INSERT INTO scheduler.make_jobs(job_id, operation)
        VALUES (v_id, 'DELETE'); 
END $$


DROP FUNCTION IF EXISTS insertDeleteJobsMultiple;
CREATE FUNCTION insertDeleteJobsMultiple(v_count BIGINT UNSIGNED, v_start_job_id BIGINT UNSIGNED)
                                    RETURNS BIGINT UNSIGNED NOT DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE ret_v_count BIGINT UNSIGNED DEFAULT v_count;
    delete_multiple: LOOP
        SET v_count = v_count -1;
        CALL insertDeleteJobById(v_start_job_id);
        SET v_start_job_id = v_start_job_id + 1;

        IF (v_count = 0) THEN
             LEAVE delete_multiple;
        END IF;
    END LOOP;
    RETURN ret_v_count;
END $$


DROP FUNCTION IF EXISTS insertUpdateJobsMultiple;
CREATE FUNCTION insertUpdateJobsMultiple(v_count BIGINT UNSIGNED, v_start_job_id BIGINT UNSIGNED) 
                                        RETURNS BIGINT UNSIGNED NOT DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE ret_v_count BIGINT UNSIGNED DEFAULT v_count;
    update_multiple: LOOP
        SET v_count = v_count -1;    
        CALL insertUpdateJobById(v_start_job_id);
        SET v_start_job_id = v_start_job_id + 1;

        IF (v_count = 0) THEN
            LEAVE update_multiple;
        END IF;
    END LOOP;
    RETURN ret_v_count;
END $$


DROP PROCEDURE IF EXISTS insertJobs;
CREATE PROCEDURE insertJobs(IN cnt BIGINT UNSIGNED)
BEGIN
    job_insert: LOOP
        SET cnt = cnt - 1;
        CALL insertJob();        
        IF cnt <> 0 THEN ITERATE job_insert; END IF;
        LEAVE job_insert;
    END LOOP job_insert;
END $$

DELIMITER ;
