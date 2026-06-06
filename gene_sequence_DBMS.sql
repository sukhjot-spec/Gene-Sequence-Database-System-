-- SQL script for gene sequence database

create database gene_sequence_db;
use gene_sequence_db;


-- Table: ORGANISM
create table ORGANISM (
      organism_id          INT AUTO_INCREMENT PRIMARY KEY,
      scientific_name     VARCHAR(255) NOT NULL,
      common_name         VARCHAR(100),
      taxonomy_class      VARCHAR(100),
      genome_size_mb      DECIMAL(10,2),
      description         TEXT,
      UNIQUE KEY uq_scientific_name (scientific_name)
) ENGINE=InnoDB;


-- Table: GENE
create table GENE (
      gene_id             INT AUTO_INCREMENT PRIMARY KEY,
      gene_name           VARCHAR(100) NOT NULL,
      organism_id         INT NOT NULL,
      chromosome_location VARCHAR(50),
      gene_function       TEXT,
      is_coding           BOOLEAN NOT NULL,
      discovery_year      YEAR,
      FOREIGN KEY (organism_id) REFERENCES ORGANISM(organism_id)
          ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table: RESEARCHER
 create table RESEARCHER (
      researcher_id       INT AUTO_INCREMENT PRIMARY KEY,
      full_name           VARCHAR(150) NOT NULL,
      institution         VARCHAR(150),
      email               VARCHAR(150) NOT NULL UNIQUE,
      specialization      VARCHAR(150)
) ENGINE=InnoDB;

-- Table: SEQUENCE
create table SEQUENCE (
      sequence_id         INT AUTO_INCREMENT PRIMARY KEY,
      gene_id             INT NOT NULL,
      sequence_type       ENUM('DNA','RNA','Protein') NOT NULL,
      sequence_data       LONGTEXT NOT NULL,
      sequence_length    INT NOT NULL,
      accession_number    VARCHAR(50) NOT NULL UNIQUE,
      date_submitted      DATE NOT NULL,
      source_database     VARCHAR(100) NOT NULL,
      FOREIGN KEY (gene_id) REFERENCES GENE(gene_id)
          ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

 -- Table: ANNOTATION
create table ANNOTATION (
      annotation_id       INT AUTO_INCREMENT PRIMARY KEY,
      sequence_id         INT NOT NULL,
      researcher_id       INT NOT NULL,
      annotation_type    ENUM('Functional','Structural','Variant','Expression','Regulatory') NOT NULL,
      annotation_text     TEXT NOT NULL,
      annotation_date     DATE NOT NULL,
      confidence_score   DECIMAL(3,2) NOT NULL,
      FOREIGN KEY (sequence_id) REFERENCES SEQUENCE(sequence_id)
          ON DELETE RESTRICT ON UPDATE CASCADE,
      FOREIGN KEY (researcher_id) REFERENCES RESEARCHER(researcher_id)
          ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table: EXPERIMENT
create table EXPERIMENT (
      experiment_id       INT AUTO_INCREMENT PRIMARY KEY,
      experiment_name    VARCHAR(150) NOT NULL,
      gene_id            INT NOT NULL,
      researcher_id      INT NOT NULL,
      experiment_type    VARCHAR(100) NOT NULL,
      start_date         DATE NOT NULL,
      end_date           DATE NOT NULL,
      result_summary     TEXT,
      FOREIGN KEY (gene_id) REFERENCES GENE(gene_id)
          ON DELETE RESTRICT ON UPDATE CASCADE,
      FOREIGN KEY (researcher_id) REFERENCES RESEARCHER(researcher_id)
          ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Inserting sample data
-- Organisms (5)
INSERT INTO ORGANISM (organism_id, scientific_name, common_name, taxonomy_class, genome_size_mb, description) VALUES
  (1, 'Homo sapiens',        'Human',          'Mammalia',      3200.00, 'The human genome has ~3.2 Gb of DNA.'),
  (2, 'Mus musculus',       'Mouse',          'Mammalia',      2700.00, 'Model organism for mammalian genetics.'),
  (3, 'Escherichia coli',   'E. coli',        'Gammaproteobacteria', 4.60, 'Prokaryotic model organism.'),
  (4, 'Saccharomyces cerevisiae', 'Baker''s yeast', 'Fungi', 12.10, 'Eukaryotic unicellular fungus.'),
  (5, 'Arabidopsis thaliana','Thale cress',   'Dicotyledons', 135.00, 'Model plant for genetics.');
  
-- Genes (10)
INSERT INTO GENE (gene_id, gene_name, organism_id, chromosome_location, gene_function, is_coding, discovery_year)
  VALUES
  (1,  'BRCA1',      1, '17q21.31', 'DNA repair, tumor suppressor',                1, 1994),
  (2,  'TP53',       1, '17p13.1',  'Cell cycle regulation, apoptosis',           1, 1979),
  (3,  'CFTR',       1, '7q31.2',   'Chloride channel, cystic fibrosis',            1, 1989),
  (4,  'lacZ',       3, 'unknown (plasmid)', 'Beta‑galactosidase enzyme',          1, 1963),
  (5,  'GAL4',       4, 'IV',       'Transcription activator',                     1, 1989),
  (6,  'At1g01010',  5, '1',        'Unknown protein',                            1, 2001),
  (7,  'MTHFR',      1, '1p36.22',  'Methylenetetrahydrofolate reductase',       1, 1995),
  (8,  'EGFR',       2, '11q22',    'Epidermal growth factor receptor',           1, 1980),
  (9,  'MYC',        2, '15q24.1',  'Transcription factor',                        1, 1978),
  (10, 'HBB',        2, '11p15.5',  'Beta globin chain of hemoglobin',            1, 1960);
  
-- Researchers (5)
INSERT INTO RESEARCHER (researcher_id, full_name, institution, email, specialization) VALUES
  (1, 'Dr. Ananya Singh',   'NIT Jalandhar',          'ananya.singh@nitj.ac.in', 'Genomics'),
  (2, 'Prof. Rajesh Kumar',  'IIT Delhi',               'rajesh.kumar@iitd.ac.in','Molecular Biology'),
  (3, 'Ms. Priya Patel',     'University of Cambridge','priya.patel@cam.ac.uk','Bioinformatics'),
  (4, 'Mr. Kevin Lee',       'Stanford University',    'kevin.lee@stanford.edu','Computational Biology'),
  (5, 'Dr. Maria Gomez',     'University of Barcelona','m.gomez@ub.edu','Proteomics');
  
-- Sequences (15)
INSERT INTO SEQUENCE (sequence_id, gene_id, sequence_type, sequence_data, sequence_length, accession_number, date_submitted, source_database) VALUES
  (1, 1, 'DNA',    'ATG...DNA1',     1863, 'NM_007294', '2025-01-15', 'NCBI'),
  (2, 1, 'Protein','MDSKG...PRO1',   620, 'NP_009225', '2025-01-15', 'NCBI'),
  (3, 2, 'DNA',    'ATG...DNA2',     1179, 'NM_000546', '2025-02-10', 'NCBI'),
  (4, 2, 'Protein','MDLKG...PRO2',   393, 'NP_000537', '2025-02-10', 'NCBI'),
  (5, 3, 'DNA',    'ATG...DNA3',     4443, 'NM_000492', '2025-03-01', 'NCBI'),
  (6, 3, 'Protein','MALW...PRO3',   1480, 'NP_000483', '2025-03-01', 'NCBI'),
  (7, 4, 'DNA',    'ATG...DNA4',     3072, 'U00096',    '2025-03-05', 'NCBI'),
  (8, 4, 'Protein','MARI...PRO4',   1024, 'P0A8V2',    '2025-03-05', 'NCBI'),
  (9, 5, 'DNA',    'ATG...DNA5',     4743, 'NM_001221', '2025-04-01', 'NCBI'),
  (10,5, 'Protein','MLKR...PRO5',   1581, 'NP_001212', '2025-04-01', 'NCBI'),
  (11,6, 'DNA',    'ATG...DNA6',     2100, 'AT1G01010', '2025-04-10', 'NCBI'),
  (12,7, 'DNA',    'ATG...DNA7',     2013, 'NM_005957', '2025-04-12', 'NCBI'),
  (13,8, 'DNA',    'ATG...DNA8',     2450, 'NM_005228', '2025-04-15', 'NCBI'),
  (14,9, 'DNA',    'ATG...DNA9',     2121, 'NM_002467', '2025-04-18', 'NCBI'),
  (15,10,'DNA',    'ATG...DNA10',    1600, 'NM_000518', '2025-04-20', 'NCBI');
  
-- Annotations (10)
INSERT INTO ANNOTATION (annotation_id, sequence_id, researcher_id, annotation_type, annotation_text, annotation_date, confidence_score) VALUES
  (1, 1, 3, 'Functional', 'BRCA1 contains a BRCT domain involved in DNA repair.',            '2025-03-01', 0.95),
  (2, 3, 2, 'Structural', 'TP53 has a DNA‑binding core domain that mediates transcriptional control.', '2025-03-02', 0.90),
  (3, 5, 1, 'Variant',    'Common CFTR ΔF508 deletion leads to cystic fibrosis.',                '2025-03-05', 0.97),
  (4, 7, 4, 'Functional', 'lacZ encodes β‑galactosidase, widely used for blue‑white screening.', '2025-04-01', 0.92),
  (5, 9, 5, 'Regulatory', 'GAL4 binds upstream activation sequences in yeast promoters.',       '2025-04-02', 0.88),
  (6,11, 3, 'Expression', 'At1g01010 is highly expressed in root tissue.',                      '2025-04-10', 0.85),
  (7,12, 1, 'Functional', 'MTHFR catalyzes conversion of 5,10‑methylenetetrahydrofolate to 5‑methyltetrahydrofolate.', '2025-04-12', 0.93),
  (8,13, 2, 'Structural', 'EGFR extracellular domain mediates ligand binding.',                 '2025-04-15', 0.94),
  (9,14, 4, 'Variant',    'MYC amplification is linked to tumorigenesis in several cancers.',   '2025-04-20', 0.89),
  (10,15,5, 'Functional', 'HBB encodes the beta chain of hemoglobin, essential for oxygen transport.', '2025-04-22', 0.96);
  
-- Experiments (6)
INSERT INTO EXPERIMENT (experiment_id, experiment_name, gene_id, researcher_id, experiment_type, start_date, end_date, result_summary) VALUES
  (1, 'BRCA1 DNA Repair Assay',         1, 1, 'CRISPR knockout',          '2025-05-01', '2025-05-10', 'Knockout reduced
  DNA repair efficiency by 40%'),
  (2, 'TP53 Apoptosis Study',          2, 2, 'RNAi silencing',           '2025-05-12', '2025-05-20', 'Silencing
  increased apoptosis in HeLa cells'),
  (3, 'CFTR Function Test',            3, 3, 'Patch-clamp electrophysiology','2025-06-01', '2025-06-15', 'ΔF508 mutant
  shows reduced chloride transport'),
  (4, 'lacZ Reporter Assay',           4, 4, 'Beta‑galactosidase activity','2025-06-20', '2025-06-25', 'Reporter
  activity confirmed promoter strength'),
  (5, 'MTHFR Methylation Study',      7, 5, 'Bisulfite sequencing',     '2025-07-01', '2025-07-10', 'High methylation
  correlates with reduced enzyme activity'),
  (6, 'EGFR Inhibitor Screen',        8, 2, 'High‑throughput drug screen','2025-07-15', '2025-07-30', 'Identified 3
  compounds decreasing EGFR phosphorylation');
  
  
-- Basic Queries (5)
-- 1. Retrieve all organisms
  SELECT * FROM ORGANISM;

-- 2. List gene names together with their organism's scientific name
SELECT g.gene_name, o.scientific_name
FROM GENE g
JOIN ORGANISM o ON g.organism_id = o.organism_id;

-- 3. Show all sequences with accession numbers and source databases
SELECT sequence_id, accession_number, source_database
FROM SEQUENCE;

-- 4. List all researchers and their specializations
SELECT researcher_id, full_name, specialization
FROM RESEARCHER;

-- 5. Display experiments with their start and end dates
SELECT experiment_name, start_date, end_date
FROM EXPERIMENT;  
  
  

-- Intermediate Queries (5)

-- 1. Find all protein sequences belonging to genes of Homo sapiens
SELECT s.sequence_id, s.accession_number, s.sequence_length
FROM SEQUENCE s
JOIN GENE g ON s.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id
WHERE s.sequence_type = 'Protein' AND o.scientific_name = 'Homo sapiens';

-- 2. Retrieve annotations with confidence > 0.90 together with the associated gene name
SELECT a.annotation_id, a.confidence_score, g.gene_name
FROM ANNOTATION a
JOIN SEQUENCE s ON a.sequence_id = s.sequence_id
JOIN GENE g ON s.gene_id = g.gene_id
WHERE a.confidence_score > 0.90;

-- 3. Count the number of sequences per gene
SELECT g.gene_name, COUNT(s.sequence_id) AS sequence_count
FROM GENE g
LEFT JOIN SEQUENCE s ON g.gene_id = s.gene_id
GROUP BY g.gene_id, g.gene_name;

-- 4. List genes that have no annotations attached
SELECT g.gene_id, g.gene_name
FROM GENE g
LEFT JOIN SEQUENCE s ON g.gene_id = s.gene_id
LEFT JOIN ANNOTATION a ON s.sequence_id = a.sequence_id
WHERE a.annotation_id IS NULL
GROUP BY g.gene_id, g.gene_name;

-- 5. Researchers who have conducted more than one experiment
SELECT r.researcher_id, r.full_name, COUNT(e.experiment_id) AS experiments_count
FROM RESEARCHER r
JOIN EXPERIMENT e ON r.researcher_id = e.researcher_id
GROUP BY r.researcher_id, r.full_name
HAVING COUNT(e.experiment_id) > 1;


-- Advanced Queries (5)

-- 1. Find genes that have both DNA and Protein sequences recorded
SELECT g.gene_id, g.gene_name
FROM GENE g
WHERE EXISTS (
  SELECT 1 FROM SEQUENCE s WHERE s.gene_id = g.gene_id AND s.sequence_type = 'DNA'
) AND EXISTS (
  SELECT 1 FROM SEQUENCE s WHERE s.gene_id = g.gene_id AND s.sequence_type = 'Protein'
);

-- 2. Experiments on Mus musculus genes lasting more than 5 days
SELECT e.experiment_name, DATEDIFF(e.end_date, e.start_date) AS duration_days
FROM EXPERIMENT e
JOIN GENE g ON e.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id
WHERE o.scientific_name = 'Mus musculus'
AND DATEDIFF(e.end_date, e.start_date) > 5;

-- 3. Sequences that have at least one annotation with confidence < 0.90
SELECT DISTINCT s.sequence_id, s.accession_number
FROM SEQUENCE s
WHERE EXISTS (
  SELECT 1 FROM ANNOTATION a
  WHERE a.sequence_id = s.sequence_id
	AND a.confidence_score < 0.90
);

-- 4. Latest annotation (by date) for each sequence
SELECT a.*
FROM ANNOTATION a
JOIN (
  SELECT sequence_id, MAX(annotation_date) AS max_date
  FROM ANNOTATION
  GROUP BY sequence_id
) latest ON a.sequence_id = latest.sequence_id AND a.annotation_date = latest.max_date;

-- 5. Researchers who have annotated sequences from at least three distinct organisms
SELECT r.researcher_id, r.full_name, COUNT(DISTINCT o.organism_id) AS organism_count
FROM RESEARCHER r
JOIN ANNOTATION a ON r.researcher_id = a.researcher_id
JOIN SEQUENCE s ON a.sequence_id = s.sequence_id
JOIN GENE g ON s.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id
GROUP BY r.researcher_id, r.full_name
HAVING COUNT(DISTINCT o.organism_id) >= 3;

  
-- Aggregate Queries (3)

-- 1. Total number of sequences per organism
SELECT o.scientific_name, COUNT(s.sequence_id) AS total_sequences
FROM ORGANISM o
JOIN GENE g ON o.organism_id = g.organism_id
JOIN SEQUENCE s ON g.gene_id = s.gene_id
GROUP BY o.organism_id, o.scientific_name;

-- 2. Average annotation confidence score per researcher
SELECT r.full_name, AVG(a.confidence_score) AS avg_confidence
FROM RESEARCHER r
JOIN ANNOTATION a ON r.researcher_id = a.researcher_id
GROUP BY r.researcher_id, r.full_name;

-- 3. Total number of experiments per experiment type
SELECT experiment_type, COUNT(*) AS experiment_count
FROM EXPERIMENT
GROUP BY experiment_type;


-- UPDATE examples (2)

-- 1. Update email address of researcher #2
UPDATE RESEARCHER
SET email = 'rajesh.kumar@newinstitution.edu'
WHERE researcher_id = 2;

-- 2. Correct the sequence length of accession NM_005228 after re‑annotation
UPDATE SEQUENCE
SET sequence_length = 2500
WHERE accession_number = 'NM_005228';


-- DELETE examples (2)

-- 1. Delete a low‑confidence annotation (id = 4)
DELETE FROM ANNOTATION
WHERE annotation_id = 4;

-- 2. Delete a gene that currently has no associated sequences (example gene_id = 6)
DELETE FROM GENE
WHERE gene_id = 6
AND NOT EXISTS (SELECT 1 FROM SEQUENCE WHERE gene_id = 6);

 
-- VIEW definitions (2)

-- 1. View showing detailed sequence information together with gene and organism
CREATE VIEW view_sequence_details AS
SELECT
  s.sequence_id,
  s.accession_number,
  s.sequence_type,
  s.sequence_length,
  s.source_database,
  g.gene_name,
  o.scientific_name AS organism_name
FROM SEQUENCE s
JOIN GENE g ON s.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id;


-- Intermediate Queries (5)

-- 1. Find all protein sequences belonging to genes of Homo sapiens
SELECT s.sequence_id, s.accession_number, s.sequence_length
FROM SEQUENCE s
JOIN GENE g ON s.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id
WHERE s.sequence_type = 'Protein' AND o.scientific_name = 'Homo sapiens';

-- 2. Retrieve annotations with confidence > 0.90 together with the associated gene name
SELECT a.annotation_id, a.confidence_score, g.gene_name
FROM ANNOTATION a
JOIN SEQUENCE s ON a.sequence_id = s.sequence_id
JOIN GENE g ON s.gene_id = g.gene_id
WHERE a.confidence_score > 0.90;

-- 3. Count the number of sequences per gene
SELECT g.gene_name, COUNT(s.sequence_id) AS sequence_count
FROM GENE g
LEFT JOIN SEQUENCE s ON g.gene_id = s.gene_id
GROUP BY g.gene_id, g.gene_name;

-- 4. List genes that have no annotations attached
SELECT g.gene_id, g.gene_name
FROM GENE g
LEFT JOIN SEQUENCE s ON g.gene_id = s.gene_id
LEFT JOIN ANNOTATION a ON s.sequence_id = a.sequence_id
WHERE a.annotation_id IS NULL
GROUP BY g.gene_id, g.gene_name;

-- 5. Researchers who have conducted more than one experiment
SELECT r.researcher_id, r.full_name, COUNT(e.experiment_id) AS
experiments_count
FROM RESEARCHER r
JOIN EXPERIMENT e ON r.researcher_id = e.researcher_id
GROUP BY r.researcher_id, r.full_name
HAVING COUNT(e.experiment_id) > 1;

 
-- Advanced Queries (5)

-- 1. Find genes that have both DNA and Protein sequences recorded
SELECT g.gene_id, g.gene_name
FROM GENE g
WHERE EXISTS (
  SELECT 1 FROM SEQUENCE s WHERE s.gene_id = g.gene_id AND
s.sequence_type = 'DNA'
) AND EXISTS (
  SELECT 1 FROM SEQUENCE s WHERE s.gene_id = g.gene_id AND
s.sequence_type = 'Protein'
);

-- 2. Experiments on Mus musculus genes lasting more than 5 days
SELECT e.experiment_name, DATEDIFF(e.end_date, e.start_date) AS
duration_days
FROM EXPERIMENT e
JOIN GENE g ON e.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id
WHERE o.scientific_name = 'Mus musculus'
AND DATEDIFF(e.end_date, e.start_date) > 5;

-- 3. Sequences that have at least one annotation with confidence < 0.90
SELECT DISTINCT s.sequence_id, s.accession_number
FROM SEQUENCE s
WHERE EXISTS (
  SELECT 1 FROM ANNOTATION a
  WHERE a.sequence_id = s.sequence_id
	AND a.confidence_score < 0.90
);

-- 4. Latest annotation (by date) for each sequence
SELECT a.*
FROM ANNOTATION a
JOIN (
  SELECT sequence_id, MAX(annotation_date) AS max_date
  FROM ANNOTATION
  GROUP BY sequence_id
) latest ON a.sequence_id = latest.sequence_id AND a.annotation_date =
latest.max_date;

-- 5. Researchers who have annotated sequences from at least three distinct organisms
SELECT r.researcher_id, r.full_name, COUNT(DISTINCT o.organism_id) AS
organism_count
FROM RESEARCHER r
JOIN ANNOTATION a ON r.researcher_id = a.researcher_id
JOIN SEQUENCE s ON a.sequence_id = s.sequence_id
JOIN GENE g ON s.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id
GROUP BY r.researcher_id, r.full_name
HAVING COUNT(DISTINCT o.organism_id) >= 3;


-- Aggregate Queries (3)

-- 1. Total number of sequences per organism
SELECT o.scientific_name, COUNT(s.sequence_id) AS total_sequences
FROM ORGANISM o
JOIN GENE g ON o.organism_id = g.organism_id
JOIN SEQUENCE s ON g.gene_id = s.gene_id
GROUP BY o.organism_id, o.scientific_name;

-- 2. Average annotation confidence score per researcher
SELECT r.full_name, AVG(a.confidence_score) AS avg_confidence
FROM RESEARCHER r
JOIN ANNOTATION a ON r.researcher_id = a.researcher_id
GROUP BY r.researcher_id, r.full_name;

-- 3. Total number of experiments per experiment type
SELECT experiment_type, COUNT(*) AS experiment_count
FROM EXPERIMENT
GROUP BY experiment_type;


-- UPDATE examples (2)
  
-- 1. Update email address of researcher #2
UPDATE RESEARCHER
SET email = 'rajesh.kumar@newinstitution.edu'
WHERE researcher_id = 2;

-- 2. Correct the sequence length of accession NM_005228 after re-annotation
UPDATE SEQUENCE
SET sequence_length = 2500
WHERE accession_number = 'NM_005228';

 
-- DELETE examples (2)
 
-- 1. Delete a low‑confidence annotation (id = 4)
DELETE FROM ANNOTATION
WHERE annotation_id = 4;

-- 2. Delete a gene that currently has no associated sequences (example gene_id = 6)
DELETE FROM GENE
WHERE gene_id = 6
AND NOT EXISTS (SELECT 1 FROM SEQUENCE WHERE gene_id = 6);


-- VIEW definitions (2)

-- 1. View showing detailed sequence information together with gene and organism
CREATE VIEW view_sequence_details AS
SELECT
  s.sequence_id,
  s.accession_number,
  s.sequence_type,
  s.sequence_length,
  s.source_database,
  g.gene_name,
  o.scientific_name AS organism_name
FROM SEQUENCE s
JOIN GENE g ON s.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id;

-- 2. View summarizing researcher activity (number of experiments per
SELECT experiment_type, COUNT(*) AS experiment_count
FROM EXPERIMENT
GROUP BY experiment_type;


-- UPDATE examples (2)

-- 1. Update email address of researcher #2
UPDATE RESEARCHER
SET email = 'rajesh.kumar@newinstitution.edu'
WHERE researcher_id = 2;

-- 2. Correct the sequence length of accession NM_005228 after re-annotation
UPDATE SEQUENCE
SET sequence_length = 2500
WHERE accession_number = 'NM_005228';


-- DELETE examples (2)
  
-- 1. Delete a low‑confidence annotation (id = 4)
DELETE FROM ANNOTATION
WHERE annotation_id = 4;

-- 2. Delete a gene that currently has no associated sequences (example gene_id = 6)
DELETE FROM GENE
WHERE gene_id = 6
AND NOT EXISTS (SELECT 1 FROM SEQUENCE WHERE gene_id = 6);

  
  
-- VIEW definitions (2)

-- 1. View showing detailed sequence information together with gene and organism
CREATE VIEW view_sequence_details AS
SELECT
  s.sequence_id,
  s.accession_number,
  s.sequence_type,
  s.sequence_length,
  s.source_database,
  g.gene_name,
  o.scientific_name AS organism_name
FROM SEQUENCE s
JOIN GENE g ON s.gene_id = g.gene_id
JOIN ORGANISM o ON g.organism_id = o.organism_id;

-- 2. View summarizing researcher activity (number of experiments per
SELECT experiment_type, COUNT(*) AS experiment_count
FROM EXPERIMENT
GROUP BY experiment_type;

  
-- UPDATE examples (2)

-- 1. Update email address of researcher #2
UPDATE RESEARCHER
SET email = 'rajesh.kumar@newinstitution.edu'
WHERE researcher_id = 2;

-- 2. Correct the sequence length of accession NM_005228 after re-annotation
UPDATE SEQUENCE
SET sequence_length = 2500
WHERE accession_number = 'NM_005228';


-- DELETE examples (2)

-- 1. Delete a low‑confidence annotation (id = 4)
DELETE FROM ANNOTATION
WHERE annotation_id = 4;

-- 2. Delete a gene that currently has no associated sequences (example gene_id = 6)
DELETE FROM GENE
WHERE gene_id = 6
AND NOT EXISTS (SELECT 1 FROM SEQUENCE WHERE gene_id = 6);  