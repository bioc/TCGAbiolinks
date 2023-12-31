context("Download and prepare")

test_that("GDCdownload API method is working ", {
    skip_on_bioc()
    skip_if_offline()

    cases <- c(
        "TCGA-PA-A5YG-01A-11R-A29S-07",
        "TCGA-OR-A5JX-01A-11R-A29S-07",
        "TCGA-PK-A5HA-01A-11R-A29S-07",
        "TCGA-OR-A5KY-01A-11R-A29S-07"
    )

    acc <- GDCquery(
        project =  c("TCGA-ACC"),
        data.category = "Transcriptome Profiling",
        data.type = "Gene Expression Quantification",
        workflow.type = "STAR - Counts",
        barcode = substr(cases,1,12)
    )
    GDCdownload(acc, method = "api", directory = "ex")
    obj <- GDCprepare(acc,  directory = "ex",summarizedExperiment = TRUE)

    expect_true(all(substr(colnames(obj),1,12) == substr(cases,1,12)))
    expect_true(all(obj$barcode == cases))

    # Checking the data matches the file for a random gene
    expect_equal(assays(obj)$unstranded["ENSG00000003756.17","TCGA-PK-A5HA-01A-11R-A29S-07"], 3584)
    expect_equal(assays(obj)$stranded_first["ENSG00000003756.17","TCGA-PK-A5HA-01A-11R-A29S-07"], 2628)
    expect_equal(assays(obj)$stranded_second["ENSG00000003756.17","TCGA-PK-A5HA-01A-11R-A29S-07"], 2612)
    expect_equal(assays(obj)$tpm_unstrand["ENSG00000003756.17","TCGA-PK-A5HA-01A-11R-A29S-07"], 13.2758)
    expect_equal(assays(obj)$fpkm_unstrand["ENSG00000003756.17","TCGA-PK-A5HA-01A-11R-A29S-07"], 7.0563)
    expect_equal(assays(obj)$fpkm_uq_unstrand["ENSG00000003756.17","TCGA-PK-A5HA-01A-11R-A29S-07"], 9.8086)

    query <- GDCquery(
        project = "CPTAC-3",
        data.category = "Transcriptome Profiling",
        data.type = "Gene Expression Quantification",
        workflow.type = "STAR - Counts",
        barcode = c("CPT0010260013","CPT0000870008","CPT0105190006","CPT0077490006")
    )
    GDCdownload(query)
    data <- GDCprepare(query)
    expect_true(all(query$results[[1]]$sample.submitter_id == colnames(data)))
    expect_true(all(query$results[[1]]$sample.submitter_id == data$sample_submitter_id))
})

test_that("getBarcodeInfo works", {
    skip_on_bioc()
    skip_if_offline()

    cols <- c("gender","project_id","days_to_last_follow_up","alcohol_history")
    x <- getBarcodeInfo(c("TCGA-OR-A5LR-01A", "TCGA-OR-A5LJ-01A"))
    expect_true(all(cols %in% colnames(x)))

    cols <- c("gender","project_id")
    x <- getBarcodeInfo(c("TARGET-20-PARUDL-03A"))
    expect_true(all(cols %in% colnames(x)))

    samples <- c(
        "HCM-CSHL-0063-C18-85A",
        "HCM-CSHL-0065-C20-06A",
        "HCM-CSHL-0065-C20-85A",
        "HCM-CSHL-0063-C18-01A"
    )
    x <- colDataPrepare(samples)

    expect_true(all(rownames(x) == samples))
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","gender"] == "male")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","tumor_grade"] == "G2")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","ajcc_pathologic_stage"] == "Stage IVA")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","sample_type"] == "Metastatic")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0063-C18-85A","sample_type"] == "Next Generation Cancer Model")

    x <- getBarcodeInfo(
        c("HCM-CSHL-0063-C18-85A",
          "HCM-CSHL-0065-C20-06A",
          "HCM-CSHL-0065-C20-85A",
          "TARGET-20-PARUDL-03A",
          "TCGA-OR-A5LR-01A",
          "HCM-CSHL-0063-C18-01A")
    )
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","gender"] == "male")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","tumor_grade"] == "G2")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","ajcc_pathologic_stage"] == "Stage IVA")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0065-C20-06A","sample_type"] == "Metastatic")
    expect_true(x[x$sample_submitter_id == "HCM-CSHL-0063-C18-85A","sample_type"] == "Next Generation Cancer Model")

})

test_that("colDataPrepare handle replicates", {
    skip_on_bioc()
    skip_if_offline()
    barcodes <- c("TCGA-06-0156-01A-02R-1849-01","TCGA-06-0156-01A-03R-1849-01")
    x <- colDataPrepare(barcodes)
    expect_true(nrow(x) == 2)
    expect_true(all(rownames(x) == c("TCGA-06-0156-01A-02R-1849-01","TCGA-06-0156-01A-03R-1849-01")))
    expect_true(all(x$barcode == c("TCGA-06-0156-01A-02R-1849-01","TCGA-06-0156-01A-03R-1849-01")))
})

test_that("GDCprepare accepts more than one project", {
    skip_on_bioc()
    skip_if_offline()
    cases <-  c(
        "TCGA-OR-A5JX-01A",
        "TCGA-OR-A5J3-01A",
        "TCGA-06-0680-11A",
        "TCGA-14-0871-01A"
    )
    expect_true(all(c("TCGA-ACC","TCGA-GBM") %in% colDataPrepare(cases)$project_id))
    query_acc_gbm <- GDCquery(
        project =  c("TCGA-ACC","TCGA-GBM"),
        data.category = "Transcriptome Profiling",
        data.type = "Gene Expression Quantification",
        workflow.type = "STAR - Counts",
        barcode = substr(cases, 1, 12)
    )
    GDCdownload(query_acc_gbm, method = "api", directory = "ex")
    obj <- GDCprepare(query_acc_gbm,  directory = "ex")
    expect_true(all(c("TCGA-ACC","TCGA-GBM") %in% SummarizedExperiment::colData(obj)$project_id))
})

test_that("Non TCGA data is processed", {
    skip_on_bioc()
    skip_if_offline()

    query <- GDCquery(
        project = "MMRF-COMMPASS",
        data.category = "Transcriptome Profiling",
        data.type = "Gene Expression Quantification",
        workflow.type = "STAR - Counts",
        barcode = c(
            "MMRF_2737_1_BM_CD138pos_T2_TSMRU_L14993",
            "MMRF_2739_1_BM_CD138pos_T2_TSMRU_L15000",
            "MMRF_1865_1_BM_CD138pos_T2_TSMRU_L05342"
        )
    )
    GDCdownload(query,directory = "ex")
    data <- GDCprepare(query,directory = "ex")
    expect_true(ncol(data) == 3)
    unlink("ex", recursive = TRUE, force = TRUE)
})

test_that("Gene Level Copy Number is being correctly prepare", {
    skip_on_bioc()
    skip_if_offline()

    query <- GDCquery(
        project = "TCGA-ACC",
        data.category = "Copy Number Variation",
        data.type = "Gene Level Copy Number",
        access = "open",
        barcode = c("TCGA-OR-A5JD","TCGA-OR-A5J7")
    )
    GDCdownload(query,directory = "ex")
    data <- GDCprepare(query,directory = "ex")

    expect_true(all(substr(colnames(data),1,12) == c("TCGA-OR-A5JD","TCGA-OR-A5J7")))
    expect_equal(data$days_to_last_follow_up,c(3038,NA))
    unlink("ex", recursive = TRUE, force = TRUE)
})

test_that("Gene Level Copy Number is being correctly prepare for CPTAC-3", {
    skip_on_bioc()
    skip_if_offline()

    query_CPTAC = GDCquery(
        project = "CPTAC-3",
        data.category = "Copy Number Variation",
        data.type = "Gene Level Copy Number",
        barcode = c("CPT0115240002","CPT0088960002")
    )

    GDCdownload(query_CPTAC,directory = "ex")
    data <- GDCprepare(query_CPTAC,directory = "ex")
    expect_true(ncol(data) == 2)
    expect_equal(data$submitter_id, c("C3L-02544","C3N-01179"))
    expect_equal(data$days_to_last_follow_up, c("889","1816"))
    unlink("ex", recursive = TRUE, force = TRUE)
})

test_that("DNAm files is processed correctly", {
    skip_on_bioc()
    skip_if_offline()

    query_met.hg38 <- GDCquery(
        project = "TCGA-BRCA",
        data.category = "DNA Methylation",
        data.type = "Methylation Beta Value",
        platform = "Illumina Human Methylation 27",
        barcode = c("TCGA-B6-A0IM","TCGA-A2-A0CL","TCGA-E2-A158","TCGA-AN-A0AR")
    )
    GDCdownload(query_met.hg38)
    data.hg38 <- GDCprepare(query_met.hg38)
    expect_lt(abs(assay(data.hg38)["cg16739396","TCGA-E2-A158-01A-11D-A12E-05"] - 0.0688655418909783),10^-10)
})

test_that("Prepare samples without clinical data", {
    skip_on_bioc()
    skip_if_offline()

    # x <-  GDCquery_clinic(project = "TCGA-LUAD", type = "clinical")
    # x[is.na(x$diagnosis_id),]
    x <- colDataPrepare(c("TCGA-80-5608-01A","TCGA-17-Z053-01A","TCGA-78-7158-01A"))
    expect_true(nrow(x) == 3)
})

test_that("Prepare multiple samples from the same patient", {
    skip_on_bioc()
    skip_if_offline()

    # https://portal.gdc.cancer.gov/cases/d7d3de82-802d-4664-8e42-d40408b129b0?bioId=548a300f-a7eb-4dc0-b9bc-5a643ef03d5d
    x <- colDataPrepare(c("BA2691R","BA2577R","BA2748R","BA2577D"))
    expect_true(nrow(x) == 4)
    expect_equal(x["BA2748R","sample_type"],"Primary Blood Derived Cancer - Bone Marrow")
    expect_equal(x["BA2577D","sample_type"],"Recurrent Blood Derived Cancer - Bone Marrow")
    expect_true("age_at_diagnosis" %in% colnames(x))
})

test_that("Preparing RRPA files with number of proteins works", {
    skip_on_bioc()
    skip_if_offline()

    query_rppa <- GDCquery(
        project = c("TCGA-COAD"),
        data.category = "Proteome Profiling",
        experimental.strategy = "Reverse Phase Protein Array",
        platform = "RPPA",
        barcode = c("TCGA-CM-6165-01A","TCGA-DM-A28M-01A"),
        data.type = "Protein Expression Quantification"
    )

    GDCdownload(query_rppa)

    expect_message(
        object = {
            data_rppa <- GDCprepare(query_rppa)
        },
        regexp = "Some files have a  different number of proteins, we will introduce NA for the missing values"
    )

    expect_true(is(data_rppa,"data.frame"))
})

test_that("GDCdownload works for files.per.chunk = 1", {
    skip_on_bioc()
    skip_if_offline()

    query <- GDCquery(
        project = "TCGA-ACC",
        data.category = "Copy Number Variation",
        data.type = "Copy Number Segment",
        barcode = c("TCGA-OR-A5L1")
    )
    expect_no_error({GDCdownload(query, files.per.chunk = 1)})

    expect_true(
        all(
            file.exists(
                file.path("GDCdata/TCGA-ACC/Copy_Number_Variation/Copy_Number_Segment",
                          query$results[[1]]$id,
                          query$results[[1]]$file_name))
        )
    )

    query2 <- GDCquery(
        project = "TCGA-ACC",
        data.category = "Copy Number Variation",
        data.type = "Copy Number Segment",
        barcode = c("TCGA-OR-A5JO")
    )
    expect_no_error({GDCdownload(query2, files.per.chunk = 2)})
    expect_true(
        all(
            file.exists(
                file.path("GDCdata/TCGA-ACC/Copy_Number_Variation/Copy_Number_Segment",
                          query2$results[[1]]$id,
                          query2$results[[1]]$file_name))
        )
    )

})


test_that("Works for TARGET-AML data", {
    skip_on_bioc()
    skip_if_offline()


    query <- GDCquery(
        project = "TARGET-AML",
        data.category = "Transcriptome Profiling",
        experimental.strategy = "RNA-Seq",
        workflow.type = "STAR - Counts",
        data.type = "Gene Expression Quantification",
        access = "open",
        barcode = c(
            "TARGET-20-PAYHMK-Sorted-leukemic",
            "TARGET-20-D7-Myeloid-mock3",
            "TARGET-20-TF1-50A",
            "TARGET-20-PAWUEX-EOI2-14A",
            "TARGET-20-PAWMII-14A"
        )
    )

    GDCdownload(query)
    expect_equal(nrow(query$results[[1]]),5)
    expect_no_error({
        data <- GDCprepare(query, summarizedExperiment = TRUE)
    })
    expect_equal(ncol(data),5)
})


test_that("Works for TARGET-AML data", {
    skip_on_bioc()
    skip_if_offline()


    query <- GDCquery(
        project = "TARGET-AML",
        data.category = "Transcriptome Profiling",
        experimental.strategy = "RNA-Seq",
        workflow.type = "STAR - Counts",
        data.type = "Gene Expression Quantification",
        access = "open",
        barcode = c(
            "TARGET-20-PAYHMK-Sorted-leukemic",
            "TARGET-20-D7-Myeloid-mock3",
            "TARGET-20-TF1-50A",
            "TARGET-20-PAWUEX-EOI2-14A",
            "TARGET-20-PAWMII-14A"
        )
    )

    GDCdownload(query)
    expect_equal(nrow(query$results[[1]]),5)
    expect_no_error({
        data <- GDCprepare(query, summarizedExperiment = TRUE)
    })
    expect_equal(ncol(data),5)
})



test_that("Works for TARGET-NBL data", {
    skip_on_bioc()
    skip_if_offline()


    query <- GDCquery(
        project = "TARGET-NBL",
        data.category = "Transcriptome Profiling",
        experimental.strategy = "RNA-Seq",
        workflow.type = "STAR - Counts",
        data.type = "Gene Expression Quantification",
        access = "open",
        barcode = c(
            "TARGET-30-PASYPX-01A-01R",
            "TARGET-30-PANKFE-01A-01R",
            "TARGET-30-PAIXIF-01A-01R",
            "TARGET-20-PAWUEX-EOI2-14A",
            "TARGET-30-PAPUAR-01A-01R",
            "TARGET-30-PASCFC-01A",
            "TARGET-30-PAPTFZ-01A"
        )
    )

    GDCdownload(query)
    expect_equal(nrow(query$results[[1]]),7)
    expect_no_error({
        data <- GDCprepare(query, summarizedExperiment = TRUE)
    })
    expect_equal(ncol(data),7)
})




test_that("Works for TARGET-ALL-P3 data", {
    skip_on_bioc()
    skip_if_offline()


    #"TARGET-ALL-P2",  no exceptions - working
    # "TARGET-WT", no exceptions - working
    # "TARGET-OS", , no exceptions - working
    # "TARGET-RT",  no exceptions - working
    # "TARGET-CCSK", no exceptions - working
    #"TARGET-ALL-P1" , no exceptions - working

    query <- GDCquery(
        project =  "TARGET-ALL-P3",
        data.category = "Transcriptome Profiling",
        experimental.strategy = "RNA-Seq",
        workflow.type = "STAR - Counts",
        data.type = "Gene Expression Quantification",
        access = "open",
        barcode = c(
            "TARGET-20-SJAML045737",
            "TARGET-15-PAVFTF-09B-01R",
            "TARGET-20-SJAML045741-09A-01R",
            "TARGET-15-SJMPAL017975-03B-01R",
            "TARGET-15-PASZVW-09B-01R"
        )
    )
    expect_equal(nrow(query$results[[1]]),5)
    GDCdownload(query)
    expect_no_error({
        data <- GDCprepare(query, summarizedExperiment = TRUE)
    })
})



