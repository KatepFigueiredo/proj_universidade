CREATE OR REPLACE FUNCTION log_professor_update()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se a área de especialização foi alterada
    IF OLD.area_especializacao IS DISTINCT FROM NEW.area_especializacao THEN
        INSERT INTO professor_log_atividades (id_professor, acao)
        VALUES (NEW.id_utilizador, 'Área de especialização atualizada de "' || OLD.area_especializacao || '" para "' || NEW.area_especializacao || '"');
    END IF;
    -- Adicionar mais condições para outros campos se existirem e quiser auditar
    RETURN NEW; -- Necessário para triggers AFTER UPDATE
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_professor_update
AFTER UPDATE ON professores_info
FOR EACH ROW
EXECUTE FUNCTION log_professor_update();