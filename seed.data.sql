- 1. Inserimento Dati di Esempio nella Tabella Clienti
INSERT INTO clienti (nome_ragione_sociale, codice_fiscale_piva, tipo_cliente, data_inserimento, reddito_annuale_stima, punteggio_credit_scoring) VALUES
('Mario Rossi', 'RSSMRA80A01H501U', 'RETAIL', '2025-01-15', 32000.00, 750),
('Laura Bianchi', 'BNCHLR85B42F205Z', 'RETAIL', '2025-02-10', 45000.00, 820),
('Acme Corporation S.r.l.', '01234567890', 'CORPORATE', '2025-03-01', 580000.00, 610),
('Giovanni Verdi', 'VRDGNN78M12L219Y', 'RETAIL', '2025-04-20', 22000.00, 420), -- Clienti ad alto rischio
('TechSolutions S.p.A.', '09876543211', 'CORPORATE', '2025-05-12', 1250000.00, 890);

-- 2. Inserimento Finanziamenti Collegati ai Clienti
INSERT INTO finanziamenti (cliente_id, tipo_prodotto, data_erogazione, importo_concesso, tasso_interesse, durata_mesi, stato_finanziamento) VALUES
(1, 'Prestito Personale', '2025-01-20', 15000.00, 6.50, 36, 'ATTIVO'),
(2, 'Mutuo Casa', '2025-02-15', 180000.00, 3.80, 240, 'ATTIVO'),
(3, 'Fido di Cassa', '2025-03-05', 50000.00, 8.20, 12, 'ATTIVO'),
(4, 'Prestito Auto', '2025-04-25', 12000.00, 9.00, 48, 'IN_SOFFERENZA'), -- Cliente Verdi in difficoltà
(5, 'Leasing Macchinari', '2025-05-20', 300000.00, 4.50, 60, 'ATTIVO');

-- 3. Inserimento dello Storico Rate (Alcune pagate, alcune scadute/in ritardo)
INSERT INTO rate_pagamenti (finanziamento_id, data_scadenza, importo_rata, data_pagamento_effettivo, giorni_ritardo, stato_pagamento) VALUES
-- Finanziamento 1 (Puntuale)
(1, '2025-02-20', 460.00, '2025-02-18', 0, 'PAGATO'),
(1, '2025-03-20', 460.00, '2025-03-20', 0, 'PAGATO'),
-- Finanziamento 2 (Puntuale)
(2, '2025-03-15', 950.00, '2025-03-15', 0, 'PAGATO'),
-- Finanziamento 4 (In ritardo critico - DPD > 90 giorni che porta a deterioramento)
(4, '2025-05-25', 290.00, '2025-09-02', 100, 'SCADUTO'), 
(4, '2025-06-25', 290.00, NULL, 0, 'DA_PAGARE');

-- 4. Inserimento Metriche di Rischio (Fondamentali per Basilea / Accantonamenti)
-- Nota: perdita_attesa_el viene valorizzata manualmente qui, o tramite trigger in seguito
INSERT INTO metriche_rischio (finanziamento_id, data_valutazione, probability_of_default_pd, loss_given_default_lgd, exposure_at_default_ead, perdita_attesa_el) VALUES
(1, '2025-06-01', 0.0150, 0.4000, 13500.00, 81.00),   -- PD 1.5%, LGD 40% (Prestito non garantito standard)
(2, '2025-06-01', 0.0050, 0.1500, 178000.00, 133.50), -- PD bassa, LGD molto bassa (Mutuo coperto da ipoteca sulla casa)
(3, '2025-06-01', 0.0420, 0.4500, 48000.00, 907.20),  -- Rischio aziendale medio
(4, '2025-06-01', 0.2500, 0.5000, 11500.00, 1437.50), -- PD altissima (25%) dovuto allo stato di sofferenza
(5, '2025-06-01', 0.0080, 0.3000, 290000.00, 696.00);
