CREATE VIEW IF NOT EXISTS v_dashboard_credit_risk AS
SELECT 
    c.cliente_id,
    c.nome_ragione_sociale AS cliente,
    c.tipo_cliente,
    c.punteggio_credit_scoring AS credit_score,
    f.finanziamento_id,
    f.tipo_prodotto,
    f.importo_concesso,
    f.stato_finanziamento,
    mr.probability_of_default_pd AS pd,
    mr.loss_given_default_lgd AS lgd,
    mr.exposure_at_default_ead AS ead,
    -- Calcoliamo la Expected Loss (Perdita Attesa) direttamente nella vista!
    ROUND(mr.probability_of_default_pd * mr.loss_given_default_lgd * mr.exposure_at_default_ead, 2) AS expected_loss,
    -- Classificazione del rischio per la Dashboard
    CASE 
        WHEN f.stato_finanziamento IN ('IN_SOFFERENZA', 'DEFAULT') THEN 'CRITICO (NPL)'
        WHEN mr.probability_of_default_pd > 0.05 OR c.punteggio_credit_scoring < 500 THEN 'ALTO RISCHIO'
        WHEN mr.probability_of_default_pd BETWEEN 0.015 AND 0.05 THEN 'MEDIO RISCHIO'
        ELSE 'BASSO RISCHIO'
    END AS classe_rischio
FROM finanziamenti f
JOIN clienti c ON f.cliente_id = c.cliente_id
LEFT JOIN metriche_rischio mr ON f.finanziamento_id = mr.finanziamento_id;

SELECT * FROM v_dashboard_credit_risk;

SELECT 
    COUNT(DISTINCT cliente_id) AS totale_clienti,
    COUNT(finanziamento_id) AS totale_finanziamenti_erogati,
    SUM(importo_concesso) AS capitale_totale_erogato,
    ROUND(SUM(expected_loss), 2) AS perdita_attesa_totale_portafoglio,
    ROUND((SUM(expected_loss) / SUM(importo_concesso)) * 100, 2) AS tasso_di_rischio_medio_perc
FROM v_dashboard_credit_risk;
