% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query.R
\name{GDCquery}
\alias{GDCquery}
\title{Query GDC data}
\usage{
GDCquery(
  project,
  data.category,
  data.type,
  workflow.type,
  access,
  platform,
  barcode,
  data.format,
  experimental.strategy,
  sample.type
)
}
\arguments{
\item{project}{A list of valid project (see list with TCGAbiolinks:::getGDCprojects()$project_id)]
\itemize{
\item{ BEATAML1.0-COHORT }
\item{ BEATAML1.0-CRENOLANIB }
\item{ CGCI-BLGSP }
\item{ CPTAC-2 }
\item{ CPTAC-3 }
\item{ CTSP-DLBCL1 }
\item{ FM-AD }
\item{ HCMI-CMDC }
\item{ MMRF-COMMPASS }
\item{ NCICCR-DLBCL }
\item{ OHSU-CNL }
\item{ ORGANOID-PANCREATIC }
\item{ TARGET-ALL-P1 }
\item{ TARGET-ALL-P2 }
\item{ TARGET-ALL-P3 }
\item{ TARGET-AML }
\item{ TARGET-CCSK }
\item{ TARGET-NBL }
\item{ TARGET-OS }
\item{ TARGET-RT }
\item{ TARGET-WT }
\item{ TCGA-ACC }
\item{ TCGA-BLCA }
\item{ TCGA-BRCA }
\item{ TCGA-CESC }
\item{ TCGA-CHOL }
\item{ TCGA-COAD }
\item{ TCGA-DLBC }
\item{ TCGA-ESCA }
\item{ TCGA-GBM }
\item{ TCGA-HNSC }
\item{ TCGA-KICH }
\item{ TCGA-KIRC }
\item{ TCGA-KIRP }
\item{ TCGA-LAML }
\item{ TCGA-LGG }
\item{ TCGA-LIHC }
\item{ TCGA-LUAD }
\item{ TCGA-LUSC }
\item{ TCGA-MESO }
\item{ TCGA-OV }
\item{ TCGA-PAAD }
\item{ TCGA-PCPG }
\item{ TCGA-PRAD }
\item{ TCGA-READ }
\item{ TCGA-SARC }
\item{ TCGA-SKCM }
\item{ TCGA-STAD }
\item{ TCGA-TGCT }
\item{ TCGA-THCA }
\item{ TCGA-THYM }
\item{ TCGA-UCEC }
\item{ TCGA-UCS }
\item{ TCGA-UVM }
\item{ VAREPOP-APOLLO }
}}

\item{data.category}{A valid project (see list with TCGAbiolinks:::getProjectSummary(project))
For the complete list please check the vignette.
List for harmonized database:
\itemize{
\item{ Biospecimen }
\item{ Clinical }
\item{ Copy Number Variation }
\item{ DNA Methylation }
\item{ Sequencing Reads }
\item{ Simple Nucleotide Variation }
\item{ Transcriptome Profiling }
}}

\item{data.type}{A data type to filter the files to download
For the complete list please check the vignette.}

\item{workflow.type}{GDC workflow type}

\item{access}{Filter by access type. Possible values: controlled, open}

\item{platform}{Example:
\tabular{ll}{
CGH- 1x1M_G4447A                   \tab IlluminaGA_RNASeqV2   \cr
AgilentG4502A_07                  \tab IlluminaGA_mRNA_DGE    \cr
Human1MDuo                        \tab HumanMethylation450    \cr
HG-CGH-415K_G4124A                \tab IlluminaGA_miRNASeq    \cr
HumanHap550                       \tab IlluminaHiSeq_miRNASeq \cr
ABI                               \tab H-miRNA_8x15K  \cr
HG-CGH-244A                       \tab SOLiD_DNASeq                \cr
IlluminaDNAMethylation_OMA003_CPI \tab IlluminaGA_DNASeq_automated   \cr
IlluminaDNAMethylation_OMA002_CPI \tab HG-U133_Plus_2                 \cr
HuEx- 1_0-st-v2 \tab Mixed_DNASeq                  \cr
H-miRNA_8x15Kv2 \tab IlluminaGA_DNASeq_curated      \cr
MDA_RPPA_Core   \tab IlluminaHiSeq_TotalRNASeqV2    \cr
HT_HG-U133A     \tab IlluminaHiSeq_DNASeq_automated \cr
diagnostic_images                 \tab microsat_i                     \cr
IlluminaHiSeq_RNASeq              \tab SOLiD_DNASeq_curated           \cr
IlluminaHiSeq_DNASeqC             \tab Mixed_DNASeq_curated           \cr
IlluminaGA_RNASeq                 \tab IlluminaGA_DNASeq_Cont_automated  \cr
IlluminaGA_DNASeq                 \tab IlluminaHiSeq_WGBS             \cr
pathology_reports                 \tab IlluminaHiSeq_DNASeq_Cont_automated\cr
Genome_Wide_SNP_6                 \tab bio                            \cr
tissue_images                     \tab Mixed_DNASeq_automated         \cr
HumanMethylation27                \tab Mixed_DNASeq_Cont_curated      \cr
IlluminaHiSeq_RNASeqV2            \tab Mixed_DNASeq_Cont
}}

\item{barcode}{A list of barcodes to filter the files to download}

\item{data.format}{Data format filter ("VCF", "TXT", "BAM","SVS","BCR XML","BCR SSF XML",
"TSV", "BCR Auxiliary XML", "BCR OMF XML", "BCR Biotab", "MAF", "BCR PPS XML", "XLSX")}

\item{experimental.strategy}{Filter to experimental strategy.
Harmonized: WXS, RNA-Seq, miRNA-Seq, Genotyping Array.}

\item{sample.type}{A sample type to filter the files to download}
}
\value{
A data frame with the results and the parameters used
}
\description{
Uses GDC API to search for search, it searches for both controlled and
  open-access data.
  For GDC data arguments project, data.category, data.type and workflow.type should be used
  Please, see the vignette for a table with the possibilities.
}
\examples{
query <- GDCquery(
   project = "TCGA-ACC",
   data.category = "Copy Number Variation",
   data.type = "Copy Number Segment"
)
\dontrun{
query <- GDCquery(
  project = "TARGET-AML",
  data.category = "Transcriptome Profiling",
  data.type = "miRNA Expression Quantification",
  workflow.type = "BCGSC miRNA Profiling",
  barcode = c("TARGET-20-PARUDL-03A-01R","TARGET-20-PASRRB-03A-01R")
)
query <- GDCquery(
   project = "TARGET-AML",
   data.category = "Transcriptome Profiling",
   data.type = "Gene Expression Quantification",
   workflow.type = "STAR - Counts",
   barcode = c("TARGET-20-PADZCG-04A-01R","TARGET-20-PARJCR-09A-01R")
)
query <- GDCquery(
   project = "TCGA-ACC",
   data.category =  "Copy Number Variation",
   data.type = "Masked Copy Number Segment",
   sample.type = c("Primary Tumor")
)
}
}
\author{
Tiago Chedraoui Silva
}
