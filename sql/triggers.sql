CREATE OR REPLACE FUNCTION log_professor_update()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.area_especializacao IS DISTINCT FROM NEW.area_especializacao THEN
        INSERT INTO professor_log_atividades (id_professor, acao)
        VALUES (
            NEW.id_utilizador,
            'Área de especialização atualizada de "' || COALESCE(OLD.area_especializacao, '[NULO]') || '" para "' || COALESCE(NEW.area_especializacao, '[NULO]') || '"'
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;