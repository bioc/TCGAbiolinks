context("Query")


test_that("GDCquery can filter by data.category", {
    skip_on_bioc()
    skip_if_offline()

    query <- GDCquery(project = "TCGA-ACC",data.category = "Copy Number Variation")
    expect_equal(unique(query$results[[1]]$data_category),"Copy Number Variation")
    query <- GDCquery(project = "TCGA-ACC",data.category = "Copy Number Variation", data.type = "Copy Number Segment")
    expect_equal(unique(query$results[[1]]$data_type),"Copy Number Segment")
})

test_that("GDCquery accepts more than one project", {
    skip_on_bioc()
    skip_if_offline()

    acc <- GDCquery(
        project = "TCGA-ACC",
        data.category = "Copy Number Variation",
        data.type = "Copy Number Segment"
    )

    gbm <- GDCquery(
        project = "TCGA-GBM",
        data.category = "Copy Number Variation",
        data.type = "Copy Number Segment"
    )

    acc.gbm <- GDCquery(
        project =  c("TCGA-ACC","TCGA-GBM"),
        data.category = "Copy Number Variation",
        data.type = "Copy Number Segment"
    )

    expect_equal(unique(acc.gbm$results[[1]]$data_type),"Copy Number Segment")
    expect_equal(nrow(acc.gbm$results[[1]]), sum(nrow(acc$results[[1]]),nrow(gbm$results[[1]])))
    expect_true(nrow(dplyr::anti_join(acc$results[[1]],acc.gbm$results[[1]], by = "file_id")) == 0)
    expect_true(nrow(dplyr::anti_join(gbm$results[[1]],acc.gbm$results[[1]], by = "file_id")) == 0)
    expect_true(nrow(dplyr::anti_join(acc.gbm$results[[1]],acc$results[[1]], by = "file_id")) == nrow(gbm$results[[1]]))
})

test_that("GDCquery can filter by sample.type", {
    skip_on_bioc()
    skip_if_offline()

    sample.type <- "Primary Tumor"
    query <- GDCquery(
        project = "TCGA-ACC",
        data.category =  "Copy Number Variation",
        data.type = "Masked Copy Number Segment",
        sample.type = sample.type
    )
    expect_equal(as.character(unique(query$results[[1]]$sample_type)),sample.type)

    sample.type <- "Solid Tissue Normal"
    query <- GDCquery(
        project = "TCGA-ACC",
        data.category =  "Copy Number Variation",
        data.type = "Masked Copy Number Segment",
        sample.type = sample.type
    )
    expect_equal(as.character(unique(query$results[[1]]$sample_type)),sample.type)

    sample.type <- "Solid Tissue Normal"
    query <- GDCquery(
        project =  c("TCGA-COAD"),
        data.category = "Transcriptome Profiling",
        data.type = "Gene Expression Quantification",
        workflow.type = "STAR - Counts",
        sample.type = sample.type
    )
    expect_equal(as.character(unique(query$results[[1]]$sample_type)),sample.type)

    sample.type <- c("Solid Tissue Normal", "Primary Tumor")
    query <- GDCquery(
        project = "TCGA-ACC",
        data.category =  "Copy Number Variation",
        data.type = "Masked Copy Number Segment",
        sample.type = sample.type
    )
    expect_true(all(sample.type %in% unique(query$results[[1]]$sample_type)))
})

test_that("GDCquery can filter by barcode", {
    skip_on_bioc()
    skip_if_offline()

    barcode <- c("TARGET-20-PADZCG-04A-01R","TARGET-20-PARJCR-09A-01R")
    query <- GDCquery(
        project = "TARGET-AML",
        data.category = "Transcriptome Profiling",
        data.type = "Gene Expression Quantification",
        workflow.type = "STAR - Counts",
        barcode = barcode
    )
    expect_true(all(sort(barcode) == sort(unique(query$results[[1]]$cases))))
    barcode <- c( "TCGA-OR-A5KU-01A-11D-A29H-01", "TCGA-OR-A5JK-01A-11D-A29H-01")
    query <- GDCquery(
        project = "TCGA-ACC",
        data.category = "Copy Number Variation",
        data.type = "Copy Number Segment",
        barcode = barcode
    )
    expect_true(all(sort(barcode) == sort(unique(query$results[[1]]$cases))))
    barcode <- c("TCGA-OR-A5KU", "TCGA-OR-A5JK")
    query <- GDCquery(
        project = "TCGA-ACC",
        data.category = "Clinical",
        data.format = "bcr xml",
        barcode = barcode
    )
    expect_true(all(sort(barcode) == sort(unique(query$results[[1]]$cases))))

    # Will work if barcode was not found
    query <- GDCquery(
        project = "TCGA-BRCA",
        data.category = "Clinical",
        data.format = "bcr xml",
        barcode = c("TCGA-3C-AALK","TCGA-A2-A04Q","TCGA-A4-A04Q")
    )
    expect_true(!all(c("TCGA-3C-AALK","TCGA-A2-A04Q","TCGA-A4-A04Q") %in% query$results[[1]]$cases))
})


test_that("GDCquery can filter by access level", {
    skip_on_bioc()
    skip_if_offline()

    query <- GDCquery(
        project = "TCGA-KIRP",
        data.category = "Simple Nucleotide Variation",
        access = "open"
    )
    expect_equal(unique(query$results[[1]]$access),"open")

    query <- GDCquery(
        project = "TCGA-KIRP",
        data.category = "Simple Nucleotide Variation",
        data.type = "Raw Simple Somatic Mutation",
        access = "controlled"
    )
    expect_equal(unique(query$results[[1]]$access),"controlled")
})

test_that("getNbFiles and getNbCases works", {
    skip_on_bioc()
    skip_if_offline()

    aux <- getProjectSummary(project = "TCGA-LUAD")
    files <- getNbFiles("TCGA-LUAD","Raw microarray data")
    cases <- getNbCases("TCGA-LUAD","Raw microarray data")
    expect_true(cases < files)
})
