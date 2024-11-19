
DROP TABLE xxmx_po_headers_all;
DROP TABLE xxmx_po_headers_archive_all;

CREATE TABLE xxmx_po_headers_all
AS
SELECT *
FROM   apps.po_headers_all@MXDM_NVIS_EXTRACT pha
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id        = pha.po_header_id
                AND    mv.po_source           = 'PO_HEADERS_ALL'
                AND    mv.header_revision_num = pha.revision_num );

CREATE TABLE xxmx_po_headers_archive_all
AS
SELECT *
FROM   apps.po_headers_archive_all@MXDM_NVIS_EXTRACT pha
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id        = pha.po_header_id
                AND    mv.po_source           = 'PO_HEADERS_ARCHIVE_ALL'
                AND    mv.header_revision_num = pha.revision_num );

DROP TABLE xxmx_po_lines_all;
DROP TABLE xxmx_po_lines_archive_all;

CREATE TABLE xxmx_po_lines_all
AS
SELECT *
FROM   apps.po_lines_all@MXDM_NVIS_EXTRACT pla
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id = pla.po_header_id
                AND    mv.po_line_id   = pla.po_line_id
                AND    mv.po_source    = 'PO_HEADERS_ALL' );

CREATE TABLE xxmx_po_lines_archive_all
AS
SELECT *
FROM   apps.po_lines_archive_all@MXDM_NVIS_EXTRACT pla
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id      = pla.po_header_id
                AND    mv.po_line_id        = pla.po_line_id
                AND    mv.po_source         = 'PO_HEADERS_ARCHIVE_ALL'
                AND    mv.line_revision_num = pla.revision_num );

DROP TABLE xxmx_po_line_locations_all;
DROP TABLE xxmx_po_line_locations_archive_all;

CREATE TABLE xxmx_po_line_locations_all
AS
SELECT *
FROM   apps.po_line_locations_all@MXDM_NVIS_EXTRACT plla
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id     = plla.po_header_id
                AND    mv.po_line_id       = plla.po_line_id
                AND    mv.line_location_id = plla.line_location_id
                AND    mv.po_source        = 'PO_HEADERS_ALL');

CREATE TABLE xxmx_po_line_locations_archive_all
AS
SELECT *
FROM   apps.po_line_locations_archive_all@MXDM_NVIS_EXTRACT plla
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id          = plla.po_header_id
                AND    mv.po_line_id            = plla.po_line_id
                AND    mv.line_location_id      = plla.line_location_id
                AND    mv.po_source             = 'PO_HEADERS_ARCHIVE_ALL'
                AND    mv.location_revision_num = plla.revision_num );

DROP TABLE xxmx_po_distributions_all;
DROP TABLE xxmx_po_distributions_archive_all;

CREATE TABLE xxmx_po_distributions_all
AS
SELECT *
FROM   apps.po_distributions_all@MXDM_NVIS_EXTRACT pda
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id       = pda.po_header_id
                AND    mv.po_line_id         = pda.po_line_id
                AND    mv.line_location_id   = pda.line_location_id
                AND    mv.po_distribution_id = pda.po_distribution_id
                AND    mv.po_source          = 'PO_HEADERS_ALL' );

CREATE TABLE xxmx_po_distributions_archive_all
AS
SELECT *
FROM   apps.po_distributions_archive_all@MXDM_NVIS_EXTRACT pda
WHERE  EXISTS ( SELECT 1
                FROM   xxmx_po_open_quantity_mv mv
                WHERE  mv.po_header_id              = pda.po_header_id
                AND    mv.po_line_id                = pda.po_line_id
                AND    mv.line_location_id          = pda.line_location_id
                AND    mv.po_distribution_id        = pda.po_distribution_id
                AND    mv.po_source                 = 'PO_HEADERS_ARCHIVE_ALL'
                AND    mv.distribution_revision_num = pda.revision_num );


