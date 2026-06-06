 # Gene Sequence Database System
  *A Relational DBMS for Managing DNA/Protein Sequences in Bioinformatics*

  ---

  ## 🎯 Project Overview

  This repository contains a fully‑normalized relational database designed for bioinformatics research labs.
  It stores **organisms**, **genes**, **sequences**, **researchers**, **annotations**, and **experiments** while preserving provenance, uniqueness (e.g.,
  accession numbers), and confidence scores.

  The schema enables complex queries such as “find all human genes with high‑confidence functional annotations” and provides a solid foundation for
  downstream pipelines (BLAST, ML‑based variant prediction, web front‑ends, etc.).


  ---

  ## 🛠️ Technologies Used

  | Category        | Tool / Technology                                 |
  |-----------------|--------------------------------------------------|
  | Database Engine | MySQL 8.0 (compatible with PostgreSQL/SQLite) |
  | Diagramming     | Mermaid.js (ER diagram)                          |
  | Scripting       | Standard ANSI‑SQL (CREATE, INSERT, UPDATE, …)    |
  | Optional Dev    | Docker (MySQL image) – for reproducible setup    |
  | Documentation   | Markdown (`README.md`)                           |
  | Version Control | GitHub                                             |

  ---

  ## 📂 Repository Structure

  /
  ├─ schema.sql               # Master SQL script (CREATE, INSERT, VIEW, INDEX)
  ├─ er_diagram.mmd           # Mermaid source for the ER diagram
  ├─ README.md                # ← You are here
  └─ docs/
     └─ presentation/          # Slides (PowerPoint / PDF) – not included in this repo

  ---

  ## 📊 Schema Overview

  | Table        | Primary Key | Main Attributes (excerpt)                              | Description |
  |--------------|------------|--------------------------------------------------------|-------------|
  | **ORGANISM**   | `organism_id` | `scientific_name`, `common_name`, `taxonomy_class`, `genome_size_mb` | Taxonomic record for each species. |
  | **GENE**        | `gene_id`    | `gene_name`, `organism_id` (FK), `chromosome_location`, `gene_function`, `is_coding` | Gene loci linked to an organism.
  |
  | **SEQUENCE**    | `sequence_id`| `gene_id` (FK), `sequence_type` (DNA/RNA/Protein), `sequence_data`, `sequence_length`, `accession_number` (UNIQUE) |
  Raw sequence data with source metadata. |
  | **RESEARCHER**  | `researcher_id`| `full_name`, `institution`, `email` (UNIQUE), `specialization` | People who curate or run experiments. |
  | **ANNOTATION**  | `annotation_id`| `sequence_id` (FK), `researcher_id` (FK), `annotation_type`, `annotation_text`, `confidence_score` | Expert comments
  on a sequence with a confidence metric. |
  | **EXPERIMENT**  | `experiment_id`| `gene_id` (FK), `researcher_id` (FK), `experiment_name`, `experiment_type`, `start_date`, `end_date`,
  `result_summary` | Laboratory studies linked to genes & researchers. |

  **Relationships (1‑to‑Many)**

  - ORGANISM → GENE
  - GENE → SEQUENCE
  - SEQUENCE → ANNOTATION
  - RESEARCHER → ANNOTATION
  - GENE → EXPERIMENT
  - RESEARCHER → EXPERIMENT

  The full ER diagram can be rendered from `er_diagram.mmd` using Mermaid.

  ---

  ## 🚀 Getting Started

  ### Prerequisites

  1. **MySQL server** (or MariaDB) installed locally, or Docker installed if you prefer containerisation.
  2. Sufficient privileges to create a new database (`CREATE DATABASE`).

  ### Option A – Native MySQL

  ```bash
  # 1. Clone the repository
  git clone https://github.com/your-username/gene-sequence-dbms.git
  cd gene-sequence-dbms

  # 2. Load the schema (you will be prompted for MySQL credentials)
  mysql -u <user> -p < schema.sql

  Option B – Docker (quick isolated environment)

  # Pull the official MySQL image
  docker pull mysql:8.0

  # Run a container (change root password as needed)
  docker run --name gene-db -e MYSQL_ROOT_PASSWORD=secret -p 3306:3306 -d mysql:8.0

  # Copy the script into the container and execute it
  docker cp schema.sql gene-db:/schema.sql
  docker exec -i gene-db mysql -uroot -psecret < /schema.sql

  Once the script finishes, the database gene_sequence_db will contain all tables, sample data, indexes, and two convenience views:

  - view_sequence_details – detailed info per sequence (gene + organism).
  - view_researcher_summary – number of experiments per researcher.

  ---
  📋 Sample Queries & Expected Output

  Below are three representative queries you can run to verify the installation.

  1️⃣ List all genes together with their organism’s scientific name

  SELECT g.gene_name,
         o.scientific_name AS organism
  FROM   GENE g
  JOIN   ORGANISM o ON g.organism_id = o.organism_id
  ORDER BY g.gene_name;

  Expected output

  ┌──────────────────┬──────────────────────────┐
  │    gene_name     │         organism         │
  ├──────────────────┼──────────────────────────┤
  │ BRCA1            │ Homo sapiens             │
  ├──────────────────┼──────────────────────────┤
  │ CFTR             │ Homo sapiens             │
  ├──────────────────┼──────────────────────────┤
  │ EGFR             │ Mus musculus             │
  ├──────────────────┼──────────────────────────┤
  │ GAL4             │ Saccharomyces cerevisiae │
  ├──────────────────┼──────────────────────────┤
  │ GAPDH* (example) │ ...                      │
  └──────────────────┴──────────────────────────┘

  (Only a subset shown; the full result includes all 10 sample genes.)

  ---
  2️⃣ Count the total number of sequences per organism

  SELECT o.scientific_name AS organism,
         COUNT(s.sequence_id) AS total_sequences
  FROM   ORGANISM o
  JOIN   GENE g   ON o.organism_id = g.organism_id
  JOIN   SEQUENCE s ON g.gene_id = s.gene_id
  GROUP BY o.organism_id, o.scientific_name;

  Expected output

  ┌──────────────────────────┬─────────────────┐
  │         organism         │ total_sequences │
  ├──────────────────────────┼─────────────────┤
  │ Homo sapiens             │ 10              │
  ├──────────────────────────┼─────────────────┤
  │ Mus musculus             │ 5               │
  ├──────────────────────────┼─────────────────┤
  │ Escherichia coli         │ 2               │
  ├──────────────────────────┼─────────────────┤
  │ Saccharomyces cerevisiae │ 2               │
  ├──────────────────────────┼─────────────────┤
  │ Arabidopsis thaliana     │ 1               │
  └──────────────────────────┴─────────────────┘

  ---
  3️⃣ Retrieve the latest annotation (by date) for each sequence

  SELECT a.annotation_id,
         s.accession_number,
         a.annotation_text,
         a.annotation_date,
         r.full_name AS annotated_by
  FROM   ANNOTATION a
  JOIN   SEQUENCE s   ON a.sequence_id = s.sequence_id
  JOIN   RESEARCHER r ON a.researcher_id = r.researcher_id
  JOIN (
          SELECT sequence_id, MAX(annotation_date) AS max_date
          FROM   ANNOTATION
          GROUP BY sequence_id
        ) latest
        ON a.sequence_id = latest.sequence_id
       AND a.annotation_date = latest.max_date
  ORDER BY s.accession_number;

  Expected output

  ┌───────────────┬──────────────────┬──────────────────────────────────────────────────────────────┬─────────────────┬──────────────┐
  │ annotation_id │ accession_number │                       annotation_text                        │ annotation_date │ annotated_by │
  ├───────────────┼──────────────────┼──────────────────────────────────────────────────────────────┼─────────────────┼──────────────┤
  │ 1             │ NM_007294        │ BRCA1 contains a BRCT domain involved in DNA repair.         │ 2025-03-01      │ Priya Patel  │
  ├───────────────┼──────────────────┼──────────────────────────────────────────────────────────────┼─────────────────┼──────────────┤
  │ 3             │ NM_000492        │ Common CFTR ΔF508 deletion leads to cystic fibrosis.         │ 2025-03-05      │ Ananya Singh │
  ├───────────────┼──────────────────┼──────────────────────────────────────────────────────────────┼─────────────────┼──────────────┤
  │ 5             │ NM_001221        │ GAL4 binds upstream activation sequences in yeast promoters. │ 2025-04-02      │ Maria Gomez  │
  ├───────────────┼──────────────────┼──────────────────────────────────────────────────────────────┼─────────────────┼──────────────┤
  │ …             │ …                │ …                                                            │ …               │ …            │
  └───────────────┴──────────────────┴──────────────────────────────────────────────────────────────┴─────────────────┴──────────────┘

  ---
  📦 License

  This project is released under the MIT License – you are free to use, modify, and distribute it in academic or commercial settings, provided the original
  license notice is included.

  ---
  📚 References

  1. NCBI Resource Coordinators. Database resources of the National Center for Biotechnology Information. Nucleic Acids Res. 2025.
  2. UniProt Consortium. UniProt: a worldwide hub of protein knowledge. Nucleic Acids Res. 2025.
  3. Korth, H. F., & Ramakrishnan, R. Database System Concepts (9th ed.). McGraw‑Hill, 2022.

