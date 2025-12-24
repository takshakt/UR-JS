-- ═══════════════════════════════════════════════════════════════════════════
-- BUG_REPORTS Trigger
-- Automatically updates audit fields on INSERT and UPDATE
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE TRIGGER TRG_BUG_REPORTS_AUDIT
BEFORE INSERT OR UPDATE ON BUG_REPORTS
FOR EACH ROW
DECLARE
  l_user VARCHAR2(255);
BEGIN
  -- Get current user (APEX user or database user)
  l_user := COALESCE(
    SYS_CONTEXT('APEX$SESSION', 'APP_USER'),
    SYS_CONTEXT('USERENV', 'SESSION_USER'),
    USER
  );

  IF INSERTING THEN
    -- Set created fields on insert
    :NEW.CREATED_ON := SYSTIMESTAMP;
    :NEW.CREATED_BY := COALESCE(:NEW.CREATED_BY, l_user);

    -- Ensure ID is set
    IF :NEW.ID IS NULL THEN
      :NEW.ID := SYS_GUID();
    END IF;
  END IF;

  IF UPDATING THEN
    -- Set updated fields on update
    :NEW.UPDATED_ON := SYSTIMESTAMP;
    :NEW.UPDATED_BY := l_user;

    -- Prevent modification of created fields
    :NEW.CREATED_ON := :OLD.CREATED_ON;
    :NEW.CREATED_BY := :OLD.CREATED_BY;

    -- Set resolved timestamp when status changes to RESOLVED or CLOSED
    IF :OLD.STATUS NOT IN ('RESOLVED', 'CLOSED')
       AND :NEW.STATUS IN ('RESOLVED', 'CLOSED')
       AND :NEW.RESOLVED_AT IS NULL THEN
      :NEW.RESOLVED_AT := SYSTIMESTAMP;
    END IF;
  END IF;
END TRG_BUG_REPORTS_AUDIT;
/
