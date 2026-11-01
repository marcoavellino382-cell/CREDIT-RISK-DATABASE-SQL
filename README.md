# 📊 Credit Risk Analysis Database (SQLite & DBeaver)

Questo progetto presenta il design e l'implementazione di un database relazionale serverless in **SQLite**, progettato specificamente per il monitoraggio e l'analisi del rischio di credito (*Credit Risk Architecture*). 

L'obiettivo è tracciare le anagrafiche dei clienti, l'andamento dei finanziamenti erogati, lo storico dei pagamenti e calcolare metriche core di Risk Management in conformità con i framework di vigilanza bancaria (es. Basilea).

## 🗂️ Struttura dell'Architettura Dati
Il database è composto da 4 tabelle principali collegate tramite vincoli di integrità referenziale:
* `clienti`: Dati anagrafici, segmentazione (`RETAIL` / `CORPORATE`) e Credit Scoring (1-1000).
* `finanziamenti`: Dati sui contratti di credito, tassi d'interesse, scadenze e stato del prestito.
* `rate_pagamenti`: Registro dei pagamenti e calcolo del Days Past Due (DPD).
* `metriche_rischio`: Parametri predittivi avanzati: **PD** (Probability of Default), **LGD** (Loss Given Default) ed **EAD** (Exposure at Default).

## 📈 Metriche Calcolate e Business Intelligence
Il database include una Vista SQL ottimizzata (`v_dashboard_credit_risk`) che unisce i silos di dati per calcolare dinamicamente:
1. **Expected Loss (EL)**: Calcolata analiticamente come $PD \times LGD \times EAD$.
2. **Classe di Rischio**: Segmentazione dinamica delle posizioni in base allo stato del credito (Basso, Medio, Alto Rischio, NPL/Sofferenze).

## 🚀 Come testare il progetto
1. Scarica il file `CreditRisk.db` presente in questa repository.
2. Aprilo con un client SQL come **DBeaver** o tramite un notebook **Python (Pandas/sqlite3)**.
3. Esegui la query per consultare la dashboard di rischio:
   ```sql
   SELECT * FROM v_dashboard_credit_risk;
   ```
