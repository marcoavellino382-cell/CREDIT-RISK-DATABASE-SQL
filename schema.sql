-- 1. Tabella Anagrafica Clienti
CREATE TABLE clienti (
    cliente_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_ragione_sociale TEXT NOT NULL,
    codice_fiscale_piva TEXT NOT NULL UNIQUE,
    tipo_cliente TEXT NOT NULL,
    data_inserimento TEXT DEFAULT (CURRENT_DATE),
    reddito_annuale_stima REAL,
    punteggio_credit_scoring INTEGER CHECK (punteggio_credit_scoring BETWEEN 1 AND 1000),
    CHECK (tipo_cliente IN ('RETAIL', 'CORPORATE'))
);

-- 2. Tabella Contratti di Finanziamento
CREATE TABLE finanziamenti (
    finanziamento_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cliente_id INTEGER,
    tipo_prodotto TEXT NOT NULL,
    data_erogazione TEXT NOT NULL,
    importo_concesso REAL NOT NULL,
    tasso_interesse REAL NOT NULL,
    durata_mesi INTEGER NOT NULL,
    stato_finanziamento TEXT DEFAULT 'ATTIVO' CHECK (stato_finanziamento IN ('ATTIVO', 'CHIUSO', 'IN_SOFFERENZA', 'DEFAULT')),
    FOREIGN KEY (cliente_id) REFERENCES clienti(cliente_id) ON DELETE CASCADE
);

-- 3. Tabella Storico Pagamenti e Rate
CREATE TABLE rate_pagamenti (
    rata_id INTEGER PRIMARY KEY AUTOINCREMENT,
    finanziamento_id INTEGER,
    data_scadenza TEXT NOT NULL,
    importo_rata REAL NOT NULL,
    data_pagamento_effettivo TEXT,
    giorni_ritardo INTEGER DEFAULT 0,
    stato_pagamento TEXT DEFAULT 'DA_PAGARE',
    FOREIGN KEY (finanziamento_id) REFERENCES finanziamenti(finanziamento_id) ON DELETE CASCADE,
    CHECK (stato_pagamento IN ('PAGATO', 'PARZIALE', 'DA_PAGARE', 'SCADUTO'))
);

-- 4. Tabella Metriche di Rischio
CREATE TABLE metriche_rischio (
    metrica_id INTEGER PRIMARY KEY AUTOINCREMENT,
    finanziamento_id INTEGER,
    data_valutazione TEXT DEFAULT (CURRENT_DATE),
    probability_of_default_pd REAL CHECK (probability_of_default_pd BETWEEN 0 AND 1),
    loss_given_default_lgd REAL CHECK (loss_given_default_lgd BETWEEN 0 AND 1),
    exposure_at_default_ead REAL,
    perdita_attesa_el REAL,
    FOREIGN KEY (finanziamento_id) REFERENCES finanziamenti(finanziamento_id) ON DELETE CASCADE
);
